#!/bin/bash
# Scan all Claude Code custom commands across user and project directories.
# Outputs a table of command names and their descriptions.
#
# Usage: ./scan_commands.sh [project_dir ...]
#   With no args, scans ~/.claude/commands/ only.
#   Pass project dirs to also scan their .claude/commands/ and commands/ dirs.
#
# Example:
#   ./scan_commands.sh ~/Projects/Repos/ClaudeStage/claude-symphony

set -euo pipefail

DIRS=()

# Always scan user-level commands
USER_CMD_DIR="$HOME/.claude/commands"
if [ -d "$USER_CMD_DIR" ]; then
    DIRS+=("$USER_CMD_DIR")
fi

# Scan project dirs passed as arguments
for proj in "$@"; do
    for sub in ".claude/commands" "commands"; do
        dir="$proj/$sub"
        if [ -d "$dir" ]; then
            DIRS+=("$dir")
        fi
    done
done

if [ ${#DIRS[@]} -eq 0 ]; then
    echo "No command directories found."
    echo "Usage: $0 [project_dir ...]"
    exit 0
fi

printf "%-25s %-40s %s\n" "COMMAND" "DESCRIPTION" "SOURCE"
printf "%-25s %-40s %s\n" "-------" "-----------" "------"

for dir in "${DIRS[@]}"; do
    for file in "$dir"/*.md; do
        [ -f "$file" ] || continue
        name=$(basename "$file" .md)
        # Extract description from H1 ("# Title — Description") or first prose line
        h1=$(head -1 "$file")
        if echo "$h1" | grep -q ' — '; then
            desc=$(echo "$h1" | sed 's/^# [^—]*— //')
        else
            desc=$(echo "$h1" | sed 's/^# //')
        fi
        desc="${desc:0:55}"
        # Shorten source path for display
        source="${dir/#$HOME/~}"
        printf "%-25s %-40s %s\n" "/$name" "$desc" "$source"
    done
done
