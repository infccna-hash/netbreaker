import { useEffect, useState } from "react";
import { useParams, Link } from "react-router-dom";
import { api } from "../lib/api.js";

export default function VerifyCertificate() {
  const { code } = useParams();
  const [result, setResult] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    api.get(`/certificate/verify/${code}`)
      .then((r) => setResult(r || { valid: false }))
      .catch(() => setResult({ valid: false }))
      .finally(() => setLoading(false));
  }, [code]);

  if (loading) return <div className="page-center"><div className="spinner" /></div>;

  const valid = result && result.valid;
  const issued = result?.issued_at ? new Date(result.issued_at).toLocaleDateString() : "";

  return (
    <div className="stack-16" style={{ maxWidth: 520, margin: "24px auto" }}>
      <span className="eyebrow">Certificate verification</span>
      {valid ? (
        <div className="card card-pad stack-16" style={{ borderTop: "3px solid var(--harden)" }}>
          <div className="alert alert-ok">Valid certificate</div>
          <div className="stat">
            <span className="lbl">Issued to</span>
            <span style={{ fontSize: "1.3rem", fontWeight: 600 }}>{result.name || "NetBreaker graduate"}</span>
          </div>
          <div className="row between wrap" style={{ fontSize: "0.85rem" }}>
            <span className="muted">Issued {issued}</span>
            <span className="mono muted">{code}</span>
          </div>
          <p className="muted" style={{ fontSize: "0.88rem" }}>
            Completed every build · attack · harden objective in the NetBreaker CCNA curriculum.
          </p>
        </div>
      ) : (
        <div className="card card-pad stack-8">
          <div className="alert alert-error">No certificate matches this code.</div>
          <p className="muted">The link may be mistyped or the certificate was revoked.</p>
        </div>
      )}
      <Link to="/" className="link">← netbreaker.io</Link>
    </div>
  );
}
