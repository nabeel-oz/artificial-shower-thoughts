#!/usr/bin/env bash
# Scheduled shower. Adjust the path and model to taste.
# Model choice is part of the experiment: traces record which model showered,
# and the reviewer counts per-model recurrences. Rotate models if curious.
set -euo pipefail
# Bill the Claude Code subscription, not API credits.
unset ANTHROPIC_API_KEY

cd "$(dirname "$0")/.."

MODEL="${SHOWER_MODEL:-opus}"   # opus = latest Opus | sonnet | a full model id

claude -p "/shower" \
  --model "$MODEL" \
  --allowedTools "Skill,Read,Write,Edit,Glob,Grep,WebFetch,Bash(git:*)" \
  >> logs/cron.log 2>&1 || true
