-- ═══════════════════════════════════════════════════════
-- Lab 47 (id=47) — Firewall Fortress : full content
-- FortiGate segmentation lab (Vol 1 · Ch 6 · Firewalls)
-- Uses the 4 new images: c2691 (R1 edge), FortiGate (FW),
-- c7200-15.2 (R2 internal), IOU 15.1g (SW1 L2).
-- ═══════════════════════════════════════════════════════

INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (47, 'firewall-fortress', 'Firewall Fortress', 'security', 'hard', true, 47,
        'Stand up a FortiGate-protected segment, watch a wide-open firewall leak, then lock it down.', 'Vol 1 · Ch 6')
ON CONFLICT (id) DO NOTHING;

-- ─────────────────────────── BUILD ───────────────────────────
INSERT INTO lab_phases (lab_id, phase, title, is_pro_only, content)
VALUES (47, 'build', 'Build the segmented inside', false, $md$
<div class="phase build">
    <div class="phase-head">
      <span class="phase-tag">Build</span>
      <h3>Build the segmented inside</h3>
    </div>
    <p class="goal">Two VLANs behind a switch, a router doing inter-VLAN routing, and a FortiGate sitting at the edge. Before the firewall can protect anything, the inside has to actually work on its own.</p>

    <div class="step">
      <div class="step-label"><span class="n">1</span> Configure SW1 access ports (VLAN 10 / VLAN 20)</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">SW1#</span> configure terminal
<span class="prompt">SW1(config)#</span> vlan 10
<span class="prompt">SW1(config-vlan)#</span> name INSIDE-10
<span class="prompt">SW1(config-vlan)#</span> vlan 20
<span class="prompt">SW1(config-vlan)#</span> name INSIDE-20
<span class="prompt">SW1(config-vlan)#</span> interface e0/1
<span class="prompt">SW1(config-if)#</span> switchport mode access
<span class="prompt">SW1(config-if)#</span> switchport access vlan 10
<span class="prompt">SW1(config-if)#</span> no shutdown
<span class="prompt">SW1(config-if)#</span> interface e0/2
<span class="prompt">SW1(config-if)#</span> switchport mode access
<span class="prompt">SW1(config-if)#</span> switchport access vlan 20
<span class="prompt">SW1(config-if)#</span> no shutdown
<span class="prompt">SW1(config-if)#</span> interface e0/0
<span class="prompt">SW1(config-if)#</span> switchport mode trunk
<span class="prompt">SW1(config-if)#</span> no shutdown</pre>
      <div class="note why"><strong>Why this matters:</strong> PC1 lives in VLAN 10 (10.0.10.10), PC2 in VLAN 20 (10.0.20.20). The trunk on e0/0 carries both VLANs up to R2, who will do the routing between them.</div>
    </div>

    <div class="step">
      <div class="step-label"><span class="n">2</span> Configure R2 — the inter-VLAN router (subinterfaces)</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">R2#</span> configure terminal
<span class="prompt">R2(config)#</span> interface fa1/0.10
<span class="prompt">R2(config-subif)#</span> encapsulation dot1Q 10
<span class="prompt">R2(config-subif)#</span> ip address 10.0.10.1 255.255.255.0
<span class="prompt">R2(config-subif)#</span> interface fa1/0.20
<span class="prompt">R2(config-subif)#</span> encapsulation dot1Q 20
<span class="prompt">R2(config-subif)#</span> ip address 10.0.20.1 255.255.255.0
<span class="prompt">R2(config-subif)#</span> interface fa0/0
<span class="prompt">R2(config-if)#</span> ip address 10.0.0.2 255.255.255.0
<span class="prompt">R2(config-if)#</span> no shutdown
<span class="prompt">R2(config)#</span> ip route 0.0.0.0 0.0.0.0 10.0.0.1</pre>
      <div class="note why"><strong>Why this matters:</strong> R2 is the gateway for both VLANs (10.0.10.1 / 10.0.20.1) and points its default route at the FortiGate's inside interface (10.0.0.1). R2 is the last router the firewall can see. (c7200's built-in I/O card exposes only Fa0/0; the trunk to SW1 rides Fa1/0 from the PA-FE-TX slot, so the dot1Q subinterfaces live on Fa1/0.)</div>
    </div>

    <div class="step">
      <div class="step-label"><span class="n">3</span> Configure R1 — the edge router (outside world)</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">R1#</span> configure terminal
<span class="prompt">R1(config)#</span> interface fa0/1
<span class="prompt">R1(config-if)#</span> ip address 198.51.100.1 255.255.255.252
<span class="prompt">R1(config-if)#</span> no shutdown
<span class="prompt">R1(config)#</span> interface fa0/0
<span class="prompt">R1(config-if)#</span> ip address 203.0.113.254 255.255.255.0
<span class="prompt">R1(config-if)#</span> no shutdown
<span class="prompt">R1(config)#</span> ip route 10.0.0.0 255.0.0.0 198.51.100.2</pre>
      <div class="note why"><strong>Why this matters:</strong> R1 sits between Kali (203.0.113.100) and the FortiGate (198.51.100.2). It is the outside edge — everything beyond the firewall is the untrusted world. The static route toward 10.0.0.0/8 via the firewall is what lets the outside (and Kali) even try to reach the inside — and, in Attack, succeed when the firewall is wide open. (The FW link uses the 198.51.100.0/30 point-to-point so it doesn't overlap Kali's 203.0.113.0/24 segment.)</div>
    </div>

    <div class="step">
      <div class="step-label"><span class="n">4</span> Configure the FortiGate — interfaces &amp; one-way policy</div>
      <p>The FortiGate console is <strong>VNC-only</strong> (a browser terminal can't render it) — the console panel shows the VNC address to connect to (e.g. TigerVNC). First login: <code>admin</code>, empty password, then set a new password when forced.</p>
      <pre><button class="copy-btn">copy</button><span class="prompt">FG&gt;</span> config system interface
<span class="prompt">FG (interface)#</span> edit "port1"
<span class="prompt">FG (port1)#</span> set mode static
<span class="prompt">FG (port1)#</span> set ip 198.51.100.2 255.255.255.252
<span class="prompt">FG (port1)#</span> set allowaccess ping
<span class="prompt">FG (port1)#</span> next
<span class="prompt">FG (interface)#</span> edit "port2"
<span class="prompt">FG (port2)#</span> set mode static
<span class="prompt">FG (port2)#</span> set ip 10.0.0.1 255.255.255.0
<span class="prompt">FG (port2)#</span> set allowaccess ping
<span class="prompt">FG (port2)#</span> next
<span class="prompt">FG (interface)#</span> end
<span class="prompt">FG&gt;</span> config firewall policy
<span class="prompt">FG (policy)#</span> edit 1
<span class="prompt">FG (1)#</span> set srcintf "port2"
<span class="prompt">FG (1)#</span> set dstintf "port1"
<span class="prompt">FG (1)#</span> set srcaddr "all"
<span class="prompt">FG (1)#</span> set dstaddr "all"
<span class="prompt">FG (1)#</span> set action accept
<span class="prompt">FG (1)#</span> set schedule "always"
<span class="prompt">FG (1)#</span> set service "ALL"
<span class="prompt">FG (1)#</span> next
<span class="prompt">FG (policy)#</span> end</pre>
      <div class="note why"><strong>Why this matters:</strong> This is the <em>inside→outside</em> policy only — the inside can initiate, the outside can't come back in. This is the minimum viable hardened edge. (In the Attack phase you'll deliberately add the hole.)</div>
    </div>

    <div class="step">
      <div class="step-label"><span class="n">5</span> Give the PCs addresses &amp; prove inside works</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">PC1&gt;</span> ip 10.0.10.10 255.255.255.0 10.0.10.1
<span class="prompt">PC2&gt;</span> ip 10.0.20.20 255.255.255.0 10.0.20.1</pre>
      <p>From PC1, ping PC2 (cross-VLAN through R2):</p>
      <pre><button class="copy-btn">copy</button><span class="prompt">PC1&gt;</span> ping 10.0.20.20
<span class="cmt">84 bytes from 10.0.20.20 icmp_seq=1 ttl=62 time=...</span></pre>
      <div class="note why"><strong>Why this matters:</strong> Inter-VLAN routing works. The inside is a functioning segmented network — and the firewall hasn't even been asked to pass traffic yet.</div>
    </div>
  </div>
$md$)
ON CONFLICT (lab_id, phase) DO UPDATE SET
  title = EXCLUDED.title,
  is_pro_only = EXCLUDED.is_pro_only,
  content = EXCLUDED.content;

-- ─────────────────────────── ATTACK ───────────────────────────
INSERT INTO lab_phases (lab_id, phase, title, is_pro_only, content)
VALUES (47, 'attack', 'Open the gate — the wide-open firewall', false, $md$
<div class="phase attack">
    <div class="phase-head">
      <span class="phase-tag">Attack</span>
      <h3>Open the gate — the wide-open firewall</h3>
    </div>
    <p class="goal">The "quick fix" that ruins networks: an any→any inbound policy. Add one line to the FortiGate and watch the outside world walk straight into your segmented inside.</p>

    <div class="step">
      <div class="step-label"><span class="n">1</span> Add the inbound any→any policy (the mistake)</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">FG&gt;</span> config firewall policy
<span class="prompt">FG (policy)#</span> edit 2
<span class="prompt">FG (2)#</span> set srcintf "port1"
<span class="prompt">FG (2)#</span> set dstintf "port2"
<span class="prompt">FG (2)#</span> set srcaddr "all"
<span class="prompt">FG (2)#</span> set dstaddr "all"
<span class="prompt">FG (2)#</span> set action accept
<span class="prompt">FG (2)#</span> set schedule "always"
<span class="prompt">FG (2)#</span> set service "ALL"
<span class="prompt">FG (2)#</span> next
<span class="prompt">FG (policy)#</span> end</pre>
      <div class="note watch"><strong>Watch it:</strong> this single policy turns the firewall into a router. Anyone on port1 can now reach everything on port2 — the entire segmentation you built in Build is decorative.</div>
    </div>

    <div class="step">
      <div class="step-label"><span class="n">2</span> Probe the hole from Kali</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">kali$</span> ip route add default via 203.0.113.254
<span class="prompt">kali$</span> ping -c 3 10.0.10.10
<span class="cmt">64 bytes from 10.0.10.10: icmp_seq=1 ttl=60 time=...</span>
<span class="prompt">kali$</span> ping -c 3 10.0.20.20
<span class="cmt">64 bytes from 10.0.20.20: icmp_seq=1 ttl=60 time=...</span></pre>
      <div class="note why"><strong>Why this matters:</strong> Kali is on the outside (203.0.113.100) and just reached both inside hosts. The firewall is doing nothing. From here an attacker would scan, enumerate, and pivot — every "inside" system is now exposed.</div>
    </div>

    <div class="step">
      <div class="step-label"><span class="n">3</span> Confirm the leak from R1's vantage</div>
      <p>From R1 (the outside edge router), verify the path across the firewall is open end-to-end:</p>
      <pre><button class="copy-btn">copy</button><span class="prompt">R1#</span> ping 10.0.0.2 repeat 3
<span class="cmt">!!!!! (R2 answers through the firewall)</span>
<span class="prompt">R1#</span> ping 10.0.10.10 repeat 3
<span class="cmt">!!!!! (PC1 answers through the firewall)</span></pre>
      <div class="note why"><strong>Why this matters:</strong> The grader checks exactly this: R1 reaching PC1/PC2 through the firewall is the proof the attack path is open.</div>
    </div>
  </div>
$md$)
ON CONFLICT (lab_id, phase) DO UPDATE SET
  title = EXCLUDED.title,
  is_pro_only = EXCLUDED.is_pro_only,
  content = EXCLUDED.content;

-- ─────────────────────────── TOPOLOGY SVG ───────────────────────────
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (
  47,
  $svg$<svg viewBox="0 0 900 320" role="img" aria-label="Network topology: Kali attacker outside, edge router, FortiGate firewall, internal router, switch with two segmented hosts">
      <!-- links (outside → inside) -->
      <line x1="150" y1="138" x2="180" y2="138" stroke="#e5484d" stroke-width="2"/>
      <line x1="300" y1="138" x2="330" y2="138" stroke="#e5484d" stroke-width="2"/>
      <line x1="450" y1="138" x2="480" y2="138" stroke="#2563eb" stroke-width="2"/>
      <line x1="600" y1="138" x2="630" y2="138" stroke="#2563eb" stroke-width="2"/>
      <line x1="700" y1="138" x2="770" y2="96" stroke="#2563eb" stroke-width="2"/>
      <line x1="700" y1="138" x2="770" y2="184" stroke="#2563eb" stroke-width="2"/>

      <!-- port labels -->
      <text x="160" y="128" text-anchor="middle" font-family="monospace" font-size="10" fill="#e5484d">eth0</text>
      <text x="310" y="128" text-anchor="middle" font-family="monospace" font-size="10" fill="#e5484d">port1</text>
      <text x="460" y="128" text-anchor="middle" font-family="monospace" font-size="10" fill="#2563eb">port2</text>
      <text x="610" y="128" text-anchor="middle" font-family="monospace" font-size="10" fill="#2563eb">e0/0</text>
      <text x="745" y="112" font-family="monospace" font-size="10" fill="#2563eb">e0/1</text>
      <text x="745" y="168" font-family="monospace" font-size="10" fill="#2563eb">e0/2</text>

      <!-- Kali (outside, attacker) -->
      <rect x="30" y="110" width="120" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
      <text x="90" y="132" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
      <text x="90" y="148" text-anchor="middle" font-family="monospace" font-size="10" fill="#e5484d">203.0.113.100</text>

      <!-- R1 edge router -->
      <rect x="180" y="110" width="120" height="56" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="240" y="132" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#2563eb">R1</text>
      <text x="240" y="148" text-anchor="middle" font-family="monospace" font-size="10" fill="#64748b">c2691 · edge</text>

      <!-- FortiGate firewall -->
      <rect x="330" y="110" width="120" height="56" rx="8" fill="#fff7ed" stroke="#ea580c" stroke-width="2"/>
      <text x="390" y="132" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#ea580c">FW</text>
      <text x="390" y="148" text-anchor="middle" font-family="monospace" font-size="10" fill="#ea580c">FortiGate</text>

      <!-- R2 internal router -->
      <rect x="480" y="110" width="120" height="56" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="540" y="132" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#2563eb">R2</text>
      <text x="540" y="148" text-anchor="middle" font-family="monospace" font-size="10" fill="#64748b">c7200 · inter-VLAN</text>

      <!-- SW1 switch -->
      <rect x="630" y="110" width="140" height="46" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="700" y="132" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">SW1</text>
      <text x="700" y="148" text-anchor="middle" font-family="monospace" font-size="10" fill="#64748b">IOU 15.1g · L2</text>

      <!-- PC1 VLAN 10 -->
      <rect x="770" y="60" width="110" height="50" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="825" y="80" text-anchor="middle" font-family="monospace" font-size="12" font-weight="700" fill="#0f172a">PC1</text>
      <text x="825" y="96" text-anchor="middle" font-family="monospace" font-size="9" fill="#64748b">10.0.10.10 · VLAN 10</text>

      <!-- PC2 VLAN 20 -->
      <rect x="770" y="180" width="110" height="50" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="825" y="200" text-anchor="middle" font-family="monospace" font-size="12" font-weight="700" fill="#0f172a">PC2</text>
      <text x="825" y="216" text-anchor="middle" font-family="monospace" font-size="9" fill="#64748b">10.0.20.20 · VLAN 20</text>

      <text x="450" y="310" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">outside (untrusted) ── FW ── inside (trusted, segmented)</text>
    </svg>$svg$,
  $svg$<svg viewBox="0 0 900 320" role="img" aria-label="Network topology: Kali attacker outside, edge router, FortiGate firewall, internal router, switch with two segmented hosts">
      <!-- links (outside → inside) -->
      <line x1="150" y1="138" x2="180" y2="138" stroke="#e5484d" stroke-width="2"/>
      <line x1="300" y1="138" x2="330" y2="138" stroke="#e5484d" stroke-width="2"/>
      <line x1="450" y1="138" x2="480" y2="138" stroke="#2563eb" stroke-width="2"/>
      <line x1="600" y1="138" x2="630" y2="138" stroke="#2563eb" stroke-width="2"/>
      <line x1="700" y1="138" x2="770" y2="96" stroke="#2563eb" stroke-width="2"/>
      <line x1="700" y1="138" x2="770" y2="184" stroke="#2563eb" stroke-width="2"/>

      <!-- port labels -->
      <text x="160" y="128" text-anchor="middle" font-family="monospace" font-size="10" fill="#e5484d">eth0</text>
      <text x="310" y="128" text-anchor="middle" font-family="monospace" font-size="10" fill="#e5484d">port1</text>
      <text x="460" y="128" text-anchor="middle" font-family="monospace" font-size="10" fill="#2563eb">port2</text>
      <text x="610" y="128" text-anchor="middle" font-family="monospace" font-size="10" fill="#2563eb">e0/0</text>
      <text x="745" y="112" font-family="monospace" font-size="10" fill="#2563eb">e0/1</text>
      <text x="745" y="168" font-family="monospace" font-size="10" fill="#2563eb">e0/2</text>

      <!-- Kali (outside, attacker) -->
      <rect x="30" y="110" width="120" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
      <text x="90" y="132" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
      <text x="90" y="148" text-anchor="middle" font-family="monospace" font-size="10" fill="#e5484d">203.0.113.100</text>

      <!-- R1 edge router -->
      <rect x="180" y="110" width="120" height="56" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="240" y="132" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#2563eb">R1</text>
      <text x="240" y="148" text-anchor="middle" font-family="monospace" font-size="10" fill="#64748b">c2691 · edge</text>

      <!-- FortiGate firewall -->
      <rect x="330" y="110" width="120" height="56" rx="8" fill="#fff7ed" stroke="#ea580c" stroke-width="2"/>
      <text x="390" y="132" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#ea580c">FW</text>
      <text x="390" y="148" text-anchor="middle" font-family="monospace" font-size="10" fill="#ea580c">FortiGate</text>

      <!-- R2 internal router -->
      <rect x="480" y="110" width="120" height="56" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="540" y="132" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#2563eb">R2</text>
      <text x="540" y="148" text-anchor="middle" font-family="monospace" font-size="10" fill="#64748b">c7200 · inter-VLAN</text>

      <!-- SW1 switch -->
      <rect x="630" y="110" width="140" height="46" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="700" y="132" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">SW1</text>
      <text x="700" y="148" text-anchor="middle" font-family="monospace" font-size="10" fill="#64748b">IOU 15.1g · L2</text>

      <!-- PC1 VLAN 10 -->
      <rect x="770" y="60" width="110" height="50" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="825" y="80" text-anchor="middle" font-family="monospace" font-size="12" font-weight="700" fill="#0f172a">PC1</text>
      <text x="825" y="96" text-anchor="middle" font-family="monospace" font-size="9" fill="#64748b">10.0.10.10 · VLAN 10</text>

      <!-- PC2 VLAN 20 -->
      <rect x="770" y="180" width="110" height="50" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="825" y="200" text-anchor="middle" font-family="monospace" font-size="12" font-weight="700" fill="#0f172a">PC2</text>
      <text x="825" y="216" text-anchor="middle" font-family="monospace" font-size="9" fill="#64748b">10.0.20.20 · VLAN 20</text>

      <text x="450" y="310" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">outside (untrusted) ── FW ── inside (trusted, segmented)</text>
    </svg>$svg$,
  '[]'::jsonb
)
ON CONFLICT (lab_id) DO UPDATE SET
  svg_small = EXCLUDED.svg_small,
  svg_large = EXCLUDED.svg_large,
  legend    = EXCLUDED.legend;

-- ─────────────────────────── HARDEN ───────────────────────────
INSERT INTO lab_phases (lab_id, phase, title, is_pro_only, content)
VALUES (47, 'harden', 'Close the gate — least privilege', false, $md$
<div class="phase harden">
    <div class="phase-head">
      <span class="phase-tag">Harden</span>
      <h3>Close the gate — least privilege</h3>
    </div>
    <p class="goal">Delete the inbound any→any policy, keep only the inside→outside path, and prove the outside world is locked out again — while the inside keeps working.</p>

    <div class="step">
      <div class="step-label"><span class="n">1</span> Remove the inbound policy</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">FG&gt;</span> config firewall policy
<span class="prompt">FG (policy)#</span> delete 2
<span class="prompt">FG (policy)#</span> end
<span class="prompt">FG&gt;</span> execute system show policy</pre>
      <div class="note why"><strong>Why this matters:</strong> Only policy 1 (inside→outside) remains. The default deny for everything else is back in force.</div>
    </div>

    <div class="step">
      <div class="step-label"><span class="n">2</span> Prove the outside is blocked</div>
      <p>From R1, the same pings that worked in Attack must now fail:</p>
      <pre><button class="copy-btn">copy</button><span class="prompt">R1#</span> ping 10.0.10.10 repeat 3
<span class="cmt">..... (no answer — PC1 is hidden again)</span>
<span class="prompt">R1#</span> ping 10.0.20.20 repeat 3
<span class="cmt">..... (no answer — PC2 is hidden again)</span></pre>
      <div class="note why"><strong>Why this matters:</strong> The FortiGate is no longer forwarding outside→inside traffic. Kali's pings from Attack would now time out too — the attack path is closed.</div>
    </div>

    <div class="step">
      <div class="step-label"><span class="n">3</span> Prove the inside still works</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">PC1&gt;</span> ping 10.0.20.20
<span class="cmt">84 bytes from 10.0.20.20 icmp_seq=1 ttl=62 time=...</span>
<span class="prompt">PC2&gt;</span> ping 10.0.10.10
<span class="cmt">84 bytes from 10.0.10.10 icmp_seq=1 ttl=62 time=...</span></pre>
      <div class="note why"><strong>Why this matters:</strong> Segmentation intact, inter-VLAN routing alive, and the edge is locked. That's a firewall doing its job: permit what's needed, deny everything else.</div>
    </div>
  </div>
$md$)
ON CONFLICT (lab_id, phase) DO UPDATE SET
  title = EXCLUDED.title,
  is_pro_only = EXCLUDED.is_pro_only,
  content = EXCLUDED.content;
