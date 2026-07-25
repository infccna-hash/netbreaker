import { Routes, Route } from "react-router-dom";
import Layout from "./components/Layout.jsx";
import ProtectedRoute from "./components/ProtectedRoute.jsx";

import Home from "./pages/Home.jsx";
import Login from "./pages/Login.jsx";
import Register from "./pages/Register.jsx";
import Labs from "./pages/Labs.jsx";
import LabDetail from "./pages/LabDetail.jsx";
import Pricing from "./pages/Pricing.jsx";
import Dashboard from "./pages/Dashboard.jsx";
import Certificate from "./pages/Certificate.jsx";
import VerifyCertificate from "./pages/VerifyCertificate.jsx";
import Account from "./pages/Account.jsx";
import Team from "./pages/Team.jsx";
import Admin from "./pages/Admin.jsx";
import NotFound from "./pages/NotFound.jsx";

export default function App() {
  return (
    <Routes>
      <Route element={<Layout />}>
        <Route index element={<Home />} />
        <Route path="login" element={<Login />} />
        <Route path="register" element={<Register />} />
        <Route path="labs" element={<Labs />} />
        <Route path="labs/:id" element={<LabDetail />} />
        <Route path="pricing" element={<Pricing />} />
        <Route path="certificate/verify/:code" element={<VerifyCertificate />} />

        <Route path="dashboard" element={<ProtectedRoute><Dashboard /></ProtectedRoute>} />
        <Route path="certificate" element={<ProtectedRoute plan="pro"><Certificate /></ProtectedRoute>} />
        <Route path="account" element={<ProtectedRoute><Account /></ProtectedRoute>} />
        <Route path="team" element={<ProtectedRoute plan="bootcamp"><Team /></ProtectedRoute>} />
        <Route path="admin" element={<ProtectedRoute admin><Admin /></ProtectedRoute>} />

        <Route path="*" element={<NotFound />} />
      </Route>
    </Routes>
  );
}
