import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { api } from "../lib/api.js";
import { useAuth } from "../lib/auth.jsx";

const PHASE_LABEL = { build: "Build", attack: "Attack", harden: "Harden" };

export default function Dashboard() {
  const { user, isPro } = useAuth();
  const [summary, setSummary] = useState(null);
  const [labs, setLabs] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    Promise.all([api.get("/progress"), api.get("/labs").catch(() => [])])
      .then(([p, l]) => {
        setSummary(p);
        setLabs(l || []);
      })
      .catch(() => {})
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <div className="page-center"><div className="spinner" /></div>;

  const total = summary?.total_phases || 135; // 45 labs × 3 phases — fallback only, real total always comes from the API
  const done = summary?.completed_phases || 0;
  const pct = summary?.readiness_pct ?? Math.round((done / total) * 100);

  // Count completions per phase type for the tri-color meter.
  const perPhase = { build: 0, attack: 0, harden: 0 };
  (summary?.items || []).forEach((it) => {
    if (perPhase[it.phase] !== undefined) perPhase[it.phase] += 1;
  });

  // Completed phases grouped by lab, for the per-lab list.
  const byLab = {};
  (summary?.items || []).forEach((it) => {
    (byLab[it.lab_id] ||= new Set()).add(it.phase);
  });

  return (
    <div className="stack-24">
      <div>
        <span className="eyebrow">Signed in as {user.email}</span>
        <h1 style={{ marginTop: 6 }}>Certification readiness</h1>
      </div>

      <div className="card card-pad stack-16">
        <div className="row between wrap">
          <div className="stat">
            <span className="num">{pct}%</span>
            <span className="lbl">{done} of {total} objectives complete</span>
          </div>
          {pct >= 100 ? (
            <Link to="/certificate" className="btn btn-primary">Get your certificate</Link>
          ) : !isPro ? (
            <Link to="/pricing" className="btn">Unlock all labs</Link>
          ) : (
            <Link to="/labs" className="btn">Continue labs</Link>
          )}
        </div>
        <div className="meter" aria-label={`${pct}% complete`}>
          <span className="m-build" style={{ width: `${(perPhase.build / total) * 100}%` }} />
          <span className="m-attack" style={{ width: `${(perPhase.attack / total) * 100}%` }} />
          <span className="m-harden" style={{ width: `${(perPhase.harden / total) * 100}%` }} />
        </div>
        <div className="row wrap" style={{ gap: 18, fontSize: "0.82rem" }}>
          {Object.entries(perPhase).map(([k, v]) => (
            <span key={k} className="row" style={{ gap: 7 }}>
              <span className="dot" style={{ background: `var(--${k})` }} /> {PHASE_LABEL[k]}: {v}
            </span>
          ))}
        </div>
      </div>

      <div>
        <div className="section-head"><h2>Your labs</h2><Link to="/labs" className="link">Browse all →</Link></div>
        <div className="card" style={{ overflow: "hidden" }}>
          <table>
            <thead>
              <tr><th>Lab</th><th>Topic</th><th>Phases</th><th></th></tr>
            </thead>
            <tbody>
              {labs.map((lab) => {
                const c = byLab[lab.id] || new Set();
                return (
                  <tr key={lab.id}>
                    <td><span className="mono muted">{String(lab.id).padStart(2, "0")}</span> &nbsp;{lab.title}</td>
                    <td className="muted">{lab.topic}</td>
                    <td>
                      <span className="row" style={{ gap: 5 }}>
                        {["build", "attack", "harden"].map((ph) => (
                          <span key={ph} className="dot" title={PHASE_LABEL[ph]}
                            style={{ background: c.has(ph) ? `var(--${ph})` : "var(--line-strong)" }} />
                        ))}
                        <span className="muted" style={{ fontSize: "0.8rem", marginLeft: 4 }}>{c.size}/3</span>
                      </span>
                    </td>
                    <td style={{ textAlign: "right" }}><Link to={`/labs/${lab.id}`} className="link">Open →</Link></td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
