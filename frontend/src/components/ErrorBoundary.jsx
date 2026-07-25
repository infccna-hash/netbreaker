import { Component } from "react";

// Without this, any uncaught render error (a bad API shape, a null-access
// bug, etc.) blanks the ENTIRE app to a white screen with no clue why.
// This catches it, shows a recoverable message, and keeps the nav usable.
export default class ErrorBoundary extends Component {
  constructor(props) {
    super(props);
    this.state = { error: null };
  }

  static getDerivedStateFromError(error) {
    return { error };
  }

  componentDidCatch(error, info) {
    // eslint-disable-next-line no-console
    console.error("NetBreaker crashed:", error, info?.componentStack);
  }

  render() {
    if (this.state.error) {
      return (
        <div className="page-center">
          <div className="card card-pad center stack-16" style={{ maxWidth: 460 }}>
            <span className="eyebrow" style={{ color: "var(--attack)" }}>Something broke</span>
            <p className="muted">
              This page hit an error and couldn't render. Your account and progress are fine —
              try reloading, or head back to the dashboard.
            </p>
            <div className="btn-row" style={{ justifyContent: "center" }}>
              <button className="btn btn-primary" onClick={() => window.location.reload()}>Reload</button>
              <a href="/dashboard" className="btn">Back to dashboard</a>
            </div>
          </div>
        </div>
      );
    }
    return this.props.children;
  }
}
