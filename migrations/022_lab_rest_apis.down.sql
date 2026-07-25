UPDATE lab_phases SET content = 'Content coming soon. Upload via admin panel.'
WHERE lab_id = 44;
UPDATE labs SET short_desc = 'Call an unauthenticated REST API endpoint and pull configuration data it should never have exposed.'
WHERE id = 44;
