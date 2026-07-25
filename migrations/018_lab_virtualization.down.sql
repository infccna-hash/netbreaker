UPDATE lab_phases SET content = 'Content coming soon. Upload via admin panel.'
WHERE lab_id = 40;
DELETE FROM lab_topologies WHERE lab_id = 40;
UPDATE labs SET short_desc = 'Break container isolation between two tenants who were never supposed to see each other.'
WHERE id = 40;
