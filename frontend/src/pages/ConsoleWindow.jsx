import { useEffect, useState, useRef } from "react";
import { useParams } from "react-router-dom";
import { api } from "../lib/api.js";
import ConsolePanel from "../components/ConsolePanel.jsx";

// Standalone console page, meant to be opened via window.open() in its own
// tab (see LabDetail's "Open console" button). It has no app nav/footer —
// just the node tabs and the terminal, full viewport, dark.
//
// All node ConsolePanels stay mounted for the life of this tab; switching
// the active tab only toggles display:none, so websocket/telnet sessions
// never drop on tab switch (same fix as the inline version).
export default function ConsoleWindow() {
  const { sessionId } = useParams();
  const [session, setSession] = useState(null);
  const [error, setError] = useState("");
  const [activeNode, setActiveNode] = useState(null);
  const pollingRef = useRef(null);

  useEffect(() => {
    let cancelled = false;

    async function load() {
      try {
        const s = await api.get(`/labsessions/${sessionId}`);
        if (cancelled) return;
        setSession(s);
        if (s.node_map) {
          const names = Object.keys(s.node_map).sort();
          setActiveNode((prev) => (prev && names.includes(prev) ? prev : names[0]));
        }
      } catch (err) {
        if (!cancelled) setError(err.message || "Couldn't load this session.");
      }
    }

    load();
    pollingRef.current = setInterval(load, 4000);
    return () => {
      cancelled = true;
      clearInterval(pollingRef.current);
    };
  }, [sessionId]);

  // HTTP heartbeat — keeps session alive independent of WebSocket state.
  // Runs while the console tab is open, even if individual node websockets
  // disconnect or the user is not actively typing.
  useEffect(() => {
    if (!session || session.status !== "running") return;

    const hb = setInterval(() => {
      api.post(`/labsessions/${sessionId}/heartbeat`).catch(() => {});
    }, 60_000);

    return () => clearInterval(hb);
  }, [session?.status, sessionId]);

  useEffect(() => {
    document.title = session?.lab_title ? `Console · ${session.lab_title}` : "Console · NetBreaker";
  }, [session]);

  // All nodes get a tab — interactive ones (console_port > 0) open a
  // live terminal; passive ones (hubs, etc.) show a placeholder.
  const nodeNames = session?.node_map
    ? Object.keys(session.node_map).sort()
    : [];
  const consoleNodes = new Set(
    Object.keys(session?.node_map || {})
      .filter((name) => (session.node_map[name]?.console_port ?? 0) > 0)
  );

  if (error) {
    return (
      <div className="console-window-page console-window-center">
        <p className="alert alert-error" style={{ maxWidth: 420 }}>{error}</p>
      </div>
    );
  }

  if (!session) {
    return (
      <div className="console-window-page console-window-center">
        <div className="spinner" />
      </div>
    );
  }

  if (session.status !== "running") {
    return (
      <div className="console-window-page console-window-center">
        <p className="muted">
          {session.status === "provisioning"
            ? "Still provisioning — this tab will connect automatically once the session is up."
            : `Session is ${session.status}. You can close this tab.`}
        </p>
      </div>
    );
  }

  if (nodeNames.length === 0) {
    return (
      <div className="console-window-page console-window-center">
        <p className="muted">No nodes available. You can close this tab.</p>
      </div>
    );
  }

  return (
    <div className="console-window-page">
      <div className="console-window-head">
        <div className="console-modal-tabs">
          {nodeNames.map((name) => {
            const isPassive = !consoleNodes.has(name);
            return (
              <button
                key={name}
                className={
                  "btn btn-sm " +
                  (activeNode === name ? "btn-primary" : "") +
                  (isPassive ? " btn-ghost" : "")
                }
                onClick={() => setActiveNode(name)}
                style={{ fontFamily: "var(--mono)" }}
                title={isPassive ? "Passive device — no interactive console" : ""}
              >
                {name}
                {isPassive && (
                  <span style={{ fontSize: "0.65rem", opacity: 0.5, marginLeft: 3 }}>⬤</span>
                )}
              </button>
            );
          })}
        </div>
        <span className="muted mono" style={{ fontSize: "0.78rem" }}>
          {session.lab_title || "Live Lab"}
        </span>
      </div>

      <div className="console-window-body">
        {nodeNames.map((name) => {
          const isPassive = !consoleNodes.has(name);
          return (
            <div
              key={name}
              className="console-panel"
              style={{ display: activeNode === name ? "block" : "none" }}
            >
              {isPassive ? (
                <div className="console-window-center" style={{ height: "100%" }}>
                  <p className="muted">
                    Passive device — no interactive console.
                    <br />
                    <span style={{ fontSize: "0.85rem" }}>
                      Hubs, unmanaged switches, and patch panels don't run an OS.
                    </span>
                  </p>
                </div>
              ) : (
                <ConsolePanel
                  sessionId={session.id}
                  nodeName={name}
                  active={activeNode === name}
                  nodeInfo={session.node_map[name]}
                />
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
}
