-- ═══════════════════════════════════════════════════════════════════
-- Lab (id=35) — Quality of Service : full content (Vol 2 · Ch 10)
-- ═══════════════════════════════════════════════════════════════════

UPDATE labs
SET short_desc = 'Put a voice call on a link with nothing protecting it — then flood that same link and watch the call die under ordinary bulk traffic, no exploit required.'
WHERE id = 35;

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  title = 'Share the Link and Hope',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 1 of 3</span>
<h3>Share the Link and Hope</h3>
<p>Every packet on a default Cisco interface goes into the same queue and leaves in the order it arrived — FIFO, first-in-first-out, no opinions. That's fine when the link has room to spare. It's a disaster the moment something latency-sensitive (a voice call, needing packets every 20ms with almost no delay) shares a link with something that doesn't care about delay at all (a bulk file transfer, happy to use every available byte). Nobody has to attack you for this to go wrong. It just happens, by default, on a link with no QoS policy.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 500 XP</span>
<span class="chip diff">◆ Difficulty: ★★☆☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: FIFO queuing · DSCP marking · voice vs. bulk traffic behavior</span>
</div>

## Your arsenal (GNS3)

| Device | Role |
|---|---|
| R1, R2 | Connected by a deliberately narrow link — the contention point |
| PC1 | Simulates a voice endpoint (small, frequent, latency-sensitive packets) |
| KALI | Bulk traffic source — and your attacker in Phase 2 |

Wire `PC1 → R1`, `KALI → R1`, `R1 ↔ R2` (this middle link is the one you'll starve).

<ul class="objectives">
<li>Constrain the R1↔R2 link to a low, realistic bandwidth</li>
<li>Baseline: measure voice-like traffic quality with the link otherwise idle</li>
<li>Confirm no QoS policy exists yet (the trap)</li>
</ul>

## Step 1 — Make the link small enough to matter

A gigabit lab link never contends. Shrink it so contention is real:

```
enable
configure terminal
interface GigabitEthernet0/1
 bandwidth 512
 service-policy output BASELINE-NONE
end
```
(You'll create `BASELINE-NONE` as an empty/default policy shortly — or simply skip attaching any policy at all for this baseline; the point is proving default behavior first.)

## Step 2 — Simulate a voice call

Real voice (G.711) sends a small packet roughly every 20ms. Approximate it from PC1 with rapid small pings:

```
ping <R2-side-IP> -i 0.02 -s 160 -c 100
```
Note the round-trip times — with the link otherwise idle, these should be small and consistent (low jitter).

## Step 3 — Confirm there's no QoS policy protecting anything

```
show policy-map interface GigabitEthernet0/1
```
Should show no service-policy attached, or only a default class with no special treatment. Every packet — voice, bulk, whatever — is equally unprotected.

<div class="callout warn">
<p>This is completely normal on a freshly-configured router. Nobody misconfigured anything. QoS is opt-in — and most of the internet's small-office links never opt in.</p>
</div>

<div class="achievement">
<span class="medal">📞</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Dial Tone — a clean baseline, about to get a lot less clean</span></span>
</div>

**Next:** Phase 2 — put real bulk traffic on that same link and watch the "voice call" fall apart, with nothing more exotic than an ordinary file transfer.
$md$
WHERE lab_id = 35 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
UPDATE lab_phases SET
  title = 'Drown the Call in Ordinary Traffic',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 2 of 3</span>
<h3>Drown the Call in Ordinary Traffic</h3>
<p>This phase doesn't need an exploit. That's the point. A default FIFO queue treats a voice packet and a bulk-transfer packet as equally important — which in practice means the bulk transfer, which sends far more packets and doesn't care about delay, wins by sheer volume. You're about to prove that "no QoS policy" is itself the vulnerability.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 650 XP</span>
<span class="chip diff">◆ Difficulty: ★★☆☆☆</span>
<span class="chip time">◷ ~10 min</span>
<span class="chip loot">⚿ Loot: bandwidth starvation · queuing delay · jitter under load</span>
</div>

## Step 1 — Start the "voice call" running continuously

Keep this running in its own terminal from PC1 for the rest of this phase:
```
ping <R2-side-IP> -i 0.02 -s 160
```

## Step 2 — Saturate the link from Kali

```
sudo apt install -y iperf3
iperf3 -c <R2-side-IP> -t 60 -b 0
```
`-b 0` means "as fast as the link will take it." On a 512 kbps constrained link, this bulk stream alone can consume everything available.

## Step 3 — Watch the voice call fall apart

Switch back to the PC1 ping terminal:

<div class="callout tip">
<p><strong>💥 That's the moment.</strong> Round-trip times that were a steady few milliseconds are now spiking into the hundreds, with visible jitter and possibly dropped pings entirely. Nothing was exploited. A completely ordinary file transfer — the kind that happens on every network, every day — just made a voice call unusable purely by existing on the same unprotected link.</p>
</div>

Confirm the queue is the bottleneck:
```
show interfaces GigabitEthernet0/1 | include output queue
```
A climbing output-queue drop counter is the FIFO queue giving up and discarding packets indiscriminately — voice and bulk both, whichever happened to arrive when the queue was full.

<div class="achievement">
<span class="medal">📵</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Call Dropped — no exploit, just an unprotected queue</span></span>
</div>

**Next:** Phase 3 — give voice traffic its own lane that bulk traffic cannot touch, no matter how much of it shows up.
$md$
WHERE lab_id = 35 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
UPDATE lab_phases SET
  title = 'Give the Call Its Own Lane',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 3 of 3</span>
<h3>Give the Call Its Own Lane</h3>
<p>The fix isn't more bandwidth — a bigger link just moves the same problem to a bigger number. The fix is <strong>classifying</strong> traffic, <strong>marking</strong> it, and giving voice a strict-priority queue that bulk traffic is structurally unable to fill, no matter how much of it shows up.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 800 XP</span>
<span class="chip diff">◆ Difficulty: ★★★☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: class-map/policy-map · DSCP EF marking · Low Latency Queuing (LLQ)</span>
</div>

<ul class="objectives">
<li>Classify voice traffic by port range</li>
<li>Mark it DSCP EF (Expedited Forwarding)</li>
<li>Give it a strict-priority queue with <code>priority</code>, capped so it can't starve everything else</li>
<li>Re-run the flood → voice barely notices</li>
</ul>

## Fix 1 — Classify voice traffic

Real VoIP typically rides RTP on a UDP port range. Match it:

```
configure terminal
class-map match-all VOICE
 match ip dscp ef
class-map match-all VOICE-PORTS
 match ip rtp 16384 16383
end
```

## Fix 2 — Build the policy: priority queue for voice, fair share for the rest

```
configure terminal
policy-map QOS-POLICY
 class VOICE-PORTS
  priority percent 20
  set ip dscp ef
 class class-default
  fair-queue
  random-detect
end
```
`priority percent 20` gives voice a strict-priority queue capped at 20% of the link — enough for real call volume, but bounded so voice itself can never be used to starve everything else. `class-default` gets fair-queuing plus WRED so bulk flows share what's left reasonably instead of one flow monopolizing it.

## Fix 3 — Apply it to the contended link

```
configure terminal
interface GigabitEthernet0/1
 service-policy output QOS-POLICY
end
```

## Re-run the attack (the fun part)

Start the voice ping again:
```
ping <R2-side-IP> -i 0.02 -s 160
```
And the same flood from Kali:
```
iperf3 -c <R2-side-IP> -t 60 -b 0
```

<div class="callout tip">
<p>This time the ping times stay close to baseline. The priority queue is serviced first, every cycle, regardless of how much bulk traffic is waiting — that's the entire mechanism. The flood is still landing at full force; it's just no longer able to touch voice.</p>
</div>

## Prove it to the grader

```
show policy-map interface GigabitEthernet0/1
! Confirms: VOICE-PORTS class in priority queue, packets matched, no priority-queue drops
show policy-map interface GigabitEthernet0/1 | include (queue depth|drops)
```

<div class="achievement">
<span class="medal">🛡️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Clear Line — the flood is still running, and nobody on the call can tell</span></span>
</div>

<div class="mission">
<span class="tag">✔ LAB COMPLETE</span>
<h3>Quality of Service — cleared</h3>
<p>You proved that an unprotected link doesn't need an attacker to fail a voice call — an ordinary bulk transfer does it for free. Then you classified, marked, and prioritized voice traffic into its own strict queue, and the exact same flood that killed the call the first time couldn't touch it the second.</p>
<p><strong>Total: 1950 XP</strong> · Next target: <code>Port Security</code>, where locking a port to one MAC address turns out to have a very flood-able limit.</p>
</div>
$md$
WHERE lab_id = 35 AND phase = 'harden';

-- ─────────────────────────── TOPOLOGY ───────────────────────────
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (
  35,
  $svg$<svg viewBox="0 0 340 140" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <rect x="130" y="50" width="80" height="34" rx="7" fill="#fff" stroke="#14161a" stroke-width="1.4"/>
  <text x="170" y="72" text-anchor="middle" font-size="10" fill="#14161a" font-weight="600">R1 ↔ R2</text>
  <rect x="10" y="10" width="90" height="30" rx="6" fill="#fff" stroke="#1d4fc7" stroke-width="1.5"/>
  <text x="55" y="30" text-anchor="middle" font-size="9" fill="#1d4fc7" font-weight="600">PC1 (voice)</text>
  <rect x="240" y="10" width="90" height="30" rx="6" fill="#fff" stroke="#c02a30" stroke-width="1.5"/>
  <text x="285" y="30" text-anchor="middle" font-size="9" fill="#c02a30" font-weight="600">KALI (bulk)</text>
  <line x1="55" y1="40" x2="130" y2="60" stroke="#1d4fc7" stroke-width="2"/>
  <line x1="285" y1="40" x2="210" y2="60" stroke="#c02a30" stroke-width="2" stroke-dasharray="5 4"/>
  <text x="170" y="100" text-anchor="middle" font-size="8" fill="#6b7480">512 kbps contended link</text>
</svg>$svg$,
  $svg$<svg viewBox="0 0 700 260" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <rect x="270" y="100" width="160" height="56" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.8"/>
  <text x="350" y="124" text-anchor="middle" font-size="13" fill="#14161a" font-weight="700">R1 → R2</text>
  <text x="350" y="140" text-anchor="middle" font-size="9" fill="#6b7480">512 kbps · LLQ policy</text>
  <rect x="40" y="30" width="150" height="52" rx="9" fill="#fff" stroke="#1d4fc7" stroke-width="1.8"/>
  <text x="115" y="53" text-anchor="middle" font-size="12" fill="#1d4fc7" font-weight="600">PC1 · voice</text>
  <text x="115" y="69" text-anchor="middle" font-size="8" fill="#6b7480">20ms interval · DSCP EF</text>
  <rect x="510" y="30" width="150" height="52" rx="9" fill="#fff" stroke="#c02a30" stroke-width="1.8"/>
  <text x="585" y="53" text-anchor="middle" font-size="12" fill="#c02a30" font-weight="600">KALI · bulk</text>
  <text x="585" y="69" text-anchor="middle" font-size="8" fill="#6b7480">iperf3 · saturating flood</text>
  <line x1="115" y1="82" x2="300" y2="100" stroke="#1d4fc7" stroke-width="2.5"/>
  <line x1="585" y1="82" x2="400" y2="100" stroke="#c02a30" stroke-width="2.5" stroke-dasharray="6 5"/>
  <rect x="270" y="190" width="160" height="46" rx="8" fill="#fff" stroke="#0d7050" stroke-width="1.6"/>
  <text x="350" y="212" text-anchor="middle" font-size="11" fill="#0d7050" font-weight="600">priority 20% · voice</text>
  <text x="350" y="226" text-anchor="middle" font-size="9" fill="#6b7480">class-default: fair-queue</text>
  <line x1="350" y1="156" x2="350" y2="190" stroke="#0d7050" stroke-width="2"/>
</svg>$svg$,
  $json$["Voice endpoint", "Bulk traffic source", "Contended link with LLQ policy", "Priority queue (voice) vs. class-default (bulk)"]$json$::jsonb
)
ON CONFLICT (lab_id) DO UPDATE SET
  svg_small = EXCLUDED.svg_small,
  svg_large = EXCLUDED.svg_large,
  legend    = EXCLUDED.legend;
