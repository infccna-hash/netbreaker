UPDATE lab_phases SET content = 'Content coming soon. Upload via admin panel.'
WHERE lab_id = 34;
DELETE FROM lab_topologies WHERE lab_id = 34;
UPDATE labs SET short_desc = 'Back up router configs via TFTP and FTP then exfiltrate the file and crack the credentials.'
WHERE id = 34;
