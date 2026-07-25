// Three connected nodes = a mini network topology and the phase triad at once.
export default function Brand() {
  return (
    <span className="brand">
      <span className="glyph" aria-hidden="true">
        <svg width="22" height="22" viewBox="0 0 22 22" fill="none">
          <line x1="4" y1="5" x2="4" y2="17" stroke="#d2d7de" strokeWidth="1.5" />
          <line x1="4" y1="5" x2="16" y2="11" stroke="#d2d7de" strokeWidth="1.5" />
          <line x1="4" y1="17" x2="16" y2="11" stroke="#d2d7de" strokeWidth="1.5" />
          <circle cx="4" cy="5" r="2.6" fill="#2563eb" />
          <circle cx="4" cy="17" r="2.6" fill="#e5484d" />
          <circle cx="16" cy="11" r="2.6" fill="#10855f" />
        </svg>
      </span>
      netbreaker
    </span>
  );
}
