#!/usr/bin/env bash
set -euo pipefail

SKILL_DIR="${HOME}/.claude/skills/qa"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${SCRIPT_DIR}/skills/qa"

echo "Installing qa skill → ${SKILL_DIR}"

if [[ -d "${SKILL_DIR}" ]]; then
  backup="${SKILL_DIR}.bak.$(date +%Y%m%d%H%M%S)"
  echo "  Existing install found — backing up to ${backup}"
  mv "${SKILL_DIR}" "${backup}"
fi

mkdir -p "${SKILL_DIR}"
cp -r "${SOURCE_DIR}/." "${SKILL_DIR}/"

echo "  Done. Invoke with /qa inside any Claude Code session."
