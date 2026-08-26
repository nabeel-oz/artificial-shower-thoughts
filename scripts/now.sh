#!/usr/bin/env bash
# Print the current time in the corpus timezone, for filenames and log entries.
#
#   scripts/now.sh            -> 2026-08-27 09:46      (log headings, frontmatter)
#   scripts/now.sh --stamp    -> 2026-08-27-0946       (trace filenames)
#
# The timezone is read from .showertz (one IANA name, e.g. Australia/Sydney).
# Never compose a timestamp by hand: a cloud sandbox runs on UTC, so a guessed
# or unqualified time files the corpus hours off and, across midnight, on the
# wrong day.
#
# Git Bash on Windows ships no tz database and ignores TZ entirely, so we only
# apply TZ where the zone actually resolves; elsewhere the machine's own local
# clock is already the corpus timezone and is used as-is.
set -euo pipefail

fmt="+%Y-%m-%d %H:%M"
[ "${1:-}" = "--stamp" ] && fmt="+%Y-%m-%d-%H%M"

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tz="$(tr -d '[:space:]' < "$root/.showertz" 2>/dev/null || true)"

if [ -n "$tz" ] && [ -e "/usr/share/zoneinfo/$tz" ]; then
  TZ="$tz" date "$fmt"
else
  date "$fmt"
fi
