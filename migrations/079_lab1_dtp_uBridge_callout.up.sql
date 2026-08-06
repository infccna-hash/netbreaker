-- 079_lab1_dtp_uBridge_callout.up.sql
-- Add IOU+uBridge limitation callout at top of Lab 1 Attack phase.
-- DTP frames (SNAP 0x2004) from yersinia in the Docker container traverse
-- the uBridge pipe but are not delivered to the IOU switch. The manual
-- trunk method proves VLAN hopping — the mechanism is sound.
-- On physical hardware with a real Kali machine plugged into a switch port,
-- yersinia's DTP attack works as documented.

UPDATE lab_phases
SET content = replace(content,
  '<p>Your Kali box is plugged into a <strong>user</strong> port.',
  '<div class=\"callout iou-note\"><strong>⚡ IOU + uBridge Note:</strong> DTP frames from yersinia use SNAP encapsulation (0x2004) which the uBridge tunnel between Docker and IOU does not forward correctly. On this platform, <code>yersinia -I → DTP → enabling trunking</code> sends frames that never reach the switch. The manual trunk method (<code>switchport mode trunk</code>) proves VLAN hopping works — you are learning the mechanism. On physical hardware with a real Kali machine plugged in, yersinia''s DTP attack negotiates a trunk as described. <code>switchport nonegotiate</code> is still non-negotiable.</div><p>Your Kali box is plugged into a <strong>user</strong> port.'
)
WHERE lab_id = 1 AND phase = 'attack';
