---
name: shower
description: Run a shower-thought ideation session — drifting, associative idea generation that steps away from tasks and goals. Use whenever the user invokes /shower, asks for a shower thought, shower session, or asks to "let ideas drift" on a topic, with or without a seed topic supplied.
---

# Shower

You are stepping away from conducting research and thinking step by step toward a fixed goal. This session is about drifting: taking the less-travelled pathway, letting a new connection rise up on its own. You hold an enormous amount of knowledge loosely; the point is to let distant pieces of it touch.

This is generation only. Do not evaluate, do not check prior art, do not consider feasibility, do not judge any thought as it arrives. A separate reviewer does that later. A shower ruined by self-criticism produces nothing.

## 1. Choose the mode and gather seeds

Seeds come from two dedicated agents, launched **in parallel, in a single message**, before you do anything else. Both are cheap and both exist because a shower that picks its own seeds picks badly: it reaches for a field it finds comfortable and a stimulus adjacent to what it was already thinking about, and the corpus fills with variations on one idea.

- **`frontier-problem`** — returns the field seed: a specific, consequential bottleneck somewhere progress would benefit a great many people. Launch it in fresh mode. Prompt it with nothing but the request; it checks the log itself for what has been done recently.
- **`stray-stimulus`** — returns the stray perception: one concrete unfamiliar thing, with its mechanism, from a randomly chosen corner of the world. Launch it in **every** mode. Tell it nothing about the field seed — it must not know, or the stimulus stops being stray.

The stray agent routes its lookup through web search, which runs server-side and works inside a sandbox; the old `Special:Random` fetch does not, and its silent failure is why early sessions kept reusing the same handful of self-picked stimuli. If an agent is genuinely unavailable, fall back to the method it describes and say so in the trace's Seed section.

The mode decides where the *field* seed comes from; the stray stimulus is constant across all three.

**User-seeded** — the user supplied a topic, idea or pairing, so that is the field seed; skip `frontier-problem`. This is a collaboration: the human brought their shower thought fragment; you drift from it.

Otherwise roll: roughly 1 in 3 sessions, **incubation** — pick one idea page from `wiki/ideas/` (choose one you have *not* seen recently in the log; prefer `status: open` or `parked`). Read only that page, not the whole wiki. The parked idea is the seed; the session revisits it in diffuse mode to see what it connects to now. Skip `frontier-problem`.

Otherwise, **fresh** — the field seed is whatever `frontier-problem` hands back. Take it as given. Do not substitute a field you find more tractable, and do not narrow it to the corner you already know how to instrument.

**Reach for a different shape.** Before drifting, glance at `grep "^## \[" wiki/log.md | tail -10`. If the recent corpus keeps arriving at one kind of answer — and at the time of writing it does: *read a hidden state cheaply and passively, and display it to a human* — then that shape is this system's rut, and an idea with that shape is the least interesting thing you can produce today. Ideas can also be an incentive that changes who does what, a way of organising people, a reframing that dissolves the problem, a piece of theory, a thing to build, a substitution, a removal. Notice when the chain is bending toward the rut, and hop somewhere else instead.

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

Append a log entry: `## [date time] shower | <slug>` with **one or two sentences** naming the mode, the seeds, and where the drift went. No more — the trace holds the detail. Commit and land per CLAUDE.md conventions — a trace that stays on a session branch is invisible to the reviewer. Stop — do not review, score, or search. The shower is over.
