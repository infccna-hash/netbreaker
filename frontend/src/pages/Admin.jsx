import { useEffect, useState, useCallback } from "react";
import { api } from "../lib/api.js";

const PLANS = ["free", "pro", "bootcamp"];

export default function Admin() {
  const [stats, setStats] = useState(null);
  const [users, setUsers] = useState([]);
  const [planFilter, setPlanFilter] = useState("all");
  const [page, setPage] = useState(1);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const limit = 20;

  const loadUsers = useCallback(async () => {
    const qs = new URLSearchParams({ page: String(page), limit: String(limit) });
    if (planFilter !== "all") qs.set("plan", planFilter);
    try {
      const data = await api.get("/admin/users?" + qs.toString());
      setUsers(Array.isArray(data) ? data : data.users || []);
    } catch (err) {
      setError(err.message);
    }
  }, [page, planFilter]);

  useEffect(() => {
    api.get("/admin/stats").then(setStats).catch((e) => setError(e.message)).finally(() => setLoading(false));
  }, []);

  useEffect(() => { loadUsers(); }, [loadUsers]);

  async function changePlan(id, plan) {
    try {
      await api.patch(`/admin/users/${id}/plan`, { plan });
      setUsers((prev) => prev.map((u) => (u.id === id ? { ...u, plan } : u)));
    } catch (err) {
      setError(err.message);
    }
  }

  if (loading) return <div className="page-center"><div className="spinner" /></div>;

  const statCards = stats
    ? [
        { label: "Total users", value: stats.users?.total ?? "—" },
        { label: "Pro", value: stats.users?.pro ?? "—" },
        { label: "Bootcamp", value: stats.users?.bootcamp ?? "—" },
        { label: "Certificates", value: stats.certificates_issued ?? "—" },
      ]
    : [];

  return (
    <div className="stack-24">
      <div><span className="eyebrow">Admin</span><h1 style={{ marginTop: 6 }}>Console</h1></div>
      {error && <div className="alert alert-error">{error}</div>}

      {statCards.length > 0 && (
        <div className="grid grid-3" style={{ gridTemplateColumns: "repeat(4, 1fr)" }}>
          {statCards.map((s) => (
            <div key={s.label} className="card card-pad stat">
              <span className="num">{s.value}</span><span className="lbl">{s.label}</span>
            </div>
          ))}
        </div>
      )}

      <div>
        <div className="section-head">
          <h2>Users</h2>
          <select className="input" value={planFilter} onChange={(e) => { setPage(1); setPlanFilter(e.target.value); }}>
            <option value="all">All plans</option>
            {PLANS.map((p) => <option key={p} value={p}>{p}</option>)}
          </select>
        </div>
        <div className="card" style={{ overflow: "hidden" }}>
          <table>
            <thead><tr><th>Email</th><th>Name</th><th>Plan</th><th>Joined</th></tr></thead>
            <tbody>
              {users.map((u) => (
                <tr key={u.id}>
                  <td>{u.email}{u.is_admin && <span className="badge pro" style={{ marginLeft: 8 }}>admin</span>}</td>
                  <td className="muted">{u.name || "—"}</td>
                  <td>
                    <select className="input" style={{ padding: "5px 28px 5px 10px", fontSize: "0.82rem" }}
                      value={u.plan} onChange={(e) => changePlan(u.id, e.target.value)}>
                      {PLANS.map((p) => <option key={p} value={p}>{p}</option>)}
                    </select>
                  </td>
                  <td className="muted mono" style={{ fontSize: "0.8rem" }}>
                    {u.created_at ? new Date(u.created_at).toLocaleDateString() : "—"}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <div className="row between" style={{ marginTop: 14 }}>
          <button className="btn btn-sm" disabled={page <= 1} onClick={() => setPage((p) => p - 1)}>← Prev</button>
          <span className="muted mono" style={{ fontSize: "0.82rem" }}>page {page}</span>
          <button className="btn btn-sm" disabled={users.length < limit} onClick={() => setPage((p) => p + 1)}>Next →</button>
        </div>
      </div>
    </div>
  );
}
