#!/bin/bash
# Manjaro Skill - One-line installer
# Usage: curl -fsSL https://raw.githubusercontent.com/ankaboot-source/manjaro-skill/main/install.sh | bash

set -e

SKILL_DIR="$HOME/.config/opencode/skills/manjaro"
REPO_URL="https://github.com/ankaboot-source/manjaro-skill.git"

if [ -d "$SKILL_DIR" ]; then
    if [ -d "$SKILL_DIR/.git" ]; then
        echo "Updating existing manjaro skill..."
        cd "$SKILL_DIR"
        git pull --ff-only origin main
    else
        echo "Backing up existing non-git manjaro skill to ${SKILL_DIR}.backup..."
        mv "$SKILL_DIR" "${SKILL_DIR}.backup"
        git clone --depth 1 "$REPO_URL" "$SKILL_DIR"
    fi
else
    echo "Installing manjaro skill to $SKILL_DIR..."
    git clone --depth 1 "$REPO_URL" "$SKILL_DIR"
fi

echo "Done. The manjaro skill is ready in $SKILL_DIR"
