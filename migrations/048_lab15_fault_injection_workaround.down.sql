-- Rollback for 048_lab15_fault_injection_workaround

UPDATE lab_phases SET
  content = $md$



<div class="mission"><span class="tag">◈ MISSION</span><h3>Diagnose misconfigurations and device-level failures</h3><p>Networks fail at the device level in predictable ways: a port left shut down, a host dropped in the wrong VLAN, a port-security violation nobody noticed. Your mission: find and fix four deliberate faults using CLI tools only.</p></div>

<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ Troubleshooting · VLANs · port-security · shutdown</span></div>

## The four faults

Each fault disconnects or misroutes a path between two devices. Your task: find them all.

| Fault | Symptom | Tool |
|---|---|---|
| **Fault 1** — Shutdown port (Et0/0, hub segment) | PC1/PC2 unreachable | `show interfaces status` |
| **Fault 2** — Wrong VLAN (Et0/1, PC3) | PC3 unreachable even though the port is up | `show vlan brief` |
| **Fault 3** — Port-security violation (Et0/2, KALI) | Port is err-disabled | `show interfaces status`, `show errdisable recovery` |
| **Fault 4** — Shutdown port (Et0/3, uplink to R1) | Everything behind SW1 loses its gateway | `show interfaces status` |

## Step 1 — Isolate the faults

From KALI, run a sweep:
```
for ip in 192.168.1.{10,20,30,1}; do echo -n "$ip: "; fping -c 3 $ip 2>&1 | tail -1; done
```

Note which IPs are unreachable — that tells you which side of the topology to check first.

## Step 2 — Diagnose each fault

On SW1:
```
show interfaces status
show vlan brief
show errdisable recovery
```

Look for: an interface listed `disabled` (administratively shut) or `err-disabled`, and PC3's port sitting in the wrong VLAN in the `show vlan brief` output.

<div class="callout tip"><p>Port-security violations are one of the most common real triggers for err-disable in production — a port learns more MACs than its configured maximum (or the "wrong" MAC on a sticky port) and shuts itself down rather than fail open. That's not a hardware fault, it's the switch doing exactly what it was told.</p></div>

## Step 3 — Fix each fault

Fault 1 (Et0/0 shut down):
```
configure terminal
interface Et0/0
 no shutdown
end
```

Fault 2 (PC3 in the wrong VLAN):
```
configure terminal
interface Et0/1
 switchport access vlan 1
end
```

Fault 3 (Et0/2 err-disabled from port-security):

First, look at *why* before you clear it — don't just bounce the port blind:
```
show port-security interface Et0/2
show port-security
```
This shows you the violation count, the secure MAC(s) already learned, and the configured action (Shutdown). That's the evidence a real troubleshooter would check before touching anything — clearing an err-disabled port without reading this first means you never actually confirmed what tripped it.

Now clear it:
```
configure terminal
interface Et0/2
 shutdown
 no shutdown
end
```

Fault 4 (Et0/3 shut down):
```
configure terminal
interface Et0/3
 no shutdown
end
```

## Step 4 — Verify

Re-run the ping sweep. All IPs should respond.
```
show interfaces status
show vlan brief
```

Confirm every port is `connected`, PC3 is back in VLAN 1, and nothing is `err-disabled`.

<div class="achievement"><span class="medal">🔧</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Device Doctor — you diagnosed and fixed four device-level faults</span></span></div>



$md$
WHERE lab_id = 15 AND phase = 'attack';
