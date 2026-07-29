import { useEffect, useState, useRef, useCallback } from "react";
import { useParams, Link } from "react-router-dom";
import { api, ApiError } from "../lib/api.js";
import { useAuth } from "../lib/auth.jsx";
import PhaseTrack from "../components/PhaseTrack.jsx";
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
  const [verifyingPhase, setVerifyingPhase] = useState(null);
  const [verifyResults, setVerifyResults] = useState({}); // phase -> VerifyResult

  // ── Session (live lab orchestration) ────────────────────────────────
  const [session, setSession] = useState(null);       // current session object or null
  const [sessionLoading, setSessionLoading] = useState(false);
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

  // Session persists in the console tab — only ended via explicit End session button.
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

  // Calls the real console-truth verification endpoint against the live
  // session. The backend marks progress automatically when a check passes
  // (maybeMarkProgress) — this just mirrors that into local state so the
  // UI updates without a full reload. Falls back gracefully: if this lab
  // has no console-truth verifier registered yet, the backend says so
  // explicitly ("verification not available for this lab yet") rather
  // than silently failing — "Mark complete" stays available below as the
  // manual path for every lab that doesn't have automated checks yet.
  async function verifyPhase(phase) {
    if (!user || !session || session.status !== "running") return;
    setVerifyingPhase(phase);
    setError("");
    try {
      const result = await api.post(`/labs/${id}/verify`, {
        phase,
        session_id: session.id,
      });
      setVerifyResults((prev) => ({ ...prev, [phase]: result }));
      if (result.passed) {
        setCompleted((prev) => new Set(prev).add(phase));
      }
    } catch (err) {
      setError(err.message || "Verification failed");
    } finally {
      setVerifyingPhase(null);
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

      {/* ── Live Lab section: launch/status only. The actual terminal
          lives in the full-screen modal rendered at the bottom of the
          page, so it never has to be scrolled to. ───────────────────── */}
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
            <div className="row" style={{ gap: 12, alignItems: "center" }}>
              <span className="muted" style={{ fontSize: "0.9rem" }}>
                Session running — {nodeNames.length} node{nodeNames.length === 1 ? "" : "s"} online.
              </span>
              <button
                className="btn btn-primary btn-sm"
                onClick={() => window.open(`/console/${session.id}`, "_blank", "noopener,noreferrer")}
              >
                🖥 Open console ↗
              </button>
            </div>
          )}

          {session && !["provisioning", "running"].includes(session.status) && (
            <div className="alert alert-warn" style={{ marginTop: 8 }}>
              {session.status === "idle_stopped" ? (
                <>
                  Session paused after inactivity — your nodes and config are still there.{" "}
                  <button className="link" onClick={launchSession}>Resume session</button>
                  {" "}(fast — just restarts the existing nodes, not a rebuild).
                </>
              ) : (
                <>
                  Session ended ({session.status}).{" "}
                  <button className="link" onClick={launchSession}>Launch again</button>
                </>
              )}
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
          const vr = verifyResults[ph.phase];
          const sessionRunning = session?.status === "running";
          const verifierUnavailable = vr && !vr.passed && vr.message === "verification not available for this lab yet";
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
                  <div className="row" style={{ gap: 8 }}>
                    {!done && (
                      <button
                        className="btn btn-sm btn-primary"
                        onClick={() => verifyPhase(ph.phase)}
                        disabled={verifyingPhase === ph.phase || !sessionRunning}
                        title={sessionRunning ? "Check your work against the live session" : "Launch a session to verify"}
                      >
                        {verifyingPhase === ph.phase ? <span className="spinner" /> : "✓ Verify"}
                      </button>
                    )}
                    <button
                      className={"btn btn-sm " + (done ? "" : "")}
                      onClick={() => togglePhase(ph.phase)}
                      disabled={busyPhase === ph.phase}
                    >
                      {busyPhase === ph.phase ? <span className="spinner" /> : done ? "✓ Completed" : "Mark complete manually"}
                    </button>
                  </div>
                )}
              </div>

              {!done && vr && (
                <div className={"alert " + (vr.passed ? "alert-ok" : verifierUnavailable ? "alert-info" : "alert-warn")}>
                  {verifierUnavailable ? (
                    <span>Automated verification isn't available for this lab yet — use "Mark complete manually" once you've done the work.</span>
                  ) : (
                    <div className="stack-8">
                      <span>{vr.message}{typeof vr.score === "number" && !vr.passed ? ` (${vr.score}%)` : ""}</span>
                      {Array.isArray(vr.failures) && vr.failures.length > 0 && (
                        <ul style={{ margin: 0, paddingLeft: 20 }}>
                          {vr.failures.map((f, i) => (
                            <li key={i}>
                              <strong>{f}</strong>
                              {vr.hints?.[i] && <span className="muted"> — {vr.hints[i]}</span>}
                            </li>
                          ))}
                        </ul>
                      )}
                    </div>
                  )}
                </div>
              )}

              {!sessionRunning && !done && (
                <p className="muted" style={{ fontSize: "0.82rem", margin: 0 }}>
                  Launch a live session above to check your work automatically — or mark this phase complete manually.
                </p>
              )}

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
