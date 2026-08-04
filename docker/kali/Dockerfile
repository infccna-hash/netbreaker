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
        tmux \
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

# Layer 3 — fixrows: fixed oversized PTY for yersinia/tmux (uBridge NAWS workaround)
# fixrows sets a static 40×130 because NAWS is broken end-to-end —
# there is no path for real browser window dimensions to reach the PTY.
COPY fixrows /usr/local/bin/fixrows
RUN chmod +x /usr/local/bin/fixrows \
    && echo '' >> /root/.bashrc \
    && echo '# Fixed oversized PTY for yersinia/tmux (uBridge NAWS workaround)' >> /root/.bashrc \
    && echo 'if [ -t 0 ] && [ -z "${FIXROWS_DONE-}" ]; then' >> /root/.bashrc \
    && echo '    if python3 /usr/local/bin/fixrows; then' >> /root/.bashrc \
    && echo '        echo "[fixrows] applied: $(tput lines)x$(tput cols)"' >> /root/.bashrc \
    && echo '        echo "$(date -Iseconds) [fixrows] applied: $(tput lines)x$(tput cols)" >> /tmp/fixrows.log' >> /root/.bashrc \
    && echo '    else' >> /root/.bashrc \
    && echo '        err=$?' >> /root/.bashrc \
    && echo '        echo "[fixrows] FAILED (exit $err) — check /usr/local/bin/fixrows"' >> /root/.bashrc \
    && echo '        echo "$(date -Iseconds) [fixrows] FAILED (exit $err)" >> /tmp/fixrows.log' >> /root/.bashrc \
    && echo '    fi' >> /root/.bashrc \
    && echo '    export FIXROWS_DONE=1' >> /root/.bashrc \
    && echo 'fi' >> /root/.bashrc

CMD ["/bin/sh", "-c", "/bin/bash"]
