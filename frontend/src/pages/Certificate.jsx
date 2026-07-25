import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { api, ApiError } from "../lib/api.js";
import { useAuth } from "../lib/auth.jsx";

export default function Certificate() {
  const { user } = useAuth();
  const [cert, setCert] = useState(null);
  const [notEligible, setNotEligible] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    api.get("/certificate")
      .then(setCert)
      .catch((err) => {
        if (err instanceof ApiError && err.status === 409) {
          setNotEligible(err.body?.error || "Complete every objective in the curriculum to earn your certificate.");
        } else {
          setError(err.message);
        }
      })
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <div className="page-center"><div className="spinner" /></div>;

  if (notEligible) {
    return (
      <div className="stack-16" style={{ maxWidth: 560, margin: "0 auto" }}>
        <span className="eyebrow">Certificate</span>
        <h1>Not quite yet</h1>
        <div className="alert alert-info">{notEligible}</div>
        <Link to="/dashboard" className="btn btn-primary" style={{ alignSelf: "flex-start" }}>Back to dashboard</Link>
      </div>
    );
  }

  if (error) return <div className="alert alert-error">{error}</div>;
  if (!cert) return null;

  const verifyPath = `/certificate/verify/${cert.verify_code}`;
  const verifyUrl = `${window.location.origin}${verifyPath}`;
  const issued = cert.issued_at ? new Date(cert.issued_at).toLocaleDateString() : "";

  return (
    <div className="stack-24" style={{ maxWidth: 720, margin: "0 auto" }}>
      <div className="center stack-8">
        <span className="eyebrow">Certificate earned</span>
        <h1>Every objective complete</h1>
      </div>

      <div className="card card-pad center stack-16" style={{ borderTop: "3px solid var(--harden)" }}>
        <span className="eyebrow">NetBreaker · CCNA offensive labs</span>
        <h2 style={{ fontSize: "1.7rem" }}>{user.name || user.email}</h2>
        <p className="muted">
          Built, attacked, and hardened every lab topology across switching, routing,
          services, security, and wireless.
        </p>
        <hr className="divider" style={{ width: "100%" }} />
        <div className="row between wrap" style={{ width: "100%", fontSize: "0.85rem" }}>
          <span className="muted">Issued {issued}</span>
          <span className="mono">{cert.verify_code}</span>
        </div>
      </div>

      <div className="card card-pad stack-8">
        <span className="eyebrow">Share your verification link</span>
        <div className="row wrap" style={{ gap: 10 }}>
          <input className="input mono" readOnly value={verifyUrl} style={{ flex: 1, minWidth: 220 }} />
          <button className="btn" onClick={() => navigator.clipboard?.writeText(verifyUrl)}>Copy</button>
          <Link to={verifyPath} className="btn btn-ghost">Preview</Link>
        </div>
      </div>
    </div>
  );
}
