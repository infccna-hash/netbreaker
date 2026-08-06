-- 073_lab08_rename_pca_to_pc1.up.sql
-- Fix SVG: rename PC-A → PC1 (match Go topology node name)

UPDATE lab_topologies
SET svg_large = replace(svg_large,
  '<text x="160" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC-A</text>',
  '<text x="160" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC1</text>'
)
WHERE lab_id = 8;
