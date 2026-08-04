import { useEffect, useRef } from 'react';
import { Terminal } from 'xterm';
import { FitAddon } from 'xterm-addon-fit';
import 'xterm/css/xterm.css';
import { getToken } from '../lib/api.js';

export default function ConsolePanel({ sessionId, nodeName, active }) {
  const containerRef = useRef(null);
  const fitAddonRef = useRef(null);

  useEffect(() => {
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
  }, [sessionId, nodeName]);

  // The panel may be mounted while hidden (display:none), so its first
  // fit() can measure a zero-size container. Re-fit whenever it becomes
  // the visible/active tab.
  useEffect(() => {
    if (active && fitAddonRef.current) {
      const id = requestAnimationFrame(() => fitAddonRef.current.fit());
      return () => cancelAnimationFrame(id);
    }
  }, [active]);

  return <div ref={containerRef} style={{ height: '100%', width: '100%' }} />;
}
