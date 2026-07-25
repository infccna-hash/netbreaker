-- 029_lab20_legend_fix.up.sql
-- Migration 028 rewrote lab 20 to its real 4-node topology (SW1, PC1, R1, KALI)
-- and dropped the phantom PC2 "VLAN 20 client". The role legend in
-- lab_topologies.legend (seeded in 010) still listed 5 roles including that
-- phantom, so the live-lab UI showed a stray "VLAN 20 client" chip. Kali is now
-- both the VLAN 20 host and the attacker, so fold that into its role.
BEGIN;
UPDATE lab_topologies
SET legend = '["Layer-2 switch", "VLAN 10 client", "Router", "Attacker (VLAN 20 · interface attacks)"]'::jsonb
WHERE lab_id = 20;
COMMIT;
