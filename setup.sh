#!/bin/bash
# Setup script for claude-config
# Symlinks skills into ~/.claude/commands/ so they're available as slash commands

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
COMMANDS_DIR="$HOME/.claude/commands"

mkdir -p "$COMMANDS_DIR"

echo "Linking skills from $REPO_DIR/skills/ and $REPO_DIR/cowork/ → $COMMANDS_DIR/"

for skill in "$REPO_DIR"/skills/*.md "$REPO_DIR"/cowork/*.md; do
  name="$(basename "$skill")"
  # Skip README
  [ "$name" = "README.md" ] && continue

  if [ -L "$COMMANDS_DIR/$name" ]; then
    echo "  ↻ $name (updating symlink)"
    rm "$COMMANDS_DIR/$name"
  elif [ -f "$COMMANDS_DIR/$name" ]; then
    echo "  ⚠ $name already exists (backing up to $name.bak)"
    mv "$COMMANDS_DIR/$name" "$COMMANDS_DIR/$name.bak"
  else
    echo "  + $name"
  fi

  ln -s "$skill" "$COMMANDS_DIR/$name"
done

echo ""
echo "Done! Skills are now available as slash commands in Claude Code."
echo "Run 'claude' and try /notion-todo, /write-spec, /architect, etc."
