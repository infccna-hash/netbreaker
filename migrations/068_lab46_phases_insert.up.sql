-- 068_lab46_phases_insert.up.sql
-- Migration 038 inserted lab + topology but used UPDATE for lab_phases
-- (rows didn't exist yet). This adds the missing lab_phases rows.

INSERT INTO lab_phases (lab_id, phase, title, is_pro_only, content)
VALUES
(46, 'build', 'Stand up the segment & prove isolation', false,
'<div class="phase build">
    <div class="phase-head">
      <span class="phase-tag">Build</span>
      <h3>Stand up the segment & prove isolation</h3>
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
      <div class="step-label"><span class="n">2</span> Verify baseline isolation</div>
      <p>Ping between PC-A and PC-B. Check the CAM table — only their MACs are learned. Kali on e0/3 cannot see their unicast traffic because the switch forwards only to the known destination port.</p>
    </div>
    <p><em>Full content in migration 038. This is a recovery insert (migration 038 UPDATE had no target rows).</em></p>
  </div>'),

(46, 'attack', 'Flood the table, drink the traffic', false,
'<div class="phase attack">
    <div class="phase-head">
      <span class="phase-tag">Attack</span>
      <h3>Flood the table, drink the traffic</h3>
    </div>
    <p class="goal">macof generates a torrent of frames with random source MACs. Each new source MAC the switch dutifully tries to learn — until the table is full and it can no longer track where real hosts live.</p>
    <div class="step">
      <div class="step-label"><span class="n">1</span> Open the flood from Kali</div>
      <pre><button class="copy-btn">copy</button><span class="attackline">kali$ macof -i eth0</span>
<span class="cmt"># ~155,000 frames/min of random src MACs. Leave it running.</span></pre>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">2</span> Watch the CAM table overflow</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">SW1#</span> show mac address-table count
<span class="cmt">Dynamic Address Count:  <b>8189</b>   ← pinned at platform max</span></pre>
      <p>Once the table is full, the switch floods unknown unicast out every port in VLAN 10 — including Kali''s port.</p>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">3</span> Capture the leaked traffic</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">kali$</span> tshark -i eth0 -f "host 10.0.10.10 and host 10.0.10.20"</pre>
      <p>Traffic that was private during the build phase now pours into Kali''s capture. The switch is behaving like a hub.</p>
    </div>
  </div>'),

(46, 'harden', 'Cap the port, kill the flood', false,
'<div class="phase harden">
    <div class="phase-head">
      <span class="phase-tag">Harden</span>
      <h3>Cap the port, kill the flood</h3>
    </div>
    <p class="goal">The flood works because one port can introduce unlimited source MACs. Port security bounds that.</p>
    <div class="step">
      <div class="step-label"><span class="n">1</span> Lock the access ports</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">SW1(config)#</span> interface range e0/1 - 3
<span class="prompt">SW1(config-if-range)#</span> switchport port-security
<span class="prompt">SW1(config-if-range)#</span> switchport port-security maximum 2
<span class="prompt">SW1(config-if-range)#</span> switchport port-security mac-address sticky
<span class="prompt">SW1(config-if-range)#</span> switchport port-security violation restrict</pre>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">2</span> Re-attack — and watch it die</div>
      <pre><button class="copy-btn">copy</button><span class="attackline">kali$ macof -i eth0</span>   <span class="cmt"># same command, now neutered</span>

<span class="prompt">SW1#</span> show port-security interface e0/3
<span class="cmt">Security Violation Count : 41276</span></pre>
      <p>The CAM table stays clean. Port-security drops the flood at line rate.</p>
    </div>
  </div>')
ON CONFLICT (lab_id, phase) DO UPDATE SET
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  is_pro_only = EXCLUDED.is_pro_only;
