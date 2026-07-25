import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { useAuth } from "../lib/auth.jsx";

export default function Register() {
  const { register } = useAuth();
  const navigate = useNavigate();
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [busy, setBusy] = useState(false);

  async function onSubmit(e) {
    e.preventDefault();
    setError("");
    if (password.length < 8) {
      setError("Password must be at least 8 characters");
      return;
    }
    setBusy(true);
    try {
      await register(email, password, name);
      navigate("/dashboard", { replace: true });
    } catch (err) {
      setError(err.message || "Could not create your account");
    } finally {
      setBusy(false);
    }
  }

  return (
    <div className="auth-wrap card card-pad">
      <span className="eyebrow">Free — 3 labs, no card</span>
      <h2 style={{ margin: "6px 0 18px" }}>Create your account</h2>
      {error && <div className="alert alert-error" style={{ marginBottom: 14 }}>{error}</div>}
      <form onSubmit={onSubmit}>
        <div className="field">
          <label>Name</label>
          <input className="input" value={name} autoComplete="name"
            onChange={(e) => setName(e.target.value)} />
        </div>
        <div className="field">
          <label>Email</label>
          <input className="input" type="email" value={email} autoComplete="email"
            onChange={(e) => setEmail(e.target.value)} required />
        </div>
        <div className="field">
          <label>Password</label>
          <input className="input" type="password" value={password} autoComplete="new-password"
            onChange={(e) => setPassword(e.target.value)} required minLength={8} />
        </div>
        <button className="btn btn-primary btn-block" disabled={busy}>
          {busy ? <span className="spinner" /> : "Create account"}
        </button>
      </form>
      <p className="muted center" style={{ marginTop: 16, fontSize: "0.88rem" }}>
        Already have one? <Link to="/login" className="link">Log in</Link>
      </p>
    </div>
  );
}
