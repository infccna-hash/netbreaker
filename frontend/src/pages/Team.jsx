import { useEffect, useState, useCallback } from "react";
import { api, ApiError } from "../lib/api.js";

export default function Team() {
  const [team, setTeam] = useState(null);
  const [progress, setProgress] = useState({}); // userID -> {completed, total}
  const [email, setEmail] = useState("");
  const [msg, setMsg] = useState(null); // {type, text}
  const [busy, setBusy] = useState(false);
  const [loading, setLoading] = useState(true);

  const load = useCallback(async () => {
    try {
      const [t, p] = await Promise.all([api.get("/team"), api.get("/team/progress").catch(() => null)]);
      setTeam(t);
      const map = {};
      (p?.members || []).forEach((m) => {
        map[m.user_id] = { completed: m.completed_phases, total: m.total_phases || 135 };
      });
      setProgress(map);
    } catch {
      /* ignore */
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { load(); }, [load]);

  async function invite(e) {
    e.preventDefault();
    setMsg(null); setBusy(true);
    try {
      await api.post("/team/invite", { email });
      setEmail("");
      setMsg({ type: "ok", text: `Added ${email} to the team.` });
      await load();
    } catch (err) {
      if (err instanceof ApiError && err.code === "SEAT_LIMIT") {
        setMsg({ type: "error", text: "Seat limit reached. Remove a member first." });
      } else if (err instanceof ApiError && err.status === 404) {
        setMsg({ type: "error", text: "No account for that email yet — ask them to sign up, then invite." });
      } else {
        setMsg({ type: "error", text: err.message });
      }
    } finally {
      setBusy(false);
    }
  }

  async function remove(userID) {
    try {
      await api.del(`/team/members/${userID}`);
      await load();
    } catch (err) {
      setMsg({ type: "error", text: err.message });
    }
  }

  if (loading) return <div className="page-center"><div className="spinner" /></div>;
  if (!team) return <div className="alert alert-error">Could not load your team.</div>;

  const members = team.members || [];
  const seatsUsed = members.length;

  return (
    <div className="stack-24">
      <div className="section-head">
        <div><span className="eyebrow">Bootcamp</span><h1 style={{ marginTop: 6 }}>{team.name}</h1></div>
        <span className="badge bootcamp">{seatsUsed} / {team.seat_count} seats</span>
      </div>

      {msg && <div className={`alert alert-${msg.type === "ok" ? "ok" : "error"}`}>{msg.text}</div>}

      <form className="card card-pad row wrap" style={{ gap: 12 }} onSubmit={invite}>
        <div className="field" style={{ flex: 1, minWidth: 220, margin: 0 }}>
          <label>Invite a member by email</label>
          <input className="input" type="email" value={email} placeholder="teammate@example.com"
            onChange={(e) => setEmail(e.target.value)} required />
        </div>
        <button className="btn btn-primary" disabled={busy || seatsUsed >= team.seat_count} style={{ alignSelf: "flex-end" }}>
          {busy ? <span className="spinner" /> : "Add member"}
        </button>
      </form>

      <div className="card" style={{ overflow: "hidden" }}>
        <table>
          <thead>
            <tr><th>Member</th><th>Role</th><th>Progress</th><th></th></tr>
          </thead>
          <tbody>
            {members.map((m) => {
              const u = m.user || {};
              const pr = progress[m.user_id] || { completed: 0, total: 135 };
              const pct = Math.round((pr.completed / pr.total) * 100);
              return (
                <tr key={m.user_id}>
                  <td>
                    <div className="stack" style={{ gap: 2 }}>
                      <span style={{ fontWeight: 550 }}>{u.name || u.email}</span>
                      <span className="muted" style={{ fontSize: "0.8rem" }}>{u.email}</span>
                    </div>
                  </td>
                  <td><span className={`badge ${m.role === "owner" ? "bootcamp" : ""}`}>{m.role}</span></td>
                  <td style={{ minWidth: 160 }}>
                    <div className="meter" style={{ marginBottom: 4 }}>
                      <span className="m-harden" style={{ width: `${pct}%` }} />
                    </div>
                    <span className="muted mono" style={{ fontSize: "0.78rem" }}>{pr.completed}/{pr.total}</span>
                  </td>
                  <td style={{ textAlign: "right" }}>
                    {m.role !== "owner" && (
                      <button className="btn btn-sm btn-ghost" style={{ color: "var(--attack)" }}
                        onClick={() => remove(m.user_id)}>Remove</button>
                    )}
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
}
