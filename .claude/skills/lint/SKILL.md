---
name: lint
description: Run a wiki lint pass — connect ideas across sessions, promote recurring themes to concept pages, merge near-duplicate idea pages, and refresh the index. Use whenever the user invokes /lint or asks to tidy, consolidate, or lint the wiki.
---

# Lint

Periodic maintenance of the wiki layer (roughly monthly, or when asked). Unlike a shower or review, this pass reads the **full wiki**: `wiki/index.md`, every page in `wiki/ideas/` and `wiki/concepts/`, and recent `wiki/log.md` entries. Raw traces stay untouched — lint never edits `raw/`.

Look for, in order of value:

1. **Connections between ideas from different sessions** — the most valuable output. For a genuine connection, cross-link the pages; if the synthesis is itself a new idea, create a synthesis page in `wiki/ideas/` naming its parent ideas in `source_traces`-style provenance. Do not force connections — a lint pass that finds none is a valid pass.
2. **Recurring themes** deserving a concept page in `wiki/concepts/` — a theme that three or more idea pages orbit. The concept page names the theme, links the orbiting ideas, and says plainly what the attractor seems to be.
3. **Near-duplicate idea pages** the reviewer missed — merge into one page, combine frontmatter (sum recurrences, union traces and models), and note the merge in the survivor's body.
4. **Stale index entries and orphan pages** — every wiki page should appear in `wiki/index.md` with an accurate one-line summary; every index entry should point at a real page.

Preserve human edits throughout (`status:` values, human notes); if new information contradicts a human note, flag it in the page rather than overwriting. Tone stays plain and honest.

Append a log entry: `## [YYYY-MM-DD HH:MM] lint | <short summary>` — **1–2 sentences** naming what changed (pages merged, concepts promoted, index fixes) and the single best connection found. The reasoning goes on the concept pages and in `wiki/index.md`, not in the log. If older log entries exceed the 1–2 sentence cap, condense them in the same pass — this is the one operation allowed to edit past entries, and the timestamp, operation and title of every entry must survive untouched.

Commit and push per CLAUDE.md conventions.
