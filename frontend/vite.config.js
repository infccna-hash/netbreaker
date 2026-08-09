import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  build: {
    // noVNC uses top-level await internally; the default es2020 target
    // can't transpile it. es2022 is safe for all modern browsers and
    // lets the RFB module pass through untouched.
    target: "es2022",
  },
  server: {
    // Local `npm run dev` proxies API calls to the Go server on :8080.
    proxy: {
      "/api": "http://localhost:8080",
    },
  },
});
