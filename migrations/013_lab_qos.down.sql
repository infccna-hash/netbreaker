UPDATE lab_phases SET content = 'Content coming soon. Upload via admin panel.'
WHERE lab_id = 35;
DELETE FROM lab_topologies WHERE lab_id = 35;
UPDATE labs SET short_desc = 'Configure QoS classification and priority queuing then stress-test it under contention.'
WHERE id = 35;
