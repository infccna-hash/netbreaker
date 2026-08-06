-- Migration 062: Fix Lab 1 DTP callout — down
-- Restore original (incorrect) uBridge diagnosis

SELECT verify_replace(
    'lab_phases',
    'content',
    '<div class="callout iou-note"><strong>⚡ IOU Platform Note:</strong> IOU images (both L2 and L3) do not implement Cisco proprietary protocols like DTP (Dynamic Trunking Protocol). <code>yersinia -I → DTP → enabling trunking</code> sends frames that the IOU switch cannot process — this is an image limitation, not a network issue. The manual trunk method (<code>switchport mode trunk</code>) proves VLAN hopping works — you are learning the mechanism. On physical hardware with a real Kali machine plugged into a real IOS switch, yersinia''s DTP attack negotiates a trunk as described. <code>switchport nonegotiate</code> is still non-negotiable.</div>',
    '<div class="callout iou-note"><strong>⚡ IOU + uBridge Note:</strong> DTP frames from yersinia use SNAP encapsulation (0x2004) which the uBridge tunnel between Docker and IOU does not forward correctly. On this platform, <code>yersinia -I → DTP → enabling trunking</code> sends frames that never reach the switch. The manual trunk method (<code>switchport mode trunk</code>) proves VLAN hopping works — you are learning the mechanism. On physical hardware with a real Kali machine plugged in, yersinia''s DTP attack negotiates a trunk as described. <code>switchport nonegotiate</code> is still non-negotiable.</div>',
    'lab_id = 1 AND phase = ''attack'''
);
