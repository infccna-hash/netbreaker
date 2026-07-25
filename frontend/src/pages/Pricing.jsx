import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { api } from "../lib/api.js";
import { useAuth } from "../lib/auth.jsx";

const PLANS = [
  {
    id: "free",
    name: "Free",
    price: "$0",
    cadence: "forever",
    features: ["3 starter labs", "Build · attack · harden walkthroughs", "Progress tracking"],
  },
  {
    id: "pro",
    name: "Pro",
    price: "$19",
    cadence: "/ month",
    featured: true,
    features: [
      "All 45 labs, every phase",
      "Downloadable starter configs",
      "Topology diagrams (full detail)",
      "Completion certificate + public verify link",
    ],
  },
  {
    id: "bootcamp",
    name: "Bootcamp",
    price: "$99",
    cadence: "/ month",
    features: [
      "Everything in Pro",
      "Up to 5 seats for your cohort",
      "Team progress dashboard",
      "Invite members by email",
    ],
  },
];

export default function Pricing() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [busy, setBusy] = useState("");
  const [error, setError] = useState("");

  async function choose(planId) {
    if (planId === "free") {
      navigate(user ? "/dashboard" : "/register");
      return;
    }
    if (!user) {
      navigate("/register", { state: { from: "/pricing" } });
      return;
    }
    setError("");
    setBusy(planId);
    try {
      const res = await api.post("/subscription/checkout", { plan: planId });
      if (res && res.url) window.location.href = res.url;
      else setError("Could not start checkout. Try again.");
    } catch (err) {
      setError(err.message);
    } finally {
      setBusy("");
    }
  }

  return (
    <div className="stack-24">
      <div className="center stack-8">
        <span className="eyebrow">Pricing</span>
        <h1>Pick a plan and start breaking things</h1>
        <p className="muted">Start free with 3 labs. Upgrade when you want the full curriculum.</p>
      </div>

      {error && <div className="alert alert-error">{error}</div>}

      <div className="grid grid-3">
        {PLANS.map((plan) => {
          const current = user && user.plan === plan.id;
          return (
            <div key={plan.id} className={"card pricing-card" + (plan.featured ? " featured" : "")}>
              <div className="stack stack-8">
                <div className="row between">
                  <span className="eyebrow">{plan.name}</span>
                  {plan.featured && <span className="badge pro">most popular</span>}
                </div>
                <div className="price">{plan.price} <small>{plan.cadence}</small></div>
              </div>
              <ul className="feat-list">
                {plan.features.map((f) => (
                  <li key={f}><span className="tick">✓</span>{f}</li>
                ))}
              </ul>
              <button
                className={"btn btn-block " + (plan.featured ? "btn-primary" : "")}
                onClick={() => choose(plan.id)}
                disabled={current || busy === plan.id}
              >
                {current ? "Current plan" : busy === plan.id ? <span className="spinner" /> :
                  plan.id === "free" ? "Get started" : `Upgrade to ${plan.name}`}
              </button>
            </div>
          );
        })}
      </div>
    </div>
  );
}
