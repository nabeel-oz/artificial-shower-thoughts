#!/usr/bin/env bash
# Emit a random search-spec for the shower's stray stimulus.
#
# The stimulus used to come from https://en.wikipedia.org/wiki/Special:Random,
# fetched directly. Sandboxed runs cannot reach the open web — the egress proxy
# blocks the fetch, the agent silently falls back to picking a stimulus itself,
# and a self-picked stimulus is not a stray perception: it repeats, and it is
# already adjacent to whatever the agent was thinking about.
#
# So the randomness is generated here, locally, and only the *lookup* goes over
# the wire (via web search, which is executed server-side and is not blocked).
# This script picks the corner of the world to go rummaging in; the agent finds
# something specific there and does not get to choose the corner.
#
# Usage: scripts/stray.sh

set -euo pipefail

pick() { local i=$(( RANDOM % $# + 1 )); echo "${!i}"; }

domain=$(pick \
  "a folk craft or trade practice" \
  "a marine organism" \
  "an insect or arachnid" \
  "a fungus, lichen or slime mould" \
  "a plant with an unusual growth habit" \
  "a geological formation or process" \
  "a weather or atmospheric phenomenon" \
  "a traditional musical instrument" \
  "a dance, ritual or festival" \
  "a game, puzzle or sport" \
  "a cooking or food-preservation method" \
  "a textile or dyeing technique" \
  "a building method or vernacular architecture" \
  "an obsolete machine or industrial process" \
  "a navigation or wayfinding practice" \
  "a mining, fishing or forestry practice" \
  "a writing system, cipher or notation" \
  "a legal or administrative custom" \
  "a monetary or trading practice" \
  "a burial, mourning or memorial custom" \
  "a mythological figure or folk belief" \
  "a historical military tactic or logistics practice" \
  "a medical or veterinary practice from before 1900" \
  "an animal behaviour (foraging, mating, migration, defence)" \
  "a symbiosis or parasitism" \
  "a physical phenomenon with a named effect" \
  "a chemical process used in industry" \
  "an astronomical object or event" \
  "a piece of civil infrastructure" \
  "a transport system or vehicle type" \
  "a theatrical, circus or puppetry tradition" \
  "a printing, bookbinding or archiving practice" \
  "a timekeeping or calendar system" \
  "a children's practice: a toy, a rhyme, a schoolyard rule" \
  "a domestic object with a forgotten purpose" \
  "an occupation that no longer exists" \
  "a linguistic phenomenon" \
  "a mathematical object with a physical origin" \
  "a plumbing, drainage or sanitation practice" \
  "a beekeeping, herding or husbandry practice")

region=$(pick \
  "West Africa" "the Andes" "Japan" "medieval Europe" "the Pacific islands" \
  "the Arctic" "South Asia" "the Levant" "China" "Australia" \
  "the Caribbean" "Scandinavia" "the Sahara" "the Amazon" "Central Asia" \
  "the British Isles" "Mesoamerica" "the Balkans" "Indonesia" "Siberia" \
  "the deep ocean" "high mountains" "wetlands" "arid grassland" "caves")

letter=$(pick a b c d e f g h i j k l m n o p q r s t u v w y z)

cat <<SPEC
domain: $domain
region or setting: $region
letter to prefer: $letter
SPEC
