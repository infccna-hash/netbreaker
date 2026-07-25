import { Navigate, useLocation } from "react-router-dom";
import { useAuth } from "../lib/auth.jsx";

export default function ProtectedRoute({ children, plan, admin }) {
  const { user, loading } = useAuth();
  const location = useLocation();

  if (loading) return <div className="page-center"><div className="spinner" /></div>;
  if (!user) return <Navigate to="/login" state={{ from: location.pathname }} replace />;
  if (admin && !user.is_admin) return <Navigate to="/dashboard" replace />;
  if (plan && !(user.plan === plan || (plan === "pro" && user.plan === "bootcamp"))) {
    return <Navigate to="/pricing" replace />;
  }
  return children;
}
