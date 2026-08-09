import { useEffect, useRef } from 'react';
import { Terminal } from 'xterm';
import { FitAddon } from 'xterm-addon-fit';
import 'xterm/css/xterm.css';
import { getToken } from '../lib/api.js';

// Lazy-load noVNC's RFB client only when a VNC console actually mounts.
// The module is a plain ESM singleton; the dynamic import keeps the
// initial bundle small for the common (telnet) case.
let RFB = null;
async function loadRFB() {
  if (RFB) return RFB;
  const mod = await import('@novnc/novnc');
  RFB = mod.default;
  return RFB;
}

export default function ConsolePanel({ sessionId, nodeName, active, nodeInfo }) {
  const containerRef = useRef(null);
  const fitAddonRef = useRef(null);

  const isVNC = nodeInfo?.console_type === 'vnc';

  // ── VNC console: inline noVNC viewer ─────────────────────────
  useEffect(() => {
    if (!isVNC) return;
    let cancelled = false;
    let rfb = null;
    let resizeObserver = null;

    (async () => {
      const RFBClient = await loadRFB();
      if (cancelled || !containerRef.current) return;

      const token = getToken();
      const proto = window.location.protocol === 'https:' ? 'wss' : 'ws';
      const url = `${proto}://${window.location.host}/api/v1/labsessions/${sessionId}/console/${nodeName}/vnc?token=${token}`;

      try {
        rfb = new RFBClient(containerRef.current, url, {
          credentials: { password: '' },
          wsProtocols: ['binary'],
        });
        rfb.scaleViewport = true;
        rfb.resizeSession = false;
        rfb.clipViewport = true;
      } catch (err) {
        if (!cancelled) {
          const el = document.createElement('div');
          el.style.cssText = 'color:#f85149;padding:12px;font-family:monospace;font-size:13px;white-space:pre-wrap;';
          el.textContent = `[VNC failed to start: ${err.message || err}]`;
          containerRef.current?.appendChild(el);
        }
        return;
      }

      rfb.addEventListener('connect', () => {
        if (!cancelled) rfb.focus();
      });
      rfb.addEventListener('disconnect', (e) => {
        if (!cancelled && !rfb?._destroyed) {
          const el = document.createElement('div');
          el.style.cssText = 'color:#f85149;padding:12px;font-family:monospace;font-size:13px;white-space:pre-wrap;';
          el.textContent = `[VNC disconnected${e?.detail?.clean ? '' : ' — refresh this tab to reconnect'}]`;
          containerRef.current?.appendChild(el);
        }
      });

      // Keep the VNC canvas sized to its container (the console tab can
      // be display:none when inactive, so observe actual size changes).
      if (typeof ResizeObserver !== 'undefined' && containerRef.current) {
        resizeObserver = new ResizeObserver(() => {
          try { rfb?.resize(); } catch (_) {}
        });
        resizeObserver.observe(containerRef.current);
      }
    })();

    return () => {
      cancelled = true;
      resizeObserver?.disconnect();
      if (rfb) {
        try { rfb.disconnect(); } catch (_) {}
        rfb = null;
      }
      if (containerRef.current) containerRef.current.innerHTML = '';
    };
  }, [isVNC, sessionId, nodeName]);

  // ── Telnet console: xterm.js + websocket bridge ──────────────
  useEffect(() => {
    if (isVNC) return;
    const term = new Terminal({
      cursorBlink: true,
      fontSize: 13,
      fontFamily: 'Menlo, Consolas, monospace',
      theme: { background: '#0d1117' },
    });
    const fitAddon = new FitAddon();
    fitAddonRef.current = fitAddon;
    term.loadAddon(fitAddon);
    term.open(containerRef.current);
    fitAddon.fit();

    const token = getToken();
    const proto = window.location.protocol === 'https:' ? 'wss' : 'ws';
    const ws = new WebSocket(
      `${proto}://${window.location.host}/api/v1/labsessions/${sessionId}/console/${nodeName}?token=${token}`
    );
    ws.binaryType = 'arraybuffer';

    ws.onmessage = (event) => {
      const data = new Uint8Array(event.data);
      term.write(data);
    };
    ws.onclose = () => term.write(
      '\r\n\x1b[31m[disconnected — refresh this tab to reconnect]\x1b[0m\r\n'
    );

    term.onData((data) => {
      if (ws.readyState === WebSocket.OPEN) ws.send(data);
    });

    const handleResize = () => fitAddon.fit();
    window.addEventListener('resize', handleResize);

    return () => {
      window.removeEventListener('resize', handleResize);
      ws.close();
      term.dispose();
    };
  }, [isVNC, sessionId, nodeName]);

  // The panel may be mounted while hidden (display:none), so its first
  // fit() can measure a zero-size container. Re-fit whenever it becomes
  // the visible/active tab.
  useEffect(() => {
    if (active && fitAddonRef.current && !isVNC) {
      const id = requestAnimationFrame(() => fitAddonRef.current.fit());
      return () => cancelAnimationFrame(id);
    }
  }, [active, isVNC]);

  return <div ref={containerRef} style={{ height: '100%', width: '100%' }} />;
}
