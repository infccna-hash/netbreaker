-- Revert Lab 01 back to placeholder content.
UPDATE lab_phases SET content = 'Content coming soon. Upload via admin panel.'
WHERE lab_id = 1;
DELETE FROM lab_topologies WHERE lab_id = 1;
UPDATE labs
SET short_desc = 'Configure 3 VLANs, trunk ports, and router-on-a-stick. Then perform a VLAN hopping attack.'
WHERE id = 1;
