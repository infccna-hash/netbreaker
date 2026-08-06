-- Revert 056: restore original BOSS FIGHT content (yersinia -G, Conf/TCN BPDU Flooding)

-- ═══════════════════ ATTACK — BOSS FIGHT ═══════════════════
UPDATE lab_phases SET content = replace(
  content,
  $mig$☠ BOSS FIGHT — optional, +300 XP</span>
<h3>Topology Change flood: force constant recalculation</h3>
<p>Winning the election once is loud but stable. The sneakier move is repeatedly triggering <strong>Topology Change Notifications (TCNs)</strong> — every recalculation flushes every switch's MAC address table early, forcing a flood-and-relearn cycle on every port in the network. Do this continuously and you get a low-grade, hard-to-diagnose slowdown across the whole LAN, not an obvious outage.</p>
</div>

Launch yersinia again (skip the <code>stty</code> step if your terminal is still 30×100):

```
yersinia -I
```

Inside the ncurses interface:
- press **g** → choose **STP**
- press **x** → choose **3) sending tcn BPDUs** (the DoS version — floods TCNs continuously)

Every TCN forces every switch to shorten its MAC address table aging timer from 300 seconds to 15 seconds. Flood them continuously and the switches never stop relearning — MAC tables stay near-empty, traffic gets flooded to all ports, and the whole LAN degrades without a single link going down.

Watch a switch's MAC table get wiped and relearn on a timer that shouldn't exist:

```
show mac address-table count
! run it twice a few seconds apart while the flood runs — count resets periodically
```

<div class="achievement">
<span class="medal">🌪️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Chaos Agent — nothing crashed, everything just quietly got worse</span></span>
</div>$mig$,
  $mig$☠ BOSS FIGHT — optional, +300 XP</span>
<h3>Topology Change flood: force constant recalculation</h3>
<p>Winning the election once is loud but stable. The sneakier move is repeatedly triggering <strong>Topology Change Notifications (TCNs)</strong> — every recalculation flushes every switch's MAC address table early, forcing a flood-and-relearn cycle on every port in the network. Do this continuously and you get a low-grade, hard-to-diagnose slowdown across the whole LAN, not an obvious outage.</p>
</div>

```
sudo yersinia -G
# Launch attack → STP → "Conf/TCN BPDU Flooding"
```

Watch a switch's MAC table get wiped and relearn on a timer that shouldn't exist:

```
show mac address-table count
! run it twice a few seconds apart while the flood runs — count resets periodically
```

<div class="achievement">
<span class="medal">🌪️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Chaos Agent — nothing crashed, everything just quietly got worse</span></span>
</div>$mig$
)
WHERE lab_id = 2 AND phase = 'attack';
