#!/usr/bin/env bash
# Scheduled post-shower review. Run some time after run_shower.sh so the
# reviewer gets fresh context, uncontaminated by the shower session.
set -euo pipefail
# Bill the Claude Code subscription, not API credits.
unset ANTHROPIC_API_KEY

cd "$(dirname "$0")/.."

MODEL="${REVIEW_MODEL:-opus}"   # opus = latest Opus | sonnet | a full model id

claude -p "/post-shower" \
  --model "$MODEL" \
  --allowedTools "Skill,Read,Write,Edit,Glob,Grep,WebSearch,WebFetch,Bash(git:*)" \
  >> logs/cron.log 2>&1 || true
