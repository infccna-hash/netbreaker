import { createContext, useContext, useEffect, useState, useCallback } from "react";
import { api, setToken, getToken } from "./api.js";

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  const loadMe = useCallback(async () => {
    try {
      const me = await api.me();
      setUser(me);
      return me;
    } catch {
      setUser(null);
      return null;
    }
  }, []);

  // Restore session on first load: if we have (or can refresh) a token, fetch /me.
  useEffect(() => {
    (async () => {
      if (!getToken()) await api.refresh();
      if (getToken()) await loadMe();
      setLoading(false);
    })();
  }, [loadMe]);

  const login = useCallback(async (email, password) => {
    const data = await api.login({ email, password });
    setToken(data.access_token);
    setUser(data.user);
    return data.user;
  }, []);

  const register = useCallback(async (email, password, name) => {
    const data = await api.register({ email, password, name });
    setToken(data.access_token);
    setUser(data.user);
    return data.user;
  }, []);

  const logout = useCallback(async () => {
    try {
      await api.logout();
    } catch {
      /* ignore */
    }
    setToken(null);
    setUser(null);
  }, []);

  const isPro = user && (user.plan === "pro" || user.plan === "bootcamp");

  const value = { user, loading, isPro, login, register, logout, refreshUser: loadMe, setUser };
  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used inside AuthProvider");
  return ctx;
}
