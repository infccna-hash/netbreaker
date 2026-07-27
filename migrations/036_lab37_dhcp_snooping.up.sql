-- ═══════════════════════════════════════════════════════
-- Lab 37 (id=37) — DHCP Snooping : full content (Vol 2 · Ch 13)
-- ═══════════════════════════════════════════════════════

UPDATE labs
SET short_desc = 'Stand up a rogue DHCP server that hands out itself as the gateway — silently hijacking every new client''s traffic — then watch DHCP Snooping refuse to even let the lie leave the port.',
    topic = 'services',
    difficulty = 'medium',
    book_ref = 'Vol 2 · Ch 13'
WHERE id = 37;

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  title = 'Trust Every Port Equally',
  is_pro_only = false,
  content = $md$
<div class="phase-head"><span class="phase-tag">Build</span><h3>DHCP working, rogue lurking</h3></div>
    <p class="goal">Reuse the Lab 08 topology: R1 leasing on VLAN 10, port-security already on the access ports. Confirm a clean lease, then confirm the rogue can still bite.</p>
    <div class="step">
      <div class="step-label"><span class="n">1</span> Baseline a correct lease</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">PC-A></span> show ip
<span class="cmt">GATEWAY : 10.0.10.1     ← legit, from R1 over the trusted uplink</span></pre>
    </div>
  </div>

  <!-- ATTACK -->
$md$
WHERE lab_id = 37 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
UPDATE lab_phases SET
  title = 'Win the Race to the Gateway',
  is_pro_only = false,
  content = $md$
<div class="phase-head"><span class="phase-tag">Attack</span><h3>The rogue that survived Lab 08</h3></div>
    <p class="goal">Port-security is still on and it won't help here — the rogue uses one MAC. Show the residual attack landing, and grab the flag while the window is open.</p>
    <div class="step">
      <div class="step-label"><span class="n">1</span> Fire the single-MAC rogue</div>
      <pre><button class="copy-btn">copy</button><span class="attackline">kali$ dnsmasq -C /etc/dnsmasq-rogue.conf -d</span>   <span class="cmt"># gateway → 10.0.10.66</span>
<span class="prompt">kali$</span> sysctl -w net.ipv4.ip_forward=1

<span class="prompt">PC-B></span> show ip
<span class="cmt">GATEWAY : <b>10.0.10.66</b>   ← poisoned. Port-security never noticed.</span></pre>
      <div class="note watch"><strong>The point:</strong> no violation counter moved on any port. One MAC is within the limit. The switchport layer is blind to <em>what</em> a permitted host is saying — only snooping inspects the DHCP semantics.</div>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">2</span> Capture the flag through the rogue gateway</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">kali$</span> tshark -i eth0 -Y 'http.cookie' -T fields -e http.cookie
<span class="cmt">SESSION=NB37-untru5t3d-a1c9</span></pre>
    </div>
    <div class="flag">
      <div class="flag-label">🚩 Flag</div>
      <h4>Capture a token via the rogue gateway that survives port-security.</h4>
      <div class="flag-row"><input id="flag-in" placeholder="NB37-..."><button onclick="checkFlag()">Submit</button></div>
      <div class="flag-msg" id="flag-msg"></div>
    </div>
  </div>

  <!-- HARDEN -->
$md$
WHERE lab_id = 37 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
UPDATE lab_phases SET
  title = 'Only the Router Gets to Answer',
  is_pro_only = false,
  content = $md$
<div class="phase-head"><span class="phase-tag">Harden</span><h3>Trust the uplink, distrust the rest</h3></div>
    <p class="goal">DHCP snooping inspects DHCP messages and enforces one rule: server-side messages (OFFER/ACK) are legitimate only from ports you mark trusted. This is the fix port-security structurally could not be.</p>
    <div class="step">
      <div class="step-label"><span class="n">1</span> Enable snooping, trust only the uplink</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">SW1(config)#</span> ip dhcp snooping
<span class="prompt">SW1(config)#</span> ip dhcp snooping vlan 10
<span class="prompt">SW1(config)#</span> interface e0/0
<span class="prompt">SW1(config-if)#</span> ip dhcp snooping trust          <span class="cmt"># the only port to R1</span>
<span class="prompt">SW1(config)#</span> interface range e0/1 - 3
<span class="prompt">SW1(config-if-range)#</span> ip dhcp snooping limit rate 10   <span class="cmt"># proper starvation rate-limit</span></pre>
      <div class="note trap"><strong>Bench trap:</strong> if DHCP breaks entirely after enabling snooping and R1 isn't a relay agent, add <code>no ip dhcp snooping information option</code> globally. The switch inserts option-82 by default and a non-relay server drops those requests. This bites nearly everyone once.</div>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">2</span> Re-attack — rogue OFFER dropped on sight</div>
      <pre><button class="copy-btn">copy</button><span class="attackline">kali$ dnsmasq -C /etc/dnsmasq-rogue.conf -d</span>

<span class="prompt">SW1#</span> <span class="cmt">%DHCP_SNOOPING-5-DHCP_SNOOPING_UNTRUSTED_PORT: Received DHCP
  OFFER on untrusted port Et0/3, dropping</span>

<span class="prompt">PC-B></span> show ip
<span class="good">GATEWAY : 10.0.10.1   ← back to R1. Race or no race, the rogue can't answer.</span></pre>
      <div class="note why"><strong>Why this is the real fix:</strong> it doesn't limit or count — it <em>drops</em> server messages from untrusted ports outright. Speed and MAC count are irrelevant; a rogue on a client port simply cannot deliver an OFFER. That's the difference between mitigating and eliminating.</div>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">3</span> Inspect the binding table you just built</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">SW1#</span> show ip dhcp snooping binding
<span class="cmt">MacAddress        IpAddress    Lease  Type          VLAN  Interface
aabb.cc00.0100    10.0.10.10   6912   dhcp-snooping   10   Et0/1</span></pre>
      <div class="note why"><strong>This table is the real prize:</strong> as snooping watches legitimate leases it records every valid IP↔MAC↔port binding. It's not just for DHCP — it's the ground truth other defenses stand on.</div>
    </div>

    <div class="nextlab">
      <b>Unlocks Lab 38 — Dynamic ARP Inspection.</b> DAI validates ARP replies against exactly this snooping binding table: if a host ARPs with an IP/MAC pair that isn't in the table, the reply is dropped. No DHCP snooping, no binding table, no DAI — which is why this lab is a hard prerequisite for the ARP-spoofing defense. IP Source Guard reads the same table to pin source IPs per port.
    </div>
  </div>
$md$
WHERE lab_id = 37 AND phase = 'harden';

-- ─────────────────────────── TOPOLOGY ───────────────────────────
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (
  37,
  $svg$<svg viewBox="0 0 720 320" role="img" aria-label="Switch with a trusted uplink to the real DHCP server and untrusted client ports, one of which hosts a rogue server">
      <rect x="40" y="30" width="150" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="115" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R1</text>
      <text x="115" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">real DHCP · 10.0.10.1</text>
      <rect x="300" y="30" width="130" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="365" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">SW1</text>
      <text x="365" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">snooping enabled</text>
      <!-- trusted uplink -->
      <line x1="190" y1="55" x2="300" y2="55" stroke="#16a34a" stroke-width="3"/>
      <text x="245" y="46" text-anchor="middle" font-family="monospace" font-size="9" fill="#16a34a" font-weight="700">e0/0 · TRUSTED</text>
      <!-- untrusted downlinks -->
      <line x1="330" y1="80" x2="160" y2="230" stroke="#64748b" stroke-width="2"/>
      <line x1="400" y1="80" x2="575" y2="230" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 4"/>
      <text x="238" y="160" font-family="monospace" font-size="9" fill="#64748b">e0/1 · untrusted</text>
      <text x="470" y="160" font-family="monospace" font-size="9" fill="#e5484d">e0/3 · untrusted</text>
      <rect x="100" y="230" width="120" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="160" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC-A</text>
      <text x="160" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">legit client</text>
      <rect x="515" y="230" width="120" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
      <text x="575" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
      <text x="575" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#e5484d">rogue server</text>
      <text x="360" y="308" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">server replies are legal only from the trusted uplink — anywhere else, dropped</text>
    </svg>$svg$,
  $svg$<svg viewBox="0 0 720 320" role="img" aria-label="Switch with a trusted uplink to the real DHCP server and untrusted client ports, one of which hosts a rogue server">
      <rect x="40" y="30" width="150" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="115" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R1</text>
      <text x="115" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">real DHCP · 10.0.10.1</text>
      <rect x="300" y="30" width="130" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="365" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">SW1</text>
      <text x="365" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">snooping enabled</text>
      <!-- trusted uplink -->
      <line x1="190" y1="55" x2="300" y2="55" stroke="#16a34a" stroke-width="3"/>
      <text x="245" y="46" text-anchor="middle" font-family="monospace" font-size="9" fill="#16a34a" font-weight="700">e0/0 · TRUSTED</text>
      <!-- untrusted downlinks -->
      <line x1="330" y1="80" x2="160" y2="230" stroke="#64748b" stroke-width="2"/>
      <line x1="400" y1="80" x2="575" y2="230" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 4"/>
      <text x="238" y="160" font-family="monospace" font-size="9" fill="#64748b">e0/1 · untrusted</text>
      <text x="470" y="160" font-family="monospace" font-size="9" fill="#e5484d">e0/3 · untrusted</text>
      <rect x="100" y="230" width="120" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="160" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC-A</text>
      <text x="160" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">legit client</text>
      <rect x="515" y="230" width="120" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
      <text x="575" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
      <text x="575" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#e5484d">rogue server</text>
      <text x="360" y="308" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">server replies are legal only from the trusted uplink — anywhere else, dropped</text>
    </svg>$svg$,
  '[]'::jsonb
)
ON CONFLICT (lab_id) DO UPDATE SET
  svg_small = EXCLUDED.svg_small,
  svg_large = EXCLUDED.svg_large,
  legend    = EXCLUDED.legend;
