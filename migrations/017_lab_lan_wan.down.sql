UPDATE lab_phases SET content = 'Content coming soon. Upload via admin panel.'
WHERE lab_id = 39;
DELETE FROM lab_topologies WHERE lab_id = 39;
UPDATE labs SET short_desc = 'Redesign a flat, collapsed network as a proper three-tier architecture under real constraints.'
WHERE id = 39;
