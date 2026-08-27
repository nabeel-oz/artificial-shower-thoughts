# Artificial Shower Thoughts — Schema

This repository is an automated ideation system. Three workflows operate on it: the **shower** (generation, see `.claude/skills/shower/SKILL.md`), the **post-shower review** (evaluation, see `.claude/skills/post-shower/SKILL.md`), and the **lint** (wiki maintenance, see `.claude/skills/lint/SKILL.md`). Read the relevant skill before performing any of them. Never mix them in one pass: the shower does not judge, the reviewer does not generate, the linter does neither.

## Layers

- `raw/` — immutable. Shower traces (`raw/YYYY-MM-DD-HHMM-<slug>.md`) and reviewer reports (`raw/YYYY-MM-DD-HHMM-<slug>.review.md`). Write once, never edit. If a trace is wrong or embarrassing, it stays; that is data.
- `wiki/ideas/` — one page per surviving idea, maintained by the reviewer.
- `wiki/concepts/` — pages for themes recurring across ideas, maintained during lint.
- `wiki/index.md` — catalog of all wiki pages: link, one-line summary, status, recurrence count. Updated on every review and lint.
- `wiki/log.md` — chronological record: a quick timeline of what ran, when, and how it landed. Entry prefix format: `## [YYYY-MM-DD HH:MM] <operation> | <title>` where operation is `shower`, `review`, or `lint`. This makes the log greppable: `grep "^## \[" wiki/log.md | tail -5`. **Keep every entry to 1–2 sentences** (a review entry also carries its verdict and scores). The log is an index, not a report: detail belongs in the trace, the review report, the idea page and `wiki/index.md` — never restate it here. Entries are appended, never edited after the fact; the one exception is a lint pass, which may condense older entries that exceed the cap.

## Trace frontmatter (required on every shower trace)

```yaml
---
date: 2026-08-25T07:00
mode: fresh | incubation | user-seeded
seeds: ["<field or topic>", "<stray stimulus>"]
model: <model id of the showering agent>
status: unreviewed
---
```

After reviewing, the reviewer flips the trace's `status:` line to `reviewed` — the one exception to raw-file immutability, and the only edit ever allowed on a raw file. It also maintains the "Unreviewed traces" list in `wiki/index.md`, which is the quick way to see what is pending.

## Idea page frontmatter

```yaml
---
title: <short idea name>
first_seen: <date>
source_traces: [<trace filenames>]
models: [<model ids that produced or re-derived it>]
recurrences: <int, times a shower re-derived this idea after the first>
scores: {novelty: n/5, plausibility: n/5, potential: n/5}
verdict: new | variant-of:<idea-slug> | recurrence
status: open | pursuing | parked | retired
---
```

## Operations

**Shower** — generation only. Follow the shower skill. Output: one trace file in `raw/`, one log entry. Nothing else. Do not read the whole wiki first (a fresh shower should not be anchored by the corpus); the skill specifies exactly what context each mode loads.

**Review** — evaluation only, fresh context. Follow the post-shower skill. Processes every trace listed as unreviewed. Output: a review report per trace, idea pages created/updated, index updated, log entries.

**Lint** — periodic (roughly monthly, or when asked). Follow the lint skill. Reads the full wiki; looks for near-duplicate idea pages, recurring themes deserving a concept page, and — most valuably — **connections between ideas from different sessions**. Never touches `raw/`. Logs the pass.

## Conventions

- Plain markdown, no external database, no embedding infrastructure. `wiki/index.md` is the navigation layer; grep is the search engine.
- Wiki pages are written by agents and read by the human. The human edits taste-level fields (`status: pursuing`, notes) — preserve human edits on regeneration; if new information contradicts a human note, flag it in the page rather than overwriting.
- Tone in wiki pages: plain and honest. No hype, no self-congratulation. A weak idea gets called weak.
- **Timestamps come from the clock, never from your own estimate.** Read it from `scripts/now.sh`, which resolves the timezone named in `.showertz`:

  ```
  scripts/now.sh            # 2026-08-27 09:46   — log headings, frontmatter
  scripts/now.sh --stamp    # 2026-08-27-0946    — trace filenames
  ```

  Every timestamp comes from there — the trace filename, the `date:` frontmatter, the log heading. A cloud sandbox runs on UTC, so an agent that composes a time by hand files the corpus in the wrong timezone and, across midnight, on the wrong day. Use the script rather than `TZ=... date` directly: Git Bash on Windows ships no tz database and ignores `TZ` silently, which the script handles.

## Git

- **Start from current `main`** — `git fetch origin && git merge origin/main`. An incubation shower or a review that begins on a stale branch works from a partial corpus and does not know it.
- Commit after each operation with message `<operation>: <title>`.
- **Land the work on `main`.** A commit that exists only on a session branch is invisible: the human reads `main`. If you are on `main`, push. If you are on any other branch — cloud and sandboxed runs start on a per-session `claude/*` branch — merge into `main` and push `main`. Pushing your own branch is not finishing.
- If the push is rejected because a concurrent run landed first, `git pull --rebase` and push once more. If that also fails, leave your branch pushed and say so plainly — do not retry in a loop.
- Offline, or no remote configured: the commit alone is fine.
- `wiki/log.md` conflicts are expected whenever parallel runs land. Never resolve by taking one side — that silently deletes another run's entry. Keep every entry from both sides and order the merged block by timestamp.
