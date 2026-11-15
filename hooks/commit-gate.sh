#!/usr/bin/env bash
# PreToolUse hook: Claude can't `git commit` while the project's tests fail.
#
# Why commit-time and not Stop: in TDD the Red step ENDS on a failing test, so
# blocking every red turn would fight the workflow. What must never happen is a red
# commit. This gates only Claude's commits; your own commits in the terminal aren't
# affected.
#
# Enable it per repo, in <repo>/.claude/settings.json:
#   "hooks": { "PreToolUse": [ { "matcher": "Bash|PowerShell", "hooks": [ {
#     "type": "command",
#     "command": "bash ~/.claude/hooks/commit-gate.sh 'npm test'",
#     "timeout": 300 } ] } ] }
# Replace 'npm test' with that repo's test command.
#
# Exit codes (Claude Code's rules, not Unix's):
#   0 = let the command run
#   2 = block the command; stderr is sent back to Claude as the reason
#   1 = a "non-blocking error": it blocks NOTHING, so this script never uses it

input=$(cat)   # Claude Code sends the tool call as JSON on stdin

# Only act on commits. Anything else (ls, git status, npm install...) passes untouched.
if ! printf '%s' "$input" | grep -Eq 'git[[:space:]]+commit'; then
  exit 0
fi

test_cmd="$1"
if [ -z "$test_cmd" ]; then
  echo "commit-gate.sh: no test command given; the commit is NOT being checked." >&2
  exit 0   # a misconfigured hook mustn't block all work, but it says so out loud
fi

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0

if output=$(eval "$test_cmd" 2>&1); then
  exit 0   # green: the commit may go ahead
fi

{
  echo "Commit blocked: the tests are failing."
  echo "Fix the CODE so the tests pass, then commit again. Don't weaken, skip or delete tests to make them green."
  echo "If this is the TDD Red step, don't commit yet: show the failing test to the user and stop."
  echo "Command: $test_cmd"
  echo "Last 40 lines of output:"
  printf '%s\n' "$output" | tail -n 40
} >&2
exit 2
