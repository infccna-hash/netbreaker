import { useEffect, useState, useRef, useCallback } from "react";
import { useParams, Link } from "react-router-dom";
import { api, ApiError } from "../lib/api.js";
import { useAuth } from "../lib/auth.jsx";
import PhaseTrack from "../components/PhaseTrack.jsx";
import ConsolePanel from "../components/ConsolePanel.jsx";
import { renderMarkdown } from "../lib/markdown.js";

const PHASE_META = {
  build: { label: "Build", color: "var(--build)", tint: "var(--build-tint)" },
  attack: { label: "Attack", color: "var(--attack)", tint: "var(--attack-tint)" },
  harden: { label: "Harden", color: "var(--harden)", tint: "var(--harden-tint)" },
};
const ORDER = ["build", "attack", "harden"];

export default function LabDetail() {
  const { id } = useParams();
  const { user, isPro } = useAuth();
  const [lab, setLab] = useState(null);
  const [topology, setTopology] = useState(null);
  const [completed, setCompleted] = useState(new Set());
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [busyPhase, setBusyPhase] = useState(null);

  // ── Session (live lab orchestration) ────────────────────────────────
  const [session, setSession] = useState(null);       // current session object or null
  const [sessionLoading, setSessionLoading] = useState(false);
  const [activeNode, setActiveNode] = useState(null); // which tab is selected
  const pollingRef = useRef(null);

  const canLaunch = user && (lab?.is_free || isPro);

  // Poll session status while provisioning
  useEffect(() => {
    if (!session || (session.status !== "provisioning" && session.status !== "running")) {
      if (pollingRef.current) { clearInterval(pollingRef.current); pollingRef.current = null; }
      return;
    }
    if (pollingRef.current) return; // already polling

    pollingRef.current = setInterval(async () => {
      try {
        const s = await api.get(`/labsessions/${session.id}`);
        setSession(s);
        if (s.status === "running" && s.node_map) {
          const names = Object.keys(s.node_map);
          setActiveNode((prev) => (names.includes(prev) ? prev : names[0]));
        }
        if (s.status !== "provisioning" && s.status !== "running") {
          clearInterval(pollingRef.current);
          pollingRef.current = null;
        }
      } catch {
        clearInterval(pollingRef.current);
        pollingRef.current = null;
      }
    }, 2000);
    return () => { if (pollingRef.current) { clearInterval(pollingRef.current); pollingRef.current = null; } };
  }, [session?.id, session?.status]);

  // End session on unmount
  useEffect(() => {
    return () => {
      if (session?.id && (session.status === "provisioning" || session.status === "running")) {
        api.del(`/labsessions/${session.id}`).catch(() => {});
      }
    };
  }, [session?.id]);

  const launchSession = useCallback(async () => {
    setSessionLoading(true);
    setError("");
    try {
      const s = await api.post(`/labs/${id}/session`);
      setSession(s);
    } catch (err) {
      if (err instanceof ApiError && err.status === 403) {
        setError("Lab sessions require a Pro or Bootcamp plan.");
      } else if (err instanceof ApiError && err.status === 409) {
        setError("Max concurrent sessions reached. End another session first.");
      } else {
        setError(err.message || "Failed to launch session");
      }
    } finally {
      setSessionLoading(false);
    }
  }, [id]);

  const endSession = useCallback(async () => {
    if (!session?.id) return;
    try {
      await api.del(`/labsessions/${session.id}`);
    } catch { /* ignore */ }
    setSession(null);
    setActiveNode(null);
  }, [session?.id]);

  // ── Standard lab data loading ───────────────────────────────────────

  useEffect(() => {
    setLoading(true);
    setError("");
    Promise.all([
      api.get(`/labs/${id}`),
      api.get(`/labs/${id}/topology`).catch(() => null),
    ])
      .then(([labData, topo]) => {
        setLab(labData);
        setTopology(topo);
      })
      .catch((err) => setError(err.message))
      .finally(() => setLoading(false));
  }, [id]);

  useEffect(() => {
    if (!user) return;
    api.get("/progress")
      .then((p) => {
        const s = new Set();
        (p.items || []).forEach((it) => {
          if (String(it.lab_id) === String(id)) s.add(it.phase);
        });
        setCompleted(s);
      })
      .catch(() => {});
  }, [user, id]);

  async function togglePhase(phase) {
    if (!user) return;
    setBusyPhase(phase);
    const isDone = completed.has(phase);
    try {
      if (isDone) await api.del(`/progress/${id}/${phase}`);
      else await api.put(`/progress/${id}/${phase}`);
      setCompleted((prev) => {
        const n = new Set(prev);
        isDone ? n.delete(phase) : n.add(phase);
        return n;
      });
    } catch (err) {
      setError(err.message);
    } finally {
      setBusyPhase(null);
    }
  }

  async function downloadConfig() {
    try {
      const res = await api.get(`/labs/${id}/config`);
      if (res && res.download_url) window.open(res.download_url, "_blank", "noopener");
    } catch (err) {
      if (err instanceof ApiError && err.status === 403) setError("Config downloads are a Pro feature.");
      else setError(err.message);
    }
  }

  if (loading) return <div className="page-center"><div className="spinner" /></div>;
  if (error && !lab) return <div className="alert alert-error">{error}</div>;
  if (!lab) return null;

  const phases = ORDER
    .map((key) => (lab.phases || []).find((ph) => ph.phase === key))
    .filter(Boolean);
  const locked = !lab.is_free && !isPro;
  const nodeNames = session?.node_map ? Object.keys(session.node_map).sort() : [];

  return (
    <div className="stack-24">
      <div>
        <Link to="/labs" className="link mono" style={{ fontSize: "0.82rem" }}>← all labs</Link>
        <div className="section-head" style={{ marginTop: 10 }}>
          <div className="stack stack-8">
            <span className="lab-idx">LAB {String(lab.id).padStart(2, "0")} · {lab.topic} · {lab.difficulty}</span>
            <h1>{lab.title}</h1>
            {lab.book_ref && <span className="book-ref">📖 Maps to {lab.book_ref}</span>}
            <p className="lead" style={{ fontSize: "1rem" }}>{lab.short_desc}</p>
          </div>
          <PhaseTrack completed={[...completed]} />
        </div>
      </div>

      {error && <div className="alert alert-error">{error}</div>}

      {topology && (topology.svg_large || topology.svg_small) && (
        <div className="card card-pad stack-16">
          <div className="row between">
            <span className="eyebrow">Topology</span>
            {isPro && (
              <button className="btn btn-sm" onClick={downloadConfig}>Download starter config</button>
            )}
          </div>
          <div className="topology" dangerouslySetInnerHTML={{ __html: topology.svg_large || topology.svg_small }} />
          {Array.isArray(topology.legend) && topology.legend.length > 0 && (
            <div className="topo-legend">
              {topology.legend.map((item, i) => (
                <span key={i} className="topo-legend-item">{item}</span>
              ))}
            </div>
          )}
        </div>
      )}

      {/* ── Live Lab / Console Section ─────────────────────────────── */}
      {user && (lab.is_free || isPro) && (
        <div className="card card-pad stack-16">
          <div className="row between wrap" style={{ gap: 12 }}>
            <span className="eyebrow">🖥 Live Lab</span>
            {session?.status === "running" && (
              <button className="btn btn-sm btn-outline-danger" onClick={endSession}>
                End session
              </button>
            )}
          </div>

          {!session && (
            <div className="stack-8">
              <p className="muted" style={{ fontSize: "0.9rem" }}>
                Launch a live GNS3 session with all devices pre-wired and pre-configured.
                Your console opens directly in the browser — no external tools needed.
              </p>
              <div>
                <button
                  className="btn btn-primary"
                  onClick={launchSession}
                  disabled={sessionLoading}
                >
                  {sessionLoading ? <span className="spinner" /> : "🚀 Launch session"}
                </button>
              </div>
            </div>
          )}

          {session?.status === "provisioning" && (
            <div className="row" style={{ gap: 12, alignItems: "center", padding: "12px 0" }}>
              <div className="spinner" />
              <span className="muted">Provisioning your lab environment…</span>
            </div>
          )}

          {session?.status === "running" && nodeNames.length > 0 && (
            <div className="stack-8">
              {/* Node tabs */}
              <div className="row" style={{ gap: 4, flexWrap: "wrap" }}>
                {nodeNames.map((name) => (
                  <button
                    key={name}
                    className={"btn btn-sm " + (activeNode === name ? "btn-primary" : "")}
                    onClick={() => setActiveNode(name)}
                    style={{ fontFamily: "var(--mono)" }}
                  >
                    {name}
                  </button>
                ))}
              </div>

              {/* Console terminal panel */}
              {activeNode && (
                <div
                  className="console-panel"
                  style={{
                    height: 420,
                    border: "1px solid var(--border)",
                    borderRadius: "var(--radius)",
                    overflow: "hidden",
                  }}
                >
                  <ConsolePanel sessionId={session.id} nodeName={activeNode} />
                </div>
              )}
            </div>
          )}

          {session && !["provisioning", "running"].includes(session.status) && (
            <div className="alert alert-warn" style={{ marginTop: 8 }}>
              Session ended ({session.status}).{" "}
              <button className="link" onClick={launchSession}>Launch again</button>
            </div>
          )}
        </div>
      )}

      {locked && (
        <div className="alert alert-info row between wrap" style={{ gap: 12 }}>
          <span>This is a Pro lab. You can see the brief — unlock the full build, attack, and harden walkthrough with Pro.</span>
          <Link to="/pricing" className="btn btn-sm btn-primary">See plans</Link>
        </div>
      )}

      <div className="stack-16">
        {phases.map((ph) => {
          const meta = PHASE_META[ph.phase];
          const phaseLocked = ph.is_pro_only && !isPro;
          const done = completed.has(ph.phase);
          return (
            <div key={ph.id} className="card card-pad stack-16" style={{ borderLeft: `3px solid ${meta.color}` }}>
              <div className="row between wrap">
                <div className="row" style={{ gap: 10 }}>
                  <span className="badge" style={{ background: meta.tint, color: meta.color, borderColor: meta.color }}>
                    {meta.label}
                  </span>
                  <h3>{ph.title}</h3>
                </div>
                {user && !phaseLocked && (
                  <button
                    className={"btn btn-sm " + (done ? "" : "btn-primary")}
                    onClick={() => togglePhase(ph.phase)}
                    disabled={busyPhase === ph.phase}
                  >
                    {busyPhase === ph.phase ? <span className="spinner" /> : done ? "✓ Completed" : "Mark complete"}
                  </button>
                )}
              </div>

              {phaseLocked ? (
                <div className="alert alert-info row between wrap" style={{ gap: 12 }}>
                  <span>Unlock this phase with Pro.</span>
                  <Link to="/pricing" className="btn btn-sm">Upgrade</Link>
                </div>
              ) : (
                <div
                  className="lab-content"
                  dangerouslySetInnerHTML={{ __html: renderMarkdown(ph.content) }}
                />
              )}
            </div>
          );
        })}
      </div>

      {!user && (
        <div className="card card-pad center stack-8">
          <p className="muted">Log in to track which phases you've completed and work toward your certificate.</p>
          <div className="btn-row" style={{ justifyContent: "center" }}>
            <Link to="/register" className="btn btn-primary">Start free</Link>
            <Link to="/login" className="btn">Log in</Link>
          </div>
        </div>
      )}
    </div>
  );
}
