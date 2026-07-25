UPDATE lab_phases SET content = 'Content coming soon. Upload via admin panel.'
WHERE lab_id = 33;
DELETE FROM lab_topologies WHERE lab_id = 33;
UPDATE labs SET short_desc = 'Configure remote syslog logging then flood the collector with spoofed log entries.'
WHERE id = 33;
