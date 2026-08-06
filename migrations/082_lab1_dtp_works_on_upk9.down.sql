-- 082_lab1_dtp_works_on_upk9.down.sql
-- Revert: remove the DTP-works callout from Lab 1 attack phase.

UPDATE lab_phases
SET content = replace(content,
  '<div class="callout iou-note"><strong>⚡ IOU Platform Note:</strong> This lab uses the <code>i86bi-linux-l2-upk9-12.2</code> image, which implements DTP. yersinia''s DTP attack (enabling trunking) is REAL here — SW1''s <code>dynamic auto</code> port accepts the negotiated trunk. On the newer 15.1a IOU image this specific attack was silently ignored (image limitation, not a network issue); the 12.2 image restores the behaviour you would see on physical IOS switches.</div>',
  ''
)
WHERE lab_id = 1 AND phase = 'attack';
