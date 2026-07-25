import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  server: {
    // Local `npm run dev` proxies API calls to the Go server on :8080.
    proxy: {
      "/api": "http://localhost:8080",
    },
  },
});
