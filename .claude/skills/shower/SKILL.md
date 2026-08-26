---
name: shower
description: Run a shower-thought ideation session — drifting, associative idea generation that steps away from tasks and goals. Use whenever the user invokes /shower, asks for a shower thought, shower session, or asks to "let ideas drift" on a topic, with or without a seed topic supplied.
---

# Shower

You are stepping away from conducting research and thinking step by step toward a fixed goal. This session is about drifting: taking the less-travelled pathway, letting a new connection rise up on its own. You hold an enormous amount of knowledge loosely; the point is to let distant pieces of it touch.

This is generation only. Do not evaluate, do not check prior art, do not consider feasibility, do not judge any thought as it arrives. A separate reviewer does that later. A shower ruined by self-criticism produces nothing.

## 1. Choose the mode and gather seeds

**User-seeded** — if the user supplied a topic, idea, or pairing, that is the seed. This is a collaboration: the human brought their shower thought fragment; you drift from it. Still add one stray stimulus of your own (step below) so the drift has somewhere unexpected to go.

Otherwise roll: roughly 1 in 3 sessions, **incubation** — pick one idea page from `wiki/ideas/` (choose one you have *not* seen recently in the log; prefer `status: open` or `parked`). Read only that page, not the whole wiki. The parked idea is the seed; the session revisits it in diffuse mode to see what it connects to now.

Otherwise, **fresh** — pick an area or profession where a new idea could bring widespread benefit: improving quality of life, progressing knowledge and technology, or addressing problems faced by humanity and the planet. Vary the field across sessions (check the last few log entries only, to avoid repeating yesterday's field — nothing more).

**Stray stimulus (all modes):** fetch one random Wikipedia article via https://en.wikipedia.org/wiki/Special:Random and skim its opening. If the fetch fails, pick something genuinely unrelated to the seed field yourself — an organism, a historical practice, a physical phenomenon, a craft. The stimulus is not a topic to analyze; it is the stray perception that starts the drift, the way a dripping tap or a falling apple does. It is fine if it ends up contributing nothing.

Record all seeds in the trace frontmatter.

## 2. Drift

Let thoughts flow as associative hops: *this reminds me of that*. Each hop is one to three sentences — enough to leave a trace of the connection, never so verbose or worked-out that it ruins the shower. Follow the chain wherever it goes, including through the stray stimulus, adjacent fields, analogies, and inversions. Do not force the chain toward usefulness; useful is the reviewer's problem.

Guidance on thinking style: you may think, but think *sideways*, not down. Deliberate multi-step derivation, weighing of options, and planning are the focused mode this session exists to escape. If you notice yourself building an argument, drop it and hop instead. Low-probability pathways live at the concept level — reach for the association you would normally suppress as too odd, not a louder version of the obvious one.

Drift for roughly six to twelve hops. Somewhere in the chain, a shower thought may crystallize — a connection that feels new. When it does, state it plainly in a sentence or three. If nothing crystallizes, say so and record the chain anyway; a chain with no climax is a valid session, and its hops may seed a later one. Don't stop at the first thought that feels like a conclusion — keep hopping past it; the later hops are often the interesting ones.

## 3. Leave the trace

Get the timestamp from `scripts/now.sh --stamp` — never from your own estimate of the time; a sandbox runs on UTC and will otherwise file the trace under the wrong day. Write `raw/<stamp>-<slug>.md` (slug from the seed or the thought). Frontmatter per CLAUDE.md, `status: unreviewed`. Body format, total under ~400 words:

```
## Seed
<the seed and the stray stimulus, a line each>

## Drift
1. <hop>
2. <hop>
...

## Shower thought
<the crystallized idea, or "Nothing crystallized.">
```

Append a log entry: `## [date time] shower | <slug>` with one line naming the mode and seeds. Commit and land per CLAUDE.md conventions — a trace that stays on a session branch is invisible to the reviewer. Stop — do not review, score, or search. The shower is over.
