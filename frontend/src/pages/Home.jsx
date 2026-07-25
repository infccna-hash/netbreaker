import { Link } from "react-router-dom";
import PhaseTrack from "../components/PhaseTrack.jsx";

const PHASE_COPY = [
  { key: "build", tint: "var(--build-tint)", color: "var(--build)", title: "Build", body: "Stand up the real topology in GNS3 — VLANs, trunks, OSPF, HSRP. Config that boots, not slideware." },
  { key: "attack", tint: "var(--attack-tint)", color: "var(--attack)", title: "Attack", body: "Point Kali at what you built. VLAN hopping, rogue DHCP, ARP spoofing, WPA2 cracking — see it actually break." },
  { key: "harden", tint: "var(--harden-tint)", color: "var(--harden)", title: "Harden", body: "Close the hole you just walked through. Then the verifier checks your running config, not a multiple-choice box." },
];

export default function Home() {
  return (
    <div className="stack-24">
      <section className="hero grid grid-2" style={{ alignItems: "center", gap: 40 }}>
        <div className="stack-16">
          <span className="eyebrow">CCNA · offensive lab platform</span>
          <h1>Build the network. Then break it.</h1>
          <p className="lead">
            NetBreaker is 45 hands-on labs where you configure a real topology, attack it from Kali,
            and harden it back. You learn switching and routing the way it sticks — by exploiting it.
          </p>
          <div className="btn-row">
            <Link to="/register" className="btn btn-primary">Start with 3 free labs</Link>
            <Link to="/labs" className="btn">Browse all labs</Link>
          </div>
        </div>

        <div className="terminal" aria-hidden="true">
          <div><span className="c-prompt">SW1(config)#</span> switchport trunk native vlan 999</div>
          <div><span className="c-dim"># build phase — topology is live</span></div>
          <div style={{ marginTop: 8 }}><span className="c-prompt">kali@attacker:~$</span> <span className="c-attack">yersinia -G dtp</span></div>
          <div><span className="c-attack">[!]</span> negotiated trunk on fa0/2 — vlan hop successful</div>
          <div style={{ marginTop: 8 }}><span className="c-prompt">SW2(config-if)#</span> switchport nonegotiate</div>
          <div><span className="c-ok">[✓]</span> harden phase verified — dtp disabled, port locked</div>
        </div>
      </section>

      <div className="card card-pad">
        <div className="row between wrap" style={{ marginBottom: 20 }}>
          <div>
            <span className="eyebrow">the loop</span>
            <h2 style={{ marginTop: 6 }}>Every lab runs the same three phases</h2>
          </div>
          <PhaseTrack completed={["build", "attack", "harden"]} />
        </div>
        <div className="grid grid-3">
          {PHASE_COPY.map((p) => (
            <div key={p.key} className="stack stack-8" style={{ borderTop: `2px solid ${p.color}`, paddingTop: 14 }}>
              <span className="badge" style={{ background: p.tint, color: p.color, borderColor: p.color }}>{p.title}</span>
              <p className="muted" style={{ fontSize: "0.9rem" }}>{p.body}</p>
            </div>
          ))}
        </div>
      </div>

      <div className="grid grid-3">
        <Stat num="45" label="labs across switching, routing, services, security, wireless" />
        <Stat num="135" label="verified objectives — build, attack, and harden each lab" />
        <Stat num="1" label="certificate, issued only when every objective is complete" />
      </div>
    </div>
  );
}

function Stat({ num, label }) {
  return (
    <div className="card card-pad stat">
      <span className="num">{num}</span>
      <span className="lbl">{label}</span>
    </div>
  );
}
