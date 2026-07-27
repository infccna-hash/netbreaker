# NetBreaker Kali — custom lab attacker image
# Base: kalilinux/kali-last-release (OffSec official)
# Reconstructed from docker history of canonical build ce55107f74c3 (Falcon, 2026-07-25).

FROM kalilinux/kali-last-release:latest

# Layer 1 — light networking tools (shared with gns3/kalilinux)
RUN apt-get update && apt-get install -y --no-install-recommends \
    tcpdump net-tools iputils-ping traceroute dnsutils \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Layer 2 — pentest toolchain
# tshark needs DEBIAN_FRONTEND=noninteractive to skip wireshark-common debconf prompt
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y tshark \
    && apt-get install -y --no-install-recommends \
        metasploit-framework \
        nmap \
        hydra \
        sqlmap \
        telnet \
        openssh-client \
        dnsutils \
        yersinia \
        ettercap-text-only \
        cisco-global-exploiter \
        cisco-auditing-tool \
        snmp \
        dsniff \
        dnschef \
        fping \
        hping3 \
        python3-scapy \
        frr \
        dnsmasq \
    && rm -rf /var/lib/apt/lists/*

CMD ["/bin/sh", "-c", "/bin/bash"]
