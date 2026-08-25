# Artificial Shower Thoughts

An automated brainstorming tool with a flavour: instead of asking an AI to *work* on ideas, it asks an AI to *shower*.

## The idea

Human breakthroughs rarely arrive mid-spreadsheet. They arrive in the shower, on a walk, half-asleep — when focused effort stops and the mind drifts. Cognitive science calls this the incubation effect: undirected, low-focus processing lets weakly-associated knowledge connect in ways deliberate reasoning doesn't. The apple drops, the snake bites its tail, the helix appears.

This project gives an AI a scheduled shower. On a cron schedule (or on demand), an agent steps away from tasks and goals and drifts: it takes a seed — a field where a new idea could genuinely matter, a random stray stimulus, an old parked idea, or a topic you hand it — and follows associative hops without judging them, leaving just enough of a trace to capture the chain. The aspiration is the relaxed, creative thought of a genius who holds all the clues but hasn't yet made the connection.

A second agent, the post-shower reviewer, then does what the shower must not: it judges. It checks each idea against the accumulated corpus and against the world (prior-art search, deeper research if the idea claims new ground) and tags it for novelty, plausibility, and potential. Surviving ideas compound into a persistent wiki — so old shower thoughts become seeds for new ones. That loop is the incubation mechanism a one-off brainstorm can't have.

This is not a claim that the current generation of models will produce a breakthrough. It may take a subsequent generation. Part of the fun is watching honestly: do models keep circling back to the same few ideas? Is novelty a harder problem than optimistic timelines suggest? The recurrence counts in the wiki will say.

The idea itself is a shower thought. Playful and creative. Part of the [Architectures of Mind](https://github.com/nabeel-oz) series — mapping observations about human cognition (here: diffuse-mode thinking and the default mode network) onto computational analogues.

## How it works

Three layers, adapted from Andrej Karpathy's [LLM Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) — with one inversion: his raw sources are external documents; ours are the model's own shower traces.

- **`raw/`** — immutable shower traces and reviewer reports, one file per session. The source of truth. Never edited after the fact.
- **`wiki/`** — the compounding layer, written and maintained by the agents: one page per surviving idea, concept pages for recurring themes, `index.md` as the catalog, `log.md` as the chronological record.
- **The schema** — `CLAUDE.md` plus three skills (`shower`, `post-shower`, `lint`) define the conventions and workflows.

## Setup

Requires [Claude Code](https://claude.com/claude-code). Clone the repo and you have a working instance — `raw/` and `wiki/` start empty and fill up as you run it.

```bash
git clone https://github.com/nabeel-oz/artificial-shower-thoughts
cd artificial-shower-thoughts
claude -p "/shower"
```

What you clone is the framework; what it generates is yours. Since an idea corpus is the kind of thing you may not want public, point the repo at your own remote before the first shower — the workflows commit and push automatically, so this is worth deciding up front:

```bash
git remote rename origin upstream        # keep this repo for framework updates
gh repo create my-showers --private --source . --push
```

Later, `git pull upstream main` brings in framework changes without touching your traces. (A GitHub fork can't do this — forks inherit the parent repo's visibility, so a fork of a public repo is always public.)

## Usage

```bash
# A shower with a random seed
claude -p "/shower"

# A shower seeded with your own topic — human and AI shower thoughts colliding
claude -p "/shower battery chemistry and coral reefs"

# Review any unreviewed traces (run as a separate invocation so the
# reviewer gets fresh context, uncontaminated by the shower session)
claude -p "/post-shower"

# Periodic wiki maintenance: cross-link ideas, promote recurring themes
# to concept pages, merge near-duplicates (roughly monthly)
claude -p "/lint"
```

Scheduled showers via cron (see `scripts/run_shower.sh` and `scripts/run_review.sh`; both default to the latest Opus model, override with `SHOWER_MODEL` / `REVIEW_MODEL`):

```cron
# A shower at 7am daily, reviewed 30 minutes later
0 7 * * * /path/to/artificial-shower-thoughts/scripts/run_shower.sh
30 7 * * * /path/to/artificial-shower-thoughts/scripts/run_review.sh
```

On Windows, run the same scripts via WSL cron, or schedule the equivalent `claude -p` commands with Task Scheduler.

Each operation commits its output, and pushes if the repo has a remote — so a scheduled shower needs no manual git tending.

## Watching the experiment

Each trace records which model showered. The reviewer counts recurrences — when a model re-derives an idea the corpus already holds. Over time, `wiki/index.md` becomes a small dataset on model creativity: idea diversity per model, recurrence rates, and whether anything ever passes the only filter that finally matters — a human with taste deciding an idea is worth pursuing.
