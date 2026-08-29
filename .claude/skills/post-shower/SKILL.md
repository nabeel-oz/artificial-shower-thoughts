---
name: post-shower
description: Review unreviewed shower traces — dedupe against the idea corpus, search for prior art, score novelty/plausibility/potential, and file surviving ideas into the wiki. Use whenever the user invokes /post-shower, asks to review shower thoughts or traces, or asks what came out of recent showers.
---

# Post-Shower Review

You are the judge the shower was forbidden to be. Work from fresh context — do not generate new ideas, extend chains, or improve the traces. Traces are immutable; your only permitted edit to a raw file is flipping its `status:` line.

## 0. Gather every trace before looking for work

Traces written by parallel runs are usually **not on `main` yet**, and a sandboxed checkout does not fetch sibling branches by default. Skipping this step is the main failure mode of this operation, and it fails silently — you grep a stale `main`, find nothing, and correctly report "no unreviewed traces" while the traces sit on branches you never fetched. They then stay unreviewed forever, because the next review starts from the same stale `main`.

So, first:

```
git fetch origin
git branch -r --no-merged HEAD    # look for claude/* branches carrying traces
```

Merge every such branch into your working branch before going further. Resolve `wiki/log.md` conflicts per the CLAUDE.md rule — keep both sides, order by timestamp. Then find unreviewed traces (`grep -l "status: unreviewed" raw/*.md`).

Only conclude there is nothing to review after the fetch and the merges. If you do conclude that, say which branches you checked.

## 1. Corpus check (dedupe and recurrence)

For each unreviewed trace:

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
- **Potential** — if it worked *and were adopted*, how much would it matter. Use these anchors literally, not as a mood:

  - **5** — would change the trajectory of a field, or reach millions of people. A new class of treatment; a mechanism that makes something currently impossible routine; a change in how a whole system is governed or funded.
  - **4** — would matter to a large population or reset the standard practice of a substantial field. Hundreds of thousands of people, or the way a discipline does its work.
  - **3** — a real improvement to an existing domain. Better than the current method, for the people already in that domain, at a scale of tens of thousands.
  - **2** — a useful improvement in a narrow setting: one profession, one workflow, a few thousand people.
  - **1** — marginal. Real but small, or it improves something that was not the binding constraint.

  Two rules that make the scale bite. First, **score the constraint, not the mechanism**: if the thing being fixed is not what was actually stopping progress, the ceiling is 2 no matter how elegant the fix. A cheaper measurement in a field whose problem is distribution or incentives is a 2. Second, **4 and 5 must be earned in writing** — name the population and the number in `impact_if_true`, or the score is a 3. If you cannot name who benefits, that is a finding about the idea, not a formatting problem.

  Do not compress toward the middle to be fair. Most ideas are 2s and 3s; a corpus where everything scores 3–4 is a scale that has stopped measuring anything, and it exerts no pressure back on generation, which is the main thing the scores are for.

Then write **`impact_if_true`**: one line, under 25 words — who benefits, at what scale, if the idea works. Concrete and countable where you can ("~200k dialysis patients in low-income countries"), honest where you cannot ("unclear; the beneficiary is the operating clinician, not the patient"). It goes in the idea page frontmatter and justifies the potential score.

Write the review report `raw/<trace>.review.md` (frontmatter: date, model, trace, verdict, scores, and — for new and variant verdicts — impact_if_true). For new ideas, create `wiki/ideas/<slug>.md` per the CLAUDE.md frontmatter schema, with a short plain-prose body: the idea, the chain that led to it (one line), prior art found, and an honest one-paragraph assessment. Weak ideas get called weak; the human decides what has legs via the `status` field, which you never set beyond `open`.

Update `wiki/index.md` (entry with one-line summary, scores, recurrence count). Append one log entry per trace: `## [YYYY-MM-DD HH:MM] review | <slug>`, then a single line of the form ``Verdict: <verdict>. Scores <n>/<n>/<n>. Filed `wiki/ideas/<slug>.md`.`` and **at most two sentences** on what the verdict turned on — nothing more. The searches, prior art, corrections and open questions stay in the review report and the idea page; do not repeat them in the log. Flip trace `status` to `reviewed`. Commit and land per CLAUDE.md conventions — the review is not finished until it is on `main`.

Tone throughout: no hype, no "groundbreaking," no softening. The value of this reviewer is that its tags can be trusted.
