# Topogen Audit — Generated vs Baseline

Node-set comparison per lab. Generated node set comes from the Go topology struct (source of truth); baseline node set is what the old hand-authored SVG actually drew.

| Lab | Gen nodes | Baseline drew | Missing in baseline | Extra in baseline | Notes |
|---|---|---|---|---|---|
| 1 | KALI, PC1, R1, SRV1, SW1, SW2 | KALI, PC1, R1, SRV1, SW1, SW2 | — | — | baseline has port labels (fa0/3) |
| 2 | KALI, PC1, SW1, SW2, SW3 | KALI, PC1, SW1, SW2, SW3 | — | — | baseline has port labels (et0/0,et0/1,et0/2) |
| 3 | KALI, PC1, PC2, SW1 | KALI, PC1, PC2, SW1 | — | — | baseline has port labels (et0/1,et0/2,et0/3) |
| 4 | KALI, R1, R2, SW1 | KALI, R1, R2, SW1 | — | — |  |
| 5 | KALI, R1, R2, SW1 | KALI, R1, R2, SW1 | — | — | baseline has port labels (e0) |
| 6 | KALI, R1, SERVER, SW1 | KALI, R1, SERVER, SW1 | — | — | baseline has port labels (et0/0,et0/1) |
| 7 | KALI, R1, SW1 | KALI, R1, SW1 | — | — |  |
| 8 | KALI, PC1, R1, SW1 | KALI, PC1, R1, SW1 | — | — | baseline has port labels (e0) |
| 9 | KALI, PC1, PC2, R1, R2, SW1, SW2 | KALI, PC1, PC2, R1, R2 | SW1, SW2 | — | auto-layout will INSERT |
| 10 | KALI, PC-A, PC-B, R1, SW1 | KALI, PC-A, PC-B, R1, SW1 | — | — | baseline has port labels (e0) |
| 11 | KALI, R1, SW1 | KALI, R1 | SW1 | — | auto-layout will INSERT |
| 12 | KALI, PC1, PC2, R1, SW1 | KALI, PC1, PC2, R1, SW1 | — | — |  |
| 13 | AP1, KALI, PC1, R1, SW1 | AP1, KALI, PC1, SW1 | R1 | — | auto-layout will INSERT |
| 14 | KALI, PC1, PC2, R1, SW1 | KALI, PC1, PC2, R1, SW1 | — | — | baseline has port labels (gi0/3) |
| 15 | FW1, H1, KALI, KALI2, PC1, PC2, PC3, R1, SW1 | FW1, H1, KALI, KALI2, PC1, PC2, PC3, R1, SW1 | — | — | baseline has port labels (et0/0,et0/1,et0/2,et0/3,et0/4) |
| 16 | KALI, PC1, PC2, R1, SW1, SW2 | KALI, PC1, PC2, R1, SW1, SW2 | — | — | baseline has port labels (et0/0,et0/2) |
| 17 | KALI, PC1, PC2, R1, SW1 | KALI, PC1, PC2, R1, SW1 | — | — |  |
| 18 | KALI, PC1, R1, SW1 | KALI, PC1, R1, SW1 | — | — |  |
| 19 | KALI, PC1, PC2, PC3, R1, R2, SW1 | KALI, PC1, PC2, PC3, R1 | R2, SW1 | — | auto-layout will INSERT |
| 20 | KALI, PC1, R1, SW1 | KALI, PC1, R1, SW1 | — | — | baseline has port labels (gi0/0,gi0/1,gi0/2,gi0/24) |
| 21 | KALI, PC1, PC2, PC3, R1, R2, R3 | KALI, R1, R2, R3 | PC1, PC2, PC3 | — | auto-layout will INSERT |
| 24 | KALI, PC1, SW1, SW2 | KALI, PC1, SW1, SW2 | — | — |  |
| 25 | KALI, PC1, PC2, SW1, SW2, SW3 | KALI, PC1, PC2, SW1, SW2, SW3 | — | — | baseline has port labels (gi0/3) |
| 26 | KALI, PC1, SW1, SW2 | KALI, PC1, SW1, SW2 | — | — | baseline has port labels (gi0/23,gi0/24) |
| 27 | KALI, PC1, PC2, R1, R2, R3, SW1 | KALI, R1, R2, R3 | PC1, PC2, SW1 | — | auto-layout will INSERT |
| 28 | KALI, PC1, PC2, R1, R2, SW1 | KALI, PC1, R1 | PC2, R2, SW1 | — | auto-layout will INSERT |
| 29 | KALI, PC1, PC2, R1, R2, SW1 | KALI, PC1, PC2, R1 | R2, SW1 | — | auto-layout will INSERT |
| 31 | KALI, PC1, R1, R2, SW1 | KALI, R1, SW1 | PC1, R2 | — | auto-layout will INSERT |
| 32 | KALI, PC1, R1, SW1 | KALI, SW1 | PC1, R1 | — | auto-layout will INSERT |
| 33 | KALI, PC1, R1, SW1 | KALI, R1 | PC1, SW1 | — | auto-layout will INSERT |
| 34 | KALI, R1, SW1 | KALI, R1 | SW1 | — | auto-layout will INSERT |
| 35 | KALI, PC1, R1, R2, SW1 | KALI, PC1, R1 | R2, SW1 | — | auto-layout will INSERT |
| 36 | KALI, PC1, PC2, SW1 | KALI, PC1, PC2, SW1 | — | — | baseline has port labels (fa0/1) |
| 37 | KALI, PC1, R1, SW1 | KALI, PC1, R1, SW1 | — | — | baseline has port labels (e0) |
| 38 | KALI, PC-A, R1, SW1 | KALI, PC-A, R1, SW1 | — | — | baseline has port labels (e0) |
| 39 | KALI, PC1, PC2, PC3, R1, R2, R3, SW1, SW2 | PC1, SW1, SW2 | KALI, PC2, PC3, R1, R2, R3 | — | auto-layout will INSERT |
| 43 | KALI, R1, SW1 | KALI, R1 | SW1 | — | auto-layout will INSERT |
| 44 | KALI, R1, SW1 | KALI, R1 | SW1 | — | auto-layout will INSERT |
| 45 | KALI, R1, SW1 | KALI, R1 | SW1 | — | auto-layout will INSERT |
| 46 | KALI, PC-A, PC-B, SW1 | KALI, PC-A, PC-B, SW1 | — | — | baseline has port labels (e0) |

**Labs with drift: 17** (missing/extra nodes the generator will fix).
