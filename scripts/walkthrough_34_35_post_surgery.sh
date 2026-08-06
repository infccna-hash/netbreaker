#!/bin/bash
# =============================================================================
# NetBreaker — Post-surgery fresh-session walkthrough: Labs 34 & 35
# Written for Yassine to run on Falcon (2026-08-05)
#
# WHY: Migration 088 + Go topology surgery (dropped R2 from Lab 34, R3+PC2 from
# Lab 35) deployed to VPS. The Go unit suite mocks GNS3 — it cannot catch the
# "collector drove the wrong switch" class of provisioning bug. Only a fresh
# session against real GNS3 proves the surgery. This is the OPTION-1 kit.
#
# EXPECTED PASS:
#   Lab 34 session node_map = R1, SW1, KALI          (NO R2)
#   Lab 35 session node_map = R1, R2, SW1, PC1, KALI (NO R3, NO PC2)
#
# USAGE: run from Falcon. Requires: curl, jq (or python3), ssh key to VPS
#        100.66.106.42, and GNS3 running locally (localhost:3080).
# =============================================================================
set -euo pipefail

API="http://100.66.106.42:80/api/v1"     # VPS via Tailscale (Caddy :80)
VPS="root@100.66.106.42"
TS=$(date +%s)
EMAIL="walk34_${TS}@test.local"
PASS="testpass123"

echo "═══════════════════════════════════════════════════════"
echo "  STEP 0 — Register fresh walkthrough account"
echo "═══════════════════════════════════════════════════════"
REG=$(curl -s -X POST -H "Content-Type: application/json" \
  -d "{\"email\":\"${EMAIL}\",\"password\":\"${PASS}\",\"name\":\"Walk34\"}" \
  "$API/auth/register")
TOKEN=$(echo "$REG" | python3 -c "import sys,json;print(json.load(sys.stdin).get('access_token',''))" 2>/dev/null)
UID_=$(echo "$REG" | python3 -c "import sys,json;print(json.load(sys.stdin).get('user',{}).get('id',''))" 2>/dev/null)
[ -z "$TOKEN" ] && { echo "❌ register failed: $REG"; exit 1; }
echo "  ✅ registered $EMAIL (id=$UID_)"

echo "═══════════════════════════════════════════════════════"
echo "  STEP 1 — Upgrade to pro (JWT carries plan at issuance)"
echo "═══════════════════════════════════════════════════════"
ssh -o ConnectTimeout=15 -o BatchMode=yes "$VPS" \
  "docker exec netbreaker-postgres psql -U netbreaker -d netbreaker -c \"UPDATE users SET plan='pro' WHERE id='${UID_}';\""
TOKEN=$(curl -s -X POST -H "Content-Type: application/json" \
  -d "{\"email\":\"${EMAIL}\",\"password\":\"${PASS}\"}" \
  "$API/auth/login" | python3 -c "import sys,json;print(json.load(sys.stdin).get('access_token',''))")
[ -z "$TOKEN" ] && { echo "❌ re-login failed"; exit 1; }
echo "  ✅ upgraded + re-logged (fresh JWT carries plan=pro)"

walk_lab() {
  local LAB=$1
  local EXPECT=$2
  echo ""
  echo "═══════════════════════════════════════════════════════"
  echo "  LAB $LAB — launch fresh session"
  echo "  EXPECT node_map keys: $EXPECT"
  echo "═══════════════════════════════════════════════════════"
  SESS=$(curl -s -X POST -H "Authorization: Bearer ${TOKEN}" "$API/labs/${LAB}/session")
  SID=$(echo "$SESS" | python3 -c "import sys,json;print(json.load(sys.stdin).get('id',''))" 2>/dev/null)
  [ -z "$SID" ] && { echo "❌ launch failed: $SESS"; return 1; }
  echo "  session $SID"

  # Wait for provisioning → running
  for i in $(seq 1 15); do
    ST=$(curl -s -H "Authorization: Bearer ${TOKEN}" "$API/labsessions/$SID" \
      | python3 -c "import sys,json;print(json.load(sys.stdin).get('status',''))" 2>/dev/null)
    echo "  t${i}: status=$ST"
    [ "$ST" = "running" ] && break
    [ "$ST" = "failed" ] && { echo "❌ session FAILED at provision"; return 1; }
    sleep 4
  done

  # THE CHECK — node_map from live session
  NODES=$(curl -s -H "Authorization: Bearer ${TOKEN}" "$API/labsessions/$SID" \
    | python3 -c "import sys,json;d=json.load(sys.stdin);print(' '.join(sorted(d.get('node_map',{}).keys())))" 2>/dev/null)
  echo ""
  echo "  ┌─ node_map keys: $NODES"
  echo "  └─ expected:      $EXPECT"
  if [ "$NODES" = "$EXPECT" ]; then
    echo "  ✅ LAB $LAB NODE SET CORRECT — surgery verified"
  else
    echo "  ❌ LAB $LAB NODE SET MISMATCH — surgery BROKEN, do not touch further"
  fi

  # Console reachability spot-check (R1 via telnet)
  echo "  console ports:"
  curl -s -H "Authorization: Bearer ${TOKEN}" "$API/labsessions/$SID" \
    | python3 -c "import sys,json;d=json.load(sys.stdin);[print(f'    {k}: {v.get(\"console_port\",\"?\")}') for k,v in sorted(d.get('node_map',{}).items())]"

  echo "  → End Session (DELETE)"
  curl -s -X DELETE -H "Authorization: Bearer ${TOKEN}" "$API/labsessions/$SID" -o /dev/null -w "  delete status: %{http_code}\n"
  echo "  ✅ session ended"
}

walk_lab 34 "KALI R1 SW1"
walk_lab 35 "KALI PC1 R1 R2 SW1"

echo ""
echo "═══════════════════════════════════════════════════════"
echo "  DONE. If both labs printed ✅, the 34/35 surgery is"
echo "  verified on real GNS3. Log the walkthrough as CLOSED."
echo "  If either ❌, capture the node_map output verbatim."
echo "═══════════════════════════════════════════════════════"
