UPDATE lab_phases SET content = 'Content coming soon. Upload via admin panel.'
WHERE lab_id = 2;
DELETE FROM lab_topologies WHERE lab_id = 2;
UPDATE labs SET short_desc = 'Deploy STP across 4 switches and perform a root bridge hijack with Yersinia.'
WHERE id = 2;
