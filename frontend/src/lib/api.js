// Thin fetch wrapper around the NetBreaker API.
// - Access token lives in memory (module scope) + localStorage for reloads.
// - The refresh token is an HttpOnly cookie the browser sends automatically.
// - On a 401 we transparently try /auth/refresh once, then retry the request.

const BASE = "/api/v1";
const TOKEN_KEY = "nb_access_token";

let accessToken = localStorage.getItem(TOKEN_KEY) || null;

export function getToken() {
  return accessToken;
}

export function setToken(token) {
  accessToken = token;
  if (token) localStorage.setItem(TOKEN_KEY, token);
  else localStorage.removeItem(TOKEN_KEY);
}

export class ApiError extends Error {
  constructor(status, body) {
    super((body && body.error) || `Request failed (${status})`);
    this.status = status;
    this.code = body && body.code;
    this.body = body;
  }
}

async function parse(res) {
  const text = await res.text();
  if (!text) return null;
  try {
    return JSON.parse(text);
  } catch {
    return text;
  }
}

async function raw(path, { method = "GET", body, auth = true } = {}) {
  const headers = {};
  if (body !== undefined) headers["Content-Type"] = "application/json";
  if (auth && accessToken) headers["Authorization"] = `Bearer ${accessToken}`;

  return fetch(BASE + path, {
    method,
    headers,
    body: body !== undefined ? JSON.stringify(body) : undefined,
    credentials: "include",
  });
}

let refreshing = null;

async function tryRefresh() {
  if (!refreshing) {
    refreshing = fetch(BASE + "/auth/refresh", {
      method: "POST",
      credentials: "include",
    })
      .then(async (res) => {
        if (!res.ok) return null;
        const data = await parse(res);
        if (data && data.access_token) {
          setToken(data.access_token);
          return data.access_token;
        }
        return null;
      })
      .catch(() => null)
      .finally(() => {
        refreshing = null;
      });
  }
  return refreshing;
}

export async function request(path, opts = {}) {
  let res = await raw(path, opts);

  if (res.status === 401 && opts.auth !== false) {
    const fresh = await tryRefresh();
    if (fresh) {
      res = await raw(path, opts);
    } else {
      setToken(null);
    }
  }

  const data = await parse(res);
  if (!res.ok) throw new ApiError(res.status, data);
  return data;
}

export const api = {
  get: (p) => request(p),
  post: (p, body) => request(p, { method: "POST", body }),
  put: (p, body) => request(p, { method: "PUT", body }),
  patch: (p, body) => request(p, { method: "PATCH", body }),
  del: (p) => request(p, { method: "DELETE" }),

  // Auth
  register: (payload) => request("/auth/register", { method: "POST", body: payload, auth: false }),
  login: (payload) => request("/auth/login", { method: "POST", body: payload, auth: false }),
  logout: () => request("/auth/logout", { method: "POST" }),
  refresh: tryRefresh,
  me: () => request("/me"),
};
