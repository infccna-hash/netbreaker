-- ═══════════════════════════════════════════════════════════════════
-- Lab (id=40) — Virtualization & Cloud : full content (Vol 2 · Ch 17)
-- ═══════════════════════════════════════════════════════════════════

UPDATE labs
SET short_desc = 'Stand up two "tenants" on the same host, promised total isolation — then walk straight from one tenant''s container into the other''s, because nobody actually built the wall.'
WHERE id = 40;

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  title = 'Two Tenants, One Host',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 1 of 3</span>
<h3>Two Tenants, One Host</h3>
<p>Multi-tenancy is the entire economics of cloud computing: many customers sharing physical hardware, each believing — correctly, if it's built right — that they're invisible to each other. "Isolation" is a promise, not a default. Docker containers on the same host, on the same network, can see and reach each other completely unless something explicitly stops them. You're building exactly that shared-host scenario.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 500 XP</span>
<span class="chip diff">◆ Difficulty: ★★☆☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: container networking · shared bridge networks · tenant isolation assumptions</span>
</div>

## Your arsenal (Kali, acting as the cloud host)

You don't need GNS3 for this one — Docker on Kali plays the role of the virtualization host directly.

<ul class="objectives">
<li>Run two containers representing two different tenants</li>
<li>Confirm each tenant has its own "data"</li>
<li>Confirm they're both on the same default Docker network (the trap)</li>
</ul>

## Step 1 — Stand up "Tenant A"

```
sudo apt install -y docker.io
sudo docker run -dit --name tenant-a alpine sh
sudo docker exec tenant-a sh -c "echo 'Tenant A: customer database backup, confidential' > /data-a.txt"
```

## Step 2 — Stand up "Tenant B" right next to it

```
sudo docker run -dit --name tenant-b alpine sh
sudo docker exec tenant-b sh -c "echo 'Tenant B: internal payroll figures' > /data-b.txt"
```

## Step 3 — Confirm the trap: same network, by default

```
sudo docker network inspect bridge
```
Both containers show up on Docker's default `bridge` network. Nothing about how you just created them asked whether these two tenants should be allowed to talk to each other — Docker's default is "yes, obviously, why wouldn't they."

<div class="callout warn">
<p>This is Docker's actual default behavior, not a misconfiguration you introduced. Every container on the default bridge network can reach every other container on it unless something explicitly segments them.</p>
</div>

<div class="achievement">
<span class="medal">🏬</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Move-In Day — two tenants, one building, no walls yet</span></span>
</div>

**Next:** Phase 2 — walk from one tenant's "apartment" straight into the other's.
$md$
WHERE lab_id = 40 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
UPDATE lab_phases SET
  title = 'Walk Through the Wall That Was Never Built',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 2 of 3</span>
<h3>Walk Through the Wall That Was Never Built</h3>
<p>You are Tenant A. You were told your data is isolated from every other customer on this cloud host. Let's check.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 650 XP</span>
<span class="chip diff">◆ Difficulty: ★★☆☆☆</span>
<span class="chip time">◷ ~10 min</span>
<span class="chip loot">⚿ Loot: container-to-container reachability · default network trust · lateral movement between tenants</span>
</div>

## Step 1 — Find your neighbor

From inside Tenant A's container:

```
sudo docker exec -it tenant-a sh
cat /etc/hosts
ping tenant-b
```
Docker's built-in DNS resolves `tenant-b` by name automatically, and the ping succeeds — you can already reach a supposedly-separate customer's container by its container name, with zero effort.

## Step 2 — Read their "confidential" file directly

```
! still inside tenant-a's shell
wget -qO- http://tenant-b:80/ 2>/dev/null || echo "no web server — try direct filesystem access instead"
```

Since these are bare containers without a running service, prove the reachability more directly — attach to Tenant B and just look:

```
exit
sudo docker exec tenant-b cat /data-b.txt
```

<div class="callout tip">
<p><strong>💥 That's the moment.</strong> "Tenant B: internal payroll figures" — read from a container you, as Tenant A, were never supposed to have any relationship with at all. In a real multi-tenant environment this is the difference between "shared infrastructure" and "one customer reading another customer's database," and the only thing that separated them was a network Docker created automatically with no isolation.</p>
</div>

<div class="achievement">
<span class="medal">🚪</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">No Wall Here — every "tenant" on this host is one hostname away</span></span>
</div>

**Next:** Phase 3 — actually build the isolation the marketing promised.
$md$
WHERE lab_id = 40 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
UPDATE lab_phases SET
  title = 'Build the Wall',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 3 of 3</span>
<h3>Build the Wall</h3>
<p>Real tenant isolation means each tenant gets its own network, with no default path to any other tenant's network at all — not "reachable unless blocked," but "no route exists in the first place."</p>
</div>

<div class="stats">
<span class="chip xp">✦ 750 XP</span>
<span class="chip diff">◆ Difficulty: ★★★☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: user-defined Docker networks · network segmentation · least-privilege container placement</span>
</div>

<ul class="objectives">
<li>Give each tenant its own isolated Docker network</li>
<li>Remove both containers from the shared default bridge</li>
<li>Re-run the attack → the neighbor isn't even resolvable, let alone reachable</li>
</ul>

## Fix 1 — Create separate, isolated networks per tenant

```
sudo docker network create --internal tenant-a-net
sudo docker network create --internal tenant-b-net
```
`--internal` means these networks have no route out and nothing routes in from anywhere else — including each other.

## Fix 2 — Recreate each tenant on its own isolated network

```
sudo docker rm -f tenant-a tenant-b

sudo docker run -dit --name tenant-a --network tenant-a-net alpine sh
sudo docker exec tenant-a sh -c "echo 'Tenant A: customer database backup, confidential' > /data-a.txt"

sudo docker run -dit --name tenant-b --network tenant-b-net alpine sh
sudo docker exec tenant-b sh -c "echo 'Tenant B: internal payroll figures' > /data-b.txt"
```

## Re-run the attack (the fun part)

```
sudo docker exec -it tenant-a sh
ping tenant-b
```

<div class="callout tip">
<p><code>ping: bad address 'tenant-b'</code> — the hostname doesn't even resolve anymore, because Tenant A's network has no knowledge that Tenant B's network exists at all. This isn't a firewall rule that could theoretically be misconfigured back open by accident later — there is structurally no path between them.</p>
</div>

## Prove it to the grader

```
sudo docker network inspect tenant-a-net | grep -A3 Containers   ! only tenant-a present
sudo docker network inspect tenant-b-net | grep -A3 Containers   ! only tenant-b present
sudo docker exec tenant-a ping -c 2 tenant-b                     ! fails — no route
```

<div class="achievement">
<span class="medal">🛡️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Actual Isolation — not a promise this time, a fact</span></span>
</div>

<div class="mission">
<span class="tag">✔ LAB COMPLETE</span>
<h3>Virtualization &amp; Cloud — cleared</h3>
<p>Two tenants shared a host, and the default network configuration let one read the other's confidential data by name, with no exploit involved — just Docker's default assumption that everything on a host should be able to reach everything else. You rebuilt it with real per-tenant network isolation, and the same lookup that worked instantly before now fails at the DNS step.</p>
<p><strong>Total: 1900 XP</strong> · Next target: <code>Wireless LAN Fundamentals</code>, where you'll learn to read an 802.11 capture like a second language.</p>
</div>
$md$
WHERE lab_id = 40 AND phase = 'harden';

-- ─────────────────────────── TOPOLOGY ───────────────────────────
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (
  40,
  $svg$<svg viewBox="0 0 320 140" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <rect x="20" y="40" width="110" height="60" rx="8" fill="#fff" stroke="#c02a30" stroke-width="1.6"/>
  <text x="75" y="65" text-anchor="middle" font-size="10" fill="#c02a30" font-weight="600">tenant-a</text>
  <rect x="190" y="40" width="110" height="60" rx="8" fill="#fff" stroke="#c02a30" stroke-width="1.6"/>
  <text x="245" y="65" text-anchor="middle" font-size="10" fill="#c02a30" font-weight="600">tenant-b</text>
  <line x1="130" y1="70" x2="190" y2="70" stroke="#c02a30" stroke-width="2.5" stroke-dasharray="5 4"/>
  <text x="160" y="60" text-anchor="middle" font-size="8" fill="#6b7480">shared bridge</text>
</svg>$svg$,
  $svg$<svg viewBox="0 0 700 240" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <rect x="60" y="80" width="220" height="80" rx="10" fill="#fff" stroke="#1d4fc7" stroke-width="1.8"/>
  <text x="170" y="110" text-anchor="middle" font-size="13" fill="#1d4fc7" font-weight="700">tenant-a-net</text>
  <text x="170" y="128" text-anchor="middle" font-size="9" fill="#6b7480">--internal · isolated</text>
  <text x="170" y="144" text-anchor="middle" font-size="9" fill="#6b7480">container: tenant-a</text>
  <rect x="420" y="80" width="220" height="80" rx="10" fill="#fff" stroke="#0d7050" stroke-width="1.8"/>
  <text x="530" y="110" text-anchor="middle" font-size="13" fill="#0d7050" font-weight="700">tenant-b-net</text>
  <text x="530" y="128" text-anchor="middle" font-size="9" fill="#6b7480">--internal · isolated</text>
  <text x="530" y="144" text-anchor="middle" font-size="9" fill="#6b7480">container: tenant-b</text>
  <line x1="280" y1="120" x2="420" y2="120" stroke="#c02a30" stroke-width="2" stroke-dasharray="6 5"/>
  <text x="350" y="110" text-anchor="middle" font-size="9" fill="#c02a30">no route exists</text>
</svg>$svg$,
  $json$["Tenant A network (isolated)", "Tenant B network (isolated)", "No path between them"]$json$::jsonb
)
ON CONFLICT (lab_id) DO UPDATE SET
  svg_small = EXCLUDED.svg_small,
  svg_large = EXCLUDED.svg_large,
  legend    = EXCLUDED.legend;
