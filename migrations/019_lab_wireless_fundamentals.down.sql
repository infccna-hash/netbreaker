UPDATE lab_phases SET content = 'Content coming soon. Upload via admin panel.'
WHERE lab_id = 41;
DELETE FROM lab_topologies WHERE lab_id = 41;
UPDATE labs SET short_desc = 'Read 802.11 frame types straight out of a live capture and identify the client association handshake.'
WHERE id = 41;
