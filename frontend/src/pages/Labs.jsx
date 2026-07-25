import { useEffect, useState } from "react";
import { api } from "../lib/api.js";
import { useAuth } from "../lib/auth.jsx";
import LabCard from "../components/LabCard.jsx";

const TOPICS = ["all", "fundamentals", "switching", "routing", "services", "security", "wireless", "automation"];
const DIFFS = ["all", "easy", "medium", "hard"];

export default function Labs() {
  const { user } = useAuth();
  const [labs, setLabs] = useState([]);
  const [progress, setProgress] = useState({}); // labId -> [phase]
  const [topic, setTopic] = useState("all");
  const [difficulty, setDifficulty] = useState("all");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    setLoading(true);
    const qs = new URLSearchParams();
    if (topic !== "all") qs.set("topic", topic);
    if (difficulty !== "all") qs.set("difficulty", difficulty);
    const q = qs.toString();
    api
      .get("/labs" + (q ? "?" + q : ""))
      .then((data) => setLabs(data || []))
      .catch((err) => setError(err.message))
      .finally(() => setLoading(false));
  }, [topic, difficulty]);

  useEffect(() => {
    if (!user) return;
    api
      .get("/progress")
      .then((p) => {
        const map = {};
        (p.items || []).forEach((it) => {
          (map[it.lab_id] ||= []).push(it.phase);
        });
        setProgress(map);
      })
      .catch(() => {});
  }, [user]);

  return (
    <div className="stack-24">
      <div className="section-head">
        <div>
          <span className="eyebrow">45 labs · build · attack · harden</span>
          <h1 style={{ marginTop: 6 }}>Labs</h1>
        </div>
        <div className="row wrap">
          <select className="input" value={topic} onChange={(e) => setTopic(e.target.value)} aria-label="Filter by topic">
            {TOPICS.map((t) => <option key={t} value={t}>{t === "all" ? "All topics" : t}</option>)}
          </select>
          <select className="input" value={difficulty} onChange={(e) => setDifficulty(e.target.value)} aria-label="Filter by difficulty">
            {DIFFS.map((d) => <option key={d} value={d}>{d === "all" ? "All levels" : d}</option>)}
          </select>
        </div>
      </div>

      {error && <div className="alert alert-error">{error}</div>}
      {loading ? (
        <div className="page-center"><div className="spinner" /></div>
      ) : labs.length === 0 ? (
        <div className="card card-pad center muted">No labs match that filter. Try widening it.</div>
      ) : (
        <div className="grid grid-3">
          {labs.map((lab) => (
            <LabCard key={lab.id} lab={lab} completed={progress[lab.id] || []} />
          ))}
        </div>
      )}
    </div>
  );
}
