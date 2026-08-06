-- 078_lab3_cam_overflow_callout.up.sql
-- Add IOU limitation callout at top of Lab 3 Attack phase.
-- IOU L2 simulates 183M+ CAM entries — macof will never actually overflow
-- the table. The commands and port-security defense are real; only the 
-- visual overflow is not reproducible on this simulation platform.
-- On real hardware with 8K–32K CAM limits, the attack fills the table in
-- under a minute. The student learns the mechanism even if they don't see
-- the CAM hit its limit live.

UPDATE lab_phases
SET content = replace(content,
  '<p><code>macof</code> ships with Kali''s dsniff suite.',
  '<div class="callout iou-note"><strong>⚡ IOU Note:</strong> IOU L2 simulates 183M+ CAM entries — on this platform, macof will flood the wire but the table won''t actually overflow live. The commands you type and the defense you build are 100% real. On physical switches with 8K–32K CAM limits, this attack fills the table in under a minute. You''re here to learn the mechanism — and the port-security response is non-negotiable.</div><p><code>macof</code> ships with Kali''s dsniff suite.'
)
WHERE lab_id = 3 AND phase = 'attack';
