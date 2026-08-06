-- Revert 059: restore original Lab 3 Harden fixture (descriptive, no real output)

-- Step 2
UPDATE lab_phases SET content = replace(
  content,
  $mig$## Step 2 — Re-run the attack

Back on Kali:
```
macof -i eth0 -n 10
```

Within one second, macof transmits a frame with a different source MAC than the one SW1 just learned. The switch catches it immediately — SW1's console lights up:

```
%PM-4-ERR_DISABLE: psecure-violation error detected on Et0/3, putting Et0/3 in err-disable state
%PORT_SECURITY-2-PSECURE_VIOLATION: Security violation occurred, caused by MAC address be06.7029.180e on port Ethernet0/3.
%LINEPROTO-5-UPDOWN: Line protocol on Interface Ethernet0/3, changed state to down
%LINK-3-UPDOWN: Interface Ethernet0/3, changed state to down
```

The port went from forwarding to err-disabled in under a second. The attack ended at the port — the CAM table was never at risk.

Check on SW1:
```
show interfaces ethernet0/3
```

The first line confirms it: `Ethernet0/3 is down, line protocol is down (err-disabled)`.$mig$,
  $mig$## Step 2 — Re-run the attack

Back on Kali:
```
sudo macof -i eth0
```

Within one second, macof transmits a frame with a different source MAC than the one SW1 just learned. The port slams into err-disable instantly.

Check on SW1:
```
show interfaces status err-disabled
show interfaces et0/3
```

`Et0/3` shows `err-disabled`. The flood stopped at the port — the CAM table never filled.$mig$
)
WHERE lab_id = 3 AND phase = 'harden';

-- Step 3
UPDATE lab_phases SET content = replace(
  content,
  $mig$## Step 3 — Verify

```
show port-security interface ethernet0/3
```

```
Port Security              : Enabled
Port Status                : Secure-shutdown
Violation Mode             : Shutdown
Aging Time                 : 0 mins
Aging Type                 : Absolute
SecureStatic Address Aging : Disabled
Maximum MAC Addresses      : 1
Total MAC Addresses        : 1
Configured MAC Addresses   : 0
Sticky MAC Addresses       : 1
Last Source Address:Vlan   : be06.7029.180e:1
Security Violation Count   : 1
```

```
show port-security
```

```
Secure Port  MaxSecureAddr  CurrentAddr  SecurityViolation  Security Action
                (Count)       (Count)          (Count)
---------------------------------------------------------------------------
      Et0/3              1            1                  1         Shutdown
```

The violation count is 1, the action is Shutdown, and the port status is Secure-shutdown. One MAC beyond the limit, and the port slammed the door.$mig$,
  $mig$## Step 3 — Verify

```
show port-security interface et0/3
show port-security
```

You'll see the violation count incremented and the action set to Shutdown.$mig$
)
WHERE lab_id = 3 AND phase = 'harden';
