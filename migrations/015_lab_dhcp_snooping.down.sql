UPDATE lab_phases SET content = 'Content coming soon. Upload via admin panel.'
WHERE lab_id = 37;
DELETE FROM lab_topologies WHERE lab_id = 37;
UPDATE labs SET short_desc = 'Deploy a rogue DHCP server then watch DHCP Snooping trust-boundary it into oblivion.'
WHERE id = 37;
