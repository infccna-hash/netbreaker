import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { api } from "../lib/api.js";
import { useAuth } from "../lib/auth.jsx";

export default function Account() {
  const { user, isPro, refreshUser, logout, setUser } = useAuth();
  const navigate = useNavigate();
  const [name, setName] = useState(user.name || "");
  const [savedMsg, setSavedMsg] = useState("");
  const [error, setError] = useState("");
  const [busy, setBusy] = useState("");
  const [confirmDelete, setConfirmDelete] = useState(false);

  async function saveName(e) {
    e.preventDefault();
    setError(""); setSavedMsg(""); setBusy("save");
    try {
      const updated = await api.patch("/me", { name });
      if (updated) setUser(updated);
      else await refreshUser();
      setSavedMsg("Saved.");
    } catch (err) {
      setError(err.message);
    } finally {
      setBusy("");
    }
  }

  async function openPortal() {
    setError(""); setBusy("portal");
    try {
      const res = await api.post("/subscription/portal", {});
      if (res && res.url) window.location.href = res.url;
      else setError("Could not open the billing portal.");
    } catch (err) {
      setError(err.message);
    } finally {
      setBusy("");
    }
  }

  async function deleteAccount() {
    setError(""); setBusy("delete");
    try {
      await api.del("/me");
      await logout();
      navigate("/");
    } catch (err) {
      setError(err.message);
      setBusy("");
    }
  }

  const planClass = user.plan === "bootcamp" ? "bootcamp" : user.plan === "pro" ? "pro" : "free";

  return (
    <div className="stack-24" style={{ maxWidth: 620, margin: "0 auto" }}>
      <div>
        <span className="eyebrow">Account</span>
        <h1 style={{ marginTop: 6 }}>Settings</h1>
      </div>

      {error && <div className="alert alert-error">{error}</div>}

      <div className="card card-pad stack-16">
        <div className="row between">
          <div className="stat"><span className="lbl">Plan</span><span style={{ fontWeight: 600 }}>{user.plan}</span></div>
          <span className={`badge ${planClass}`}>{user.plan}</span>
        </div>
        {isPro ? (
          <button className="btn" onClick={openPortal} disabled={busy === "portal"}>
            {busy === "portal" ? <span className="spinner" /> : "Manage billing"}
          </button>
        ) : (
          <button className="btn btn-primary" onClick={() => navigate("/pricing")}>Upgrade</button>
        )}
      </div>

      <form className="card card-pad stack-16" onSubmit={saveName}>
        <span className="eyebrow">Profile</span>
        <div className="field" style={{ margin: 0 }}>
          <label>Email</label>
          <input className="input" value={user.email} disabled />
        </div>
        <div className="field" style={{ margin: 0 }}>
          <label>Name</label>
          <input className="input" value={name} onChange={(e) => setName(e.target.value)} />
        </div>
        <div className="row" style={{ gap: 12 }}>
          <button className="btn btn-primary" disabled={busy === "save"}>
            {busy === "save" ? <span className="spinner" /> : "Save changes"}
          </button>
          {savedMsg && <span className="muted" style={{ fontSize: "0.85rem" }}>{savedMsg}</span>}
        </div>
      </form>

      <div className="card card-pad stack-16" style={{ borderColor: "#f3c3c4" }}>
        <span className="eyebrow" style={{ color: "var(--attack)" }}>Danger zone</span>
        <p className="muted" style={{ fontSize: "0.9rem" }}>
          Deleting your account removes your progress and any certificate permanently. This can't be undone.
        </p>
        {confirmDelete ? (
          <div className="row wrap" style={{ gap: 10 }}>
            <button className="btn btn-attack" onClick={deleteAccount} disabled={busy === "delete"}>
              {busy === "delete" ? <span className="spinner" /> : "Yes, delete everything"}
            </button>
            <button className="btn btn-ghost" onClick={() => setConfirmDelete(false)}>Cancel</button>
          </div>
        ) : (
          <button className="btn" style={{ alignSelf: "flex-start", color: "var(--attack)", borderColor: "#f3c3c4" }}
            onClick={() => setConfirmDelete(true)}>Delete account</button>
        )}
      </div>
    </div>
  );
}
