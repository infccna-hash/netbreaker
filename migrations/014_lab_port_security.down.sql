UPDATE lab_phases SET content = 'Content coming soon. Upload via admin panel.'
WHERE lab_id = 36;
DELETE FROM lab_topologies WHERE lab_id = 36;
UPDATE labs SET short_desc = 'Lock a port to one MAC address then flood past the limit before it shuts itself down.'
WHERE id = 36;
