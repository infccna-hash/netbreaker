#!/usr/bin/env python3
"""Create KALI + SW1 nodes in the tmux-verify-stp project."""
import json, urllib.request, urllib.error

GNS3 = "http://admin:TogvSQhAOtSkVlWEqFvDs3xBSsBybEKl8ZA5Zr1qwEghlYSoF9Ma59FyvLsLmcAj@localhost:3080"
PROJ_ID = "852ccb0b-564c-4ce6-8efd-c732e7ede519"
KALI_TID = "91f428af-45a5-4d8e-ac34-c1de781ea85f"
SW_TID = "57296a91-9349-43c8-8f0f-d1542e33d438"

def req(method, path, data=None):
    url = f"{GNS3}{path}"
    body = json.dumps(data).encode() if data else None
    r = urllib.request.Request(url, data=body, method=method)
    r.add_header("Content-Type", "application/json")
    try:
        resp = urllib.request.urlopen(r)
        return json.loads(resp.read())
    except urllib.error.HTTPError as e:
        return {"error": e.code, "body": e.read().decode()}

# Create KALI
print("Creating KALI...")
kali = req("POST", f"/v2/projects/{PROJ_ID}/templates/{KALI_TID}",
           {"x": -200, "y": 0, "name": "KALI"})
kali_id = kali.get("node_id", "")
kali_console = kali.get("console", -1)
print(f"KALI: {kali_id} console={kali_console}")

# Update KALI image
print("Updating KALI image...")
update = req("PUT", f"/v2/projects/{PROJ_ID}/nodes/{kali_id}",
             {"properties": {"image": "netbreaker-kali:2026-08-01-tmux",
                            "adapters": 2, "console_type": "telnet",
                            "console_resolution": "1024x768",
                            "start_command": "bash",
                            "environment": "TERM=xterm-256color"}})
print(f"Image updated: {update.get('properties',{}).get('image','ERR')}")

# Create SW1
print("Creating SW1...")
sw1 = req("POST", f"/v2/projects/{PROJ_ID}/templates/{SW_TID}",
          {"x": 100, "y": 0, "name": "SW1"})
sw1_id = sw1.get("node_id", "")
sw1_console = sw1.get("console", -1)
print(f"SW1: {sw1_id} console={sw1_console}")

# Connect KALI Et0 <-> SW1 Et0/0
print("Connecting KALI Et0 -> SW1 Et0/0...")
link = req("POST", f"/v2/projects/{PROJ_ID}/links",
           {"nodes": [{"node_id": kali_id, "adapter_number": 0, "port_number": 0},
                     {"node_id": sw1_id, "adapter_number": 0, "port_number": 0}]})
print(f"Link: {link.get('link_id','ERR')}")

# Summary
print(f"\n=== SUMMARY ===")
print(f"PROJ_ID={PROJ_ID}")
print(f"KALI: node_id={kali_id} console={kali_console}")
print(f"SW1:  node_id={sw1_id} console={sw1_console}")
