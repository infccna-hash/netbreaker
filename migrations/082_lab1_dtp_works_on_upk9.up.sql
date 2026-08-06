-- 082_lab1_dtp_works_on_upk9.up.sql
-- Lab 1 DTP callout update: the platform image changed from
-- i86bi-linux-l2-adventerprisek9-15.1a (does NOT process yersinia DTP)
-- to i86bi-linux-l2-upk9-12.2 (DTP-capable, verified in test: yersinia
-- DTP attack → Operational Mode: trunk, dot1q encapsulation).
-- The attack-phase callout telling students DTP "does not work on IOU"
-- is now wrong. Replace it with a short platform note that the 12.2 image
-- supports DTP, so the yersinia attack is real on this platform.

UPDATE lab_phases
SET content = replace(content,
  '<div class="callout tip"><p><strong>💥 That''s the moment.</strong>',
  '<div class="callout iou-note"><strong>⚡ IOU Platform Note:</strong> This lab uses the <code>i86bi-linux-l2-upk9-12.2</code> image, which implements DTP. yersinia''s DTP attack (enabling trunking) is REAL here — SW1''s <code>dynamic auto</code> port accepts the negotiated trunk. On the newer 15.1a IOU image this specific attack was silently ignored (image limitation, not a network issue); the 12.2 image restores the behaviour you would see on physical IOS switches.</div><div class="callout tip"><p><strong>💥 That''s the moment.</strong>'
)
WHERE lab_id = 1 AND phase = 'attack';
