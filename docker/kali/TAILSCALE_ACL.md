# Tailscale ACL for NetBreaker Docker Registry
#
# Apply in the Tailscale admin console:
#   https://login.tailscale.com/admin/acls/file/<your-tailnet>
#
# Restricts port 5000 (registry) to Falcon + build host only.
# Defense-in-depth on top of the Tailscale-IP bind already applied on VPS.

# ACL snippet — add this to the "acls" array:

```json
{
    "action": "accept",
    "src":    ["falcon", "contabo-vps"],
    "dst":    ["contabo-vps:5000"],
    "proto":  "tcp"
}
```

# Hostnames: use the exact names from your Machines list.
# "falcon" = Falcon workstation
# "contabo-vps" = the VPS running the registry
#
# Verify after applying:
#   From Falcon:       curl -s http://100.102.123.67:5000/v2/_catalog  → works
#   From another node: timeout 2 curl -s http://100.102.123.67:5000/v2/_catalog → blocked
