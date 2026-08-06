-- 070_lab14_add_pc2_to_svg.up.sql
-- Fix SVG: add missing PC2 node + PC2↔SW1 link

UPDATE lab_topologies
SET svg_large = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 380" font-family="ui-monospace,monospace">
   <rect x="230" y="20" width="240" height="50" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
   <text x="350" y="46" text-anchor="middle" font-size="15" fill="#14161a" font-weight="700">R1 · IPv6 Gateway</text>
   <text x="350" y="62" text-anchor="middle" font-size="10" fill="#6b7480">2001:db8:1::1/64 · RA every 200s</text>
   <rect x="230" y="100" width="240" height="46" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
   <text x="350" y="126" text-anchor="middle" font-size="14" fill="#14161a" font-weight="600">SW1 · RA Guard</text>
   <text x="350" y="142" text-anchor="middle" font-size="10" fill="#6b7480">port Gi0/3: untrusted · RAs dropped</text>
   <line x1="350" y1="70" x2="350" y2="100" stroke="#6b7480" stroke-width="2.5"/>
   <rect x="40" y="250" width="180" height="54" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
   <text x="130" y="276" text-anchor="middle" font-size="14" fill="#2563eb" font-weight="600">PC1</text>
   <text x="130" y="294" text-anchor="middle" font-size="10" fill="#6b7480">SLAAC: 2001:db8:1::100</text>
   <rect x="260" y="250" width="180" height="54" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
   <text x="350" y="276" text-anchor="middle" font-size="14" fill="#2563eb" font-weight="600">PC2</text>
   <text x="350" y="294" text-anchor="middle" font-size="10" fill="#6b7480">SLAAC: 2001:db8:1::200</text>
   <rect x="480" y="250" width="180" height="54" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
   <text x="570" y="276" text-anchor="middle" font-size="14" fill="#e5484d" font-weight="700">KALI</text>
   <text x="570" y="294" text-anchor="middle" font-size="10" fill="#6b7480">rogue RA · NA spoof · mitm6</text>
   <line x1="130" y1="250" x2="290" y2="146" stroke="#2563eb" stroke-width="2"/>
   <line x1="350" y1="250" x2="350" y2="146" stroke="#2563eb" stroke-width="2"/>
   <line x1="480" y1="276" x2="410" y2="146" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
 </svg>'
WHERE lab_id = 14;
