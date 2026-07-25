UPDATE lab_phases SET content = 'Content coming soon. Upload via admin panel.'
WHERE lab_id = 38;
DELETE FROM lab_topologies WHERE lab_id = 38;
UPDATE labs SET short_desc = 'Spoof ARP to man-in-the-middle a host then get DAI to drop every forged reply on the floor.'
WHERE id = 38;
