import { NavLink, Link, Outlet, useNavigate } from "react-router-dom";
import { useAuth } from "../lib/auth.jsx";
import Brand from "./Brand.jsx";

export default function Layout() {
  const { user, logout } = useAuth();
  const navigate = useNavigate();

  async function onLogout() {
    await logout();
    navigate("/");
  }

  const cls = ({ isActive }) => (isActive ? "active" : "");
  const clsHide = ({ isActive }) => (isActive ? "active hide-sm" : "hide-sm");

  return (
    <div className="shell">
      <header className="nav">
        <div className="container nav-inner">
          <Link to="/"><Brand /></Link>
          <nav className="nav-links">
            <NavLink to="/labs" className={cls}>Labs</NavLink>
            <NavLink to="/pricing" className={clsHide}>Pricing</NavLink>
            {user ? (
              <>
                <NavLink to="/dashboard" className={cls}>Dashboard</NavLink>
                {user.plan === "bootcamp" && <NavLink to="/team" className={clsHide}>Team</NavLink>}
                {user.is_admin && <NavLink to="/admin" className={clsHide}>Admin</NavLink>}
                <NavLink to="/account" className={cls}>Account</NavLink>
                <button className="btn btn-sm btn-ghost" onClick={onLogout}>Log out</button>
              </>
            ) : (
              <>
                <NavLink to="/login" className={cls}>Log in</NavLink>
                <Link to="/register" className="btn btn-sm btn-primary">Start free</Link>
              </>
            )}
          </nav>
        </div>
      </header>

      <main>
        <div className="container">
          <Outlet />
        </div>
      </main>

      <footer className="footer">
        <div className="container row between wrap">
          <span>NetBreaker — build networks, then break them.</span>
          <span className="mono">45 labs · build · attack · harden</span>
        </div>
      </footer>
    </div>
  );
}
