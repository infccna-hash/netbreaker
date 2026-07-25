-- 029_lab20_legend_fix.down.sql
BEGIN;
UPDATE lab_topologies
SET legend = '["Layer-2 switch", "VLAN 10 client", "VLAN 20 client", "Router", "Attacker (interface attacks)"]'::jsonb
WHERE lab_id = 20;
COMMIT;
