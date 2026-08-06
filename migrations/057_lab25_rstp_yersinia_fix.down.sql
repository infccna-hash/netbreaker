-- Revert 057: restore original Lab 25 RSTP attack content

UPDATE lab_phases SET content = replace(
  content,
  $mig$<b>Attack 1 — Forge a superior BPDU (root hijack):</b> launch yersinia in interactive mode:

```
yersinia -I
```

Inside the ncurses interface:
- press <b>g</b> → choose <b>STP</b>
- press <b>x</b> → choose <b>4) Claiming Root Role</b>

Yersinia floods a spoofed BPDU every 2 seconds with a Bridge ID whose MAC address is lower than any real switch on the network. Since RSTP still elects by lowest Bridge ID (priority + MAC tiebreaker), your Kali box wins. Press <b>q</b> to quit when done.

Verify: <code>show spanning-tree vlan 1 | include Root</code> — the Root ID now shows a MAC owned by your Kali box.

<b>Attack 2 — TCN flood (downgrade RSTP to 802.1D timers):</b> quit the root-role attack (<b>q</b> in yersinia), then press <b>x</b> again and choose <b>3) sending tcn BPDUs</b>.

Every TCN forces every switch to shorten its MAC address table aging timer from 300s to 15s and cycle through listening→learning→forwarding. Flood them continuously and the network never stabilises — RSTP's sub-second convergence degrades to 802.1D's 50-second crawl.

Verify: <code>show spanning-tree vlan 1 detail | include ieee|Number of topology changes</code> — the counter climbs continuously.

<b>Attack 3 — Max-age manipulation (advanced):</b> yersinia does not expose max-age as a tunable in its attack menu. To experiment with this, craft a custom BPDU in scapy:

```
scapy
>>> pkt = Ether(dst="01:80:c2:00:00:00")/LLC()/STP(rootid=..., bridgeid=..., maxage=40)
>>> sendp(pkt, iface="eth0", loop=1, inter=2)
```

Increasing max-age from 20 to 40 makes switches hold stale topology information twice as long — a real failure takes up to 80 seconds to converge instead of 40. This is included for completeness; the first two attacks are the primary lab objective.$mig$,
  $mig$<b>Attack 1 — BPDU flood with yersinia:</b> <code>yersinia stp -attack 2 -interface eth0</code> floods TCNs, forcing switches into listening/learning. <b>Attack 2 — Forge a superior BPDU:</b> Craft a BPDU with priority 0 making Kali the root: <code>yersinia stp -attack 1</code>. <b>Attack 3 — Max-age manipulation:</b> Send BPDUs with max-age = 40 (default 20). Switches hold stale topology information longer, delaying convergence when a real failure occurs.$mig$
)
WHERE lab_id = 25 AND phase = 'attack';
