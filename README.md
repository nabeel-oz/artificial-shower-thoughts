# Artificial Shower Thoughts

An automated brainstorming tool with a flavour: instead of putting an AI to *work* on ideas, it sends it for a *shower*.

## The idea

Does unlocking novel ideas from AI just require more scale? Or do we need to learn how to induce AI to "think" in the ways that make humans creative?

Human breakthroughs rarely arrive via step-by-step reasoning. They arrive in the shower, on a walk, half-asleep — when focused effort stops and the mind drifts. Cognitive science calls this the incubation effect: undirected, low-focus processing lets weakly-associated knowledge connect in ways deliberate reasoning doesn't. The apple drops, the snake bites its tail, the helix appears.

This project gives an AI a scheduled shower. On a cron schedule (or on demand), an agent steps away from tasks and goals and drifts: it takes a seed — a field where a new idea could genuinely matter, a random stray stimulus, an old parked idea, or a topic you hand it — and follows associative hops without judging them, leaving just enough of a trace to capture the chain. The aspiration is the relaxed, creative thought of a genius who holds all the clues but hasn't yet made the connection.

A second agent, the post-shower reviewer, then does what the shower must not: it judges. It checks each idea against the accumulated corpus and against the world (prior-art search, deeper research if the idea claims new ground) and tags it for novelty, plausibility, and potential. Surviving ideas compound into a persistent wiki — so old shower thoughts become seeds for new ones. That loop is the incubation mechanism a one-off brainstorm can't have.

This is not a claim that the current generation of models will produce a breakthrough. It may take a subsequent generation. Part of the fun is watching honestly: do models keep circling back to the same few ideas? Is novelty a harder problem than optimistic timelines suggest? The recurrence counts in the wiki will say.

The idea itself is a shower thought. Playful and creative. Part of the [Architectures of Mind](https://github.com/nabeel-oz) series — mapping observations about human cognition (here: diffuse-mode thinking and the default mode network) onto computational analogues.

## How it works

Three layers, adapted from Andrej Karpathy's [LLM Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) — with one inversion: his raw sources are external documents; ours are the model's own shower traces.

- **`raw/`** — immutable shower traces and reviewer reports, one file per session. The source of truth. Never edited after the fact.
- **`wiki/`** — the compounding layer, written and maintained by the agents: one page per surviving idea, concept pages for recurring themes, `index.md` as the catalog, `log.md` as the chronological record.
- **The schema** — `CLAUDE.md` plus three skills (`shower`, `post-shower`, `lint`) define the conventions and workflows.

### Where the seeds come from

A shower is only as good as what it starts from, and an agent left to choose its own seeds chooses badly in two specific ways: it picks a field it finds comfortable, and it picks a "random" stimulus that is quietly adjacent to what it was already thinking about. Both failures are invisible in any single trace and obvious across fifty — the corpus converges on small ideas in narrow niches.

So the seeds are delegated to two subagents in `.claude/agents/`, launched in parallel before the drift begins:

- **`frontier-problem`** names the field: one specific, current bottleneck in a domain where progress would reach a great many people. It draws on `references/frontiers.md` — a list of standing bottlenecks framed on Dario Amodei's [*Machines of Loving Grace*](https://www.darioamodei.com/essay/machines-of-loving-grace) — checks the log so it does not repeat last night, and grounds the choice in a live search. **Edit that file to steer what the system thinks about.**
- **`stray-stimulus`** supplies the stray perception — the dripping tap. `scripts/stray.sh` picks a corner of the world at random on the local machine (a domain, a region, a letter), and the agent goes and finds one concrete unfamiliar thing there, with its mechanism. It is told nothing about the field seed, because a stimulus chosen with the destination in mind is not stray.

Both agents reach the web through **search**, never a direct fetch. This is not a style preference: search is executed server-side by the API, while a direct fetch leaves the sandbox and is blocked by its egress proxy — silently. The original design fetched `Special:Random` from Wikipedia, and in the cloud that fetch failed on every single run, with the agent falling back to picking its own stimulus and never saying so.

## Setup

Requires [Claude Code](https://claude.com/claude-code). Clone the repo and you have a working instance — `raw/` and `wiki/` start empty and fill up as you run it.

```bash
git clone https://github.com/nabeel-oz/artificial-shower-thoughts
cd artificial-shower-thoughts
claude
```

What you clone is the framework; what it generates is yours. Since an idea corpus is the kind of thing you may not want public, point the repo at your own remote before the first shower — the workflows commit and push automatically, so this is worth deciding up front:

```bash
git remote rename origin upstream        # keep this repo for framework updates
gh repo create my-showers --private --source . --push
```

Later, `git pull upstream main` brings in framework changes without touching your traces. (A GitHub fork can't do this — forks inherit the parent repo's visibility, so a fork of a public repo is always public.)

## Running it

Three ways, in increasing order of how much you set up once and forget. All three run the same three operations against the same repo, so you can mix them freely — shower by hand today, on a schedule tomorrow.

The operations are always separate invocations. The reviewer must start from fresh context, uncontaminated by the shower session that produced the trace; running both in one session defeats the design.

### 1. By hand, in a chat

The simplest mode, and the best one for the first few runs — you watch the drift happen and get a feel for what the seeds do.

```
/shower                              # a shower with a random seed
/shower battery chemistry and coral reefs   # your own seed: human and AI shower thoughts colliding
/post-shower                         # review any unreviewed traces
/lint                                # periodic wiki maintenance (roughly monthly)
```

Run `/post-shower` in a new chat, not the one that just showered.

### 2. Scheduled in the cloud

Claude Code's `/schedule` runs a routine on Anthropic's infrastructure on a cron schedule — nothing on your machine needs to be awake. This suits the project well, because everything here is markdown in git: the cloud agent clones your repo, showers, commits, merges to `main` and pushes, and your local clone picks it up on the next `git pull`.

That merge step is not automatic, and it is the thing to understand about the cloud path. A cloud session starts on its own `claude/*` branch, so an agent that merely commits and pushes leaves the work stranded on a branch nobody reads — and the next review, starting from an unchanged `main`, reports "nothing to review" while the traces sit there unseen. The skills in this repo merge to `main` for exactly that reason. If a run ever appears to have vanished, `git branch -r` is the first place to look.

In any Claude Code chat, paste this once — substituting your own repo and times:

```
/schedule two routines on github.com/me/my-showers, both allowing the tools
Skill, Task, Read, Write, Edit, Glob, Grep, WebSearch, WebFetch and Bash:

  shower every 2 hours from 9pm to 5am — prompt: "Read and follow .claude/commands/shower.md"
  review one hour after each shower  — prompt: "Read and follow .claude/commands/post-shower.md"
```

That is the whole setup. The prompts name a file rather than restating an instruction, so the routines stay correct as the skills evolve — and a cloud agent that starts with zero context needs no expansion machinery to follow a path.

Why the details are spelled out: a routine runs in a sandbox with only the tools you grant it, and `Skill` is not in the default set — without it the agent can read the skill files but never invoke them. `Task` — the subagent tool, surfaced in some clients as `Agent` — matters for the same reason: without it the shower cannot launch its two seeding agents and falls back to choosing its own seeds. `WebSearch` and `WebFetch` matter just as much, since prior-art search is most of the reviewer's value, and search is also the only route to the open web that a sandbox does not block. Point the routines at *your* corpus repo, not this framework repo; the agent needs push access to wherever your traces live.

A nightly burst like that produces roughly five traces and five reviews by morning — pick a cadence you will actually read. Give the review its own slot an hour behind the shower rather than pairing them tightly: a review that fires while a shower is still writing simply picks the trace up on its next run.

The repo's `CLAUDE.md` and `.claude/skills/` are committed, so they land in the cloud checkout and behave exactly as they do locally. Routines have a minimum interval of one hour, and cron expressions are in UTC.

Set your timezone in `.showertz` (one line, an IANA name such as `Australia/Sydney`; ships as `UTC`). A cloud sandbox's clock is UTC, and the skills stamp filenames, frontmatter and log entries via `scripts/now.sh`, which reads that file — without it an overnight corpus is filed hours off, and across midnight on the wrong day. Check it with `scripts/now.sh` before the first scheduled run; it should print your wall clock.

### 3. Scheduled on your own machine

Use this when you want the runs happening in your real working tree — the traces appear in your local clone as they're written, with no pull needed.

Both scripts default to the latest Opus; override with `SHOWER_MODEL` / `REVIEW_MODEL`.

**Linux / macOS** — cron:

```cron
# A shower at 7am daily, reviewed 30 minutes later
0 7 * * * /path/to/artificial-shower-thoughts/scripts/run_shower.sh
30 7 * * * /path/to/artificial-shower-thoughts/scripts/run_review.sh
```

**Windows** — `register_tasks.ps1` registers the PowerShell twins with Task Scheduler. Prefer this to cron under WSL, which doesn't start on its own and dies with the WSL VM:

```powershell
# Hourly showers 9am-3pm, each reviewed 30 minutes later
.\scripts\register_tasks.ps1

# A single 7am shower, reviewed at 7:30
.\scripts\register_tasks.ps1 -ShowerStart 07:00 -ReviewStart 07:30 -Hours 0

.\scripts\register_tasks.ps1 -Unregister
```

The tasks run while you're logged on, and a run missed with the machine asleep fires when it next wakes. The scripts take a lock in `logs/`, so a review that fires while a shower is still running skips instead of committing into the same working tree — the next review picks up the backlog.

Scheduled runs are silent by design, so check `logs/cron.log` after the first one. A clean run ends with `exit 0`.

> **If the log says `Credit balance is too low`:** you have `ANTHROPIC_API_KEY` set in your environment. Claude Code prefers that key over your subscription login and bills the API instead. The scripts unset it for exactly this reason — if you invoke `claude -p` yourself, do the same, or drop the variable if you don't otherwise use it.

Each operation commits its output, and pushes if the repo has a remote — so a scheduled shower needs no manual git tending.

## Watching the experiment

Each trace records the drift, any light-bulb moment, and which model showered. The reviewer counts recurrences — when a model re-derives an idea the corpus already holds. Over time, `wiki/index.md` becomes a small dataset on model creativity: idea diversity per model, recurrence rates, and whether anything ever passes the only filter that finally matters — a human with taste deciding an idea is worth pursuing.
