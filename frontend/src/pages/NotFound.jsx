import { Link } from "react-router-dom";

export default function NotFound() {
  return (
    <div className="page-center">
      <div className="center stack-16">
        <span className="mono muted" style={{ fontSize: "3rem", fontWeight: 600 }}>404</span>
        <p className="muted">No route to host. That page doesn't exist.</p>
        <Link to="/" className="btn btn-primary">Back to home</Link>
      </div>
    </div>
  );
}
