-- Migration 092: Lab 15 Fault 3 — port-security trap → BPDU-guard trap
--
-- Why: IOU 15.1a accepts port-security config but never fires the
-- violation (Security Violation Count stays 0; verified twice in full
-- walkthroughs). 12.2 upk9 rejects the command outright. BPDU guard
-- DOES fire on 15.1a (verified probe: %SPANTREE-2-BLOCK_BPDUGUARD +
-- %PM-4-ERR_DISABLE), and KALI can inject the trigger via yersinia
-- (verified probe: yersinia stp -attack 1 → port err-disabled).
--
-- Text + lab15_scenario.go + lab15_scenario_test.go ship together in
-- the SAME commit (no divergence window).

UPDATE lab_phases SET content = verify_replace(content,
  $md$interface Et0/2
 switchport port-security
 switchport port-security maximum 1
 switchport port-security violation shutdown
 switchport port-security mac-address 0000.0000.0001$md$,
  $md$interface Et0/2
 spanning-tree portfast
 spanning-tree bpduguard enable$md$)
WHERE lab_id = 15 AND phase = 'attack';

UPDATE lab_phases SET content = verify_replace(content,
  $md$That port-security command on Et0/2 doesn't fake an err-disabled state — it sets a real trap. You've told the switch the only MAC allowed on that port is `0000.0000.0001`, which isn't KALI's real MAC. The next real frame KALI sends trips a genuine security violation. Go make that happen:$md$,
  $md$That bpduguard command on Et0/2 doesn't fake an err-disabled state — it sets a real trap. The switch will err-disable any port in portfast mode the moment it receives an STP BPDU while bpduguard is enabled. Yersinia injects exactly that. Go make that happen:$md$)
WHERE lab_id = 15 AND phase = 'attack';

UPDATE lab_phases SET content = verify_replace(content,
  $md$ping 192.168.1.1 -c 1$md$,
  $md$yersinia stp -attack 1 -interface eth0$md$)
WHERE lab_id = 15 AND phase = 'attack';

UPDATE lab_phases SET content = verify_replace(content,
  $md$Et0/2 is now actually err-disabled — not simulated, not scripted, the switch really did detect and react to a real (if artificially set up) violation.$md$,
  $md$Et0/2 is now actually err-disabled — not simulated, not scripted, the switch really did detect and react to a real (if artificially set up) BPDU-guard violation.$md$)
WHERE lab_id = 15 AND phase = 'attack';

UPDATE lab_phases SET content = verify_replace(content,
  $md$| **Fault 3** — Port-security violation (Et0/2, KALI) | Port is err-disabled |$md$,
  $md$| **Fault 3** — BPDU guard violation (Et0/2, KALI) | Port is err-disabled (STP BPDU on a portfast+bpduguard port) |$md$)
WHERE lab_id = 15 AND phase = 'attack';

UPDATE lab_phases SET content = verify_replace(content,
  $md$a port left shut down, a host dropped in the wrong VLAN, a port-security violation nobody noticed.$md$,
  $md$a port left shut down, a host dropped in the wrong VLAN, a BPDU-guard violation nobody noticed.$md$)
WHERE lab_id = 15 AND phase = 'attack';

UPDATE lab_phases SET content = verify_replace(content,
  $md$⬡ Troubleshooting · VLANs · port-security · shutdown$md$,
  $md$⬡ Troubleshooting · VLANs · BPDU guard · shutdown$md$)
WHERE lab_id = 15 AND phase = 'attack';

UPDATE lab_phases SET content = verify_replace(content,
  $md$Fault 3 (Et0/2 err-disabled from port-security):

First, look at *why* before you clear it — don't just bounce the port blind:
```
show port-security interface Et0/2
show port-security
```
This shows you the violation count, the secure MAC(s) already learned, and the configured action (Shutdown).$md$,
  $md$Fault 3 (Et0/2 err-disabled from BPDU guard):

First, look at *why* before you clear it — don't just bounce the port blind:
```
show logging | include BPDUGUARD
show errdisable recovery
```
The syslog tells you exactly what tripped it (SPANTREE-2-BLOCK_BPDUGUARD: received BPDU with guard enabled), and `show errdisable recovery` shows the port and the recovery timer.$md$)
WHERE lab_id = 15 AND phase = 'attack';

UPDATE lab_phases SET content = verify_replace(content,
  $md$Port-security violations are one of the most common real triggers for err-disable in production — a port learns more MACs than its configured maximum (or the "wrong" MAC on a sticky port) and shuts itself down rather than fail open.$md$,
  $md$BPDU-guard violations are a real trigger for err-disable: a portfast port that should never see STP traffic receives a BPDU — from a rogue switch, a misconfigured uplink, or an attack tool like yersinia — and shuts itself down rather than risk a loop.$md$)
WHERE lab_id = 15 AND phase = 'attack';
