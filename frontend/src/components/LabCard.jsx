import { Link } from "react-router-dom";
import PhaseTrack from "./PhaseTrack.jsx";

const DIFF = { easy: "#0d7050", medium: "#b45309", hard: "#c02a30" };

export default function LabCard({ lab, completed = [] }) {
  return (
    <Link to={`/labs/${lab.id}`} className="card lab-card">
      <div className="lab-top">
        <div className="stack stack-8">
          <span className="lab-idx">LAB {String(lab.id).padStart(2, "0")} · {lab.topic}</span>
          <h3>{lab.title}</h3>
          {lab.book_ref && <span className="book-ref">📖 {lab.book_ref}</span>}
        </div>
        <span className={`badge ${lab.is_free ? "free" : "pro"}`}>{lab.is_free ? "free" : "pro"}</span>
      </div>
      <p className="lab-desc">{lab.short_desc}</p>
      <div className="row between">
        <PhaseTrack completed={completed} sm />
        <span className="badge" style={{ borderColor: DIFF[lab.difficulty], color: DIFF[lab.difficulty] }}>
          {lab.difficulty}
        </span>
      </div>
    </Link>
  );
}
