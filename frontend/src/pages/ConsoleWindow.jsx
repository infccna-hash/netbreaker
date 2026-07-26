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

  useEffect(() => {
    document.title = session?.lab_title ? `Console · ${session.lab_title}` : "Console · NetBreaker";
  }, [session]);

  const nodeNames = session?.node_map ? Object.keys(session.node_map).sort() : [];

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

  if (session.status !== "running" || nodeNames.length === 0) {
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

  return (
    <div className="console-window-page">
      <div className="console-window-head">
        <div className="console-modal-tabs">
          {nodeNames.map((name) => (
            <button
              key={name}
              className={"btn btn-sm " + (activeNode === name ? "btn-primary" : "")}
              onClick={() => setActiveNode(name)}
              style={{ fontFamily: "var(--mono)" }}
            >
              {name}
            </button>
          ))}
        </div>
        <span className="muted mono" style={{ fontSize: "0.78rem" }}>
          {session.lab_title || "Live Lab"}
        </span>
      </div>

      <div className="console-window-body">
        {nodeNames.map((name) => (
          <div
            key={name}
            className="console-panel"
            style={{ display: activeNode === name ? "block" : "none" }}
          >
            <ConsolePanel sessionId={session.id} nodeName={name} active={activeNode === name} />
          </div>
        ))}
      </div>
    </div>
  );
}
