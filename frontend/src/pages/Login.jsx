import { useState } from "react";
import { Link, useNavigate, useLocation } from "react-router-dom";
import { useAuth } from "../lib/auth.jsx";

export default function Login() {
  const { login } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [busy, setBusy] = useState(false);

  async function onSubmit(e) {
    e.preventDefault();
    setError("");
    setBusy(true);
    try {
      await login(email, password);
      navigate(location.state?.from || "/dashboard", { replace: true });
    } catch (err) {
      setError(err.message || "Could not log in");
    } finally {
      setBusy(false);
    }
  }

  return (
    <div className="auth-wrap card card-pad">
      <span className="eyebrow">Welcome back</span>
      <h2 style={{ margin: "6px 0 18px" }}>Log in</h2>
      {error && <div className="alert alert-error" style={{ marginBottom: 14 }}>{error}</div>}
      <form onSubmit={onSubmit}>
        <div className="field">
          <label>Email</label>
          <input className="input" type="email" value={email} autoComplete="email"
            onChange={(e) => setEmail(e.target.value)} required />
        </div>
        <div className="field">
          <label>Password</label>
          <input className="input" type="password" value={password} autoComplete="current-password"
            onChange={(e) => setPassword(e.target.value)} required />
        </div>
        <button className="btn btn-primary btn-block" disabled={busy}>
          {busy ? <span className="spinner" /> : "Log in"}
        </button>
      </form>
      <p className="muted center" style={{ marginTop: 16, fontSize: "0.88rem" }}>
        No account? <Link to="/register" className="link">Start free</Link>
      </p>
    </div>
  );
}
