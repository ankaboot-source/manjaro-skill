#!/bin/bash
# One-line install for manjaro-skill
# Works with: OpenCode, Claude Code
# Usage: curl -fsSL https://raw.githubusercontent.com/ankaboot-source/manjaro-skill/main/install.sh | bash

set -e

DEST="${HOME}/.config/opencode/skills/manjaro"
REPO="https://github.com/ankaboot-source/manjaro-skill.git"
BRANCH="main"

echo "Installing manjaro-skill to ${DEST}..."

mkdir -p "$(dirname "${DEST}")"

if [ -d "${DEST}" ]; then
    echo "Warning: ${DEST} already exists. Pulling latest..."
    cd "${DEST}" && git pull origin "${BRANCH}"
else
    git clone --depth 1 -b "${BRANCH}" "${REPO}" "${DEST}"
fi

echo "Done. Restart your AI assistant to load the skill."
echo ""
echo "To verify:"
echo "  ls ${DEST}/SKILL.md"
