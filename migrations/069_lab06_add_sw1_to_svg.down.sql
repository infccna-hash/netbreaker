-- 069_lab06_add_sw1_to_svg.down.sql
-- Revert to original SVG (direct KALI↔R1, no SW1)
UPDATE lab_topologies
SET svg_large = '<svg viewBox="0 0 720 250" role="img" aria-label="Kali outside, a router enforcing an inbound ACL, and an internal server behind it">
       <rect x="40" y="95" width="130" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
       <text x="105" y="117" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
       <text x="105" y="133" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#e5484d">outside · 203.0.113.66</text>
       <rect x="295" y="90" width="140" height="66" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
       <text x="365" y="114" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R1</text>
       <text x="365" y="132" text-anchor="middle" font-family="monospace" font-size="9" fill="#64748b">ACL OUTSIDE-IN (in)</text>
       <text x="365" y="146" text-anchor="middle" font-family="monospace" font-size="9" fill="#64748b">c3725</text>
       <rect x="555" y="95" width="130" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
       <text x="620" y="117" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">SERVER</text>
       <text x="620" y="133" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">10.0.20.10 · :80</text>
       <line x1="170" y1="123" x2="295" y2="123" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 4"/>
       <text x="232" y="114" text-anchor="middle" font-family="monospace" font-size="9" fill="#64748b">f0/0 · filtered</text>
       <line x1="435" y1="123" x2="555" y2="123" stroke="#2563eb" stroke-width="2"/>
       <text x="495" y="114" text-anchor="middle" font-family="monospace" font-size="9" fill="#64748b">f0/1 · inside</text>
       <text x="360" y="230" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">the inbound ACL is meant to block outside→inside except "replies" — that exception is the hole</text>
     </svg>'
WHERE lab_id = 6;
