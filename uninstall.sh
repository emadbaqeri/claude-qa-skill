#!/usr/bin/env bash
set -euo pipefail

SKILL_DIR="${HOME}/.claude/skills/qa"

if [[ ! -d "${SKILL_DIR}" ]]; then
  echo "qa skill is not installed at ${SKILL_DIR} — nothing to do."
  exit 0
fi

rm -rf "${SKILL_DIR}"
echo "Removed ${SKILL_DIR}"
