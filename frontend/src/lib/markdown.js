import { marked } from "marked";

// Lab phase content is authored by us and stored in our own database — it is NOT
// user-generated. We render it as trusted HTML (same trust model as the topology
// SVGs). Markdown lets us write rich labs (code blocks, tables, callouts) while
// still dropping in the occasional <div class="callout"> for gamified flourishes.
//
// NOTE: if you ever let third parties author labs, sanitize this output first
// (e.g. DOMPurify) — at that point the content stops being trusted.

marked.setOptions({
  gfm: true,
  breaks: false,
});

export function renderMarkdown(md) {
  if (!md) return "";
  return marked.parse(md);
}
