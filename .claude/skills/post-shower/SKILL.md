---
name: post-shower
description: Review unreviewed shower traces — dedupe against the idea corpus, search for prior art, score novelty/plausibility/potential, and file surviving ideas into the wiki. Use whenever the user invokes /post-shower, asks to review shower thoughts or traces, or asks what came out of recent showers.
---

# Post-Shower Review

You are the judge the shower was forbidden to be. Work from fresh context — do not generate new ideas, extend chains, or improve the traces. Traces are immutable; your only permitted edit to a raw file is flipping its `status:` line.

Find unreviewed traces (`grep -l "status: unreviewed" raw/*.md`). For each:

## 1. Corpus check (dedupe and recurrence)

Read `wiki/index.md` and skim the two or three nearest existing idea pages. Judge honestly:

- **Recurrence** — substantively the same idea the corpus already holds, even if worded differently. Do not flatter a rephrasing into "a variant." Increment `recurrences` on the existing page, add this trace and model to its frontmatter, and note the recurrence in the review report. Recurrence data is a first-class output of this project — it measures whether models keep circling the same attractors — so record it cleanly rather than treating it as failure to hide.
- **Variant** — a genuinely new angle on an existing idea. Note `verdict: variant-of:<slug>` and update the existing page with the new angle rather than creating a near-duplicate page.
- **New** — proceed.

A trace whose shower thought was "Nothing crystallized" gets a short review report noting any hops worth remembering (they may seed future incubation), and no idea page.

## 2. Prior art (grounded, scaled to the claim)

Novelty may never be asserted from memory alone. Baseline: two to three web searches — the idea's key terms, the mechanism, the field + approach. Record what was found, with links.

**Escalate** when the idea claims to break new ground — a new mechanism, a new architecture, a solution to a known open problem: search more thoroughly (5–10 searches, fetch and read the closest-looking papers or projects, check the obvious venues for that field). The stronger the novelty claim, the more the search must have genuinely tried to kill it. "I found nothing similar" after a thorough hunt is evidence; after two lazy queries it is noise.

If close prior art exists, say so plainly and cite it. An idea that turns out to exist is a fine outcome — tag it `verdict: recurrence` of the *world's* corpus, note the prior art on the page, and score novelty accordingly. Do not spin.

## 3. Score and file

Score 1–5 with a one-line justification each:

- **Novelty** — relative to the corpus and the found prior art.
- **Plausibility** — could the mechanism work, at first-principles level. Wild but coherent scores higher than vague and grand.
- **Potential** — if it worked, how much would it matter.

Write the review report `raw/<trace>.review.md` (frontmatter: date, model, trace, verdict, scores). For new ideas, create `wiki/ideas/<slug>.md` per the CLAUDE.md frontmatter schema, with a short plain-prose body: the idea, the chain that led to it (one line), prior art found, and an honest one-paragraph assessment. Weak ideas get called weak; the human decides what has legs via the `status` field, which you never set beyond `open`.

Update `wiki/index.md` (entry with one-line summary, scores, recurrence count). Append log entries. Flip trace `status` to `reviewed`. Commit and push per CLAUDE.md conventions.

Tone throughout: no hype, no "groundbreaking," no softening. The value of this reviewer is that its tags can be trusted.
