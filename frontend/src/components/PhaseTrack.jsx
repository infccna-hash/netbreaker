import { Fragment } from "react";

// The signature element: every lab is a Build → Attack → Harden progression.
// This same triad appears on lab cards, the lab detail header, and the
// dashboard — it *is* the structure of the product, so it carries the color.

const PHASES = [
  { key: "build", label: "Build", glyph: "1" },
  { key: "attack", label: "Attack", glyph: "2" },
  { key: "harden", label: "Harden", glyph: "3" },
];

export default function PhaseTrack({ completed = [], sm = false }) {
  const done = new Set(completed);
  return (
    <div className={"track" + (sm ? " sm" : "")} role="img" aria-label="Build, attack, harden progression">
      {PHASES.map((p, i) => (
        <Fragment key={p.key}>
          {i > 0 && <span className="track-link" />}
          <div className={`track-node ${p.key} ${done.has(p.key) ? "done" : ""}`}>
            <span className="track-dot">{done.has(p.key) ? "✓" : p.glyph}</span>
            {!sm && <span className={`track-label ${done.has(p.key) ? "on" : ""}`}>{p.label}</span>}
          </div>
        </Fragment>
      ))}
    </div>
  );
}
