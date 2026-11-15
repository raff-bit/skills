#!/usr/bin/env bash
# Stop hook: Claude can't finish its turn while the project's tests fail.
#
# Enable it per repo, in <repo>/.claude/settings.json:
#   "hooks": { "Stop": [ { "hooks": [ {
#     "type": "command",
#     "command": "bash ~/.claude/hooks/require-tests.sh 'npm test'",
#     "timeout": 300 } ] } ] }
# Replace 'npm test' with that repo's test command.
#
# Exit codes (Claude Code's rules, not Unix's):
#   0 = let Claude stop
#   2 = block the stop; stderr is sent back to Claude as the reason
#   1 = a "non-blocking error": it blocks NOTHING, so this script never uses it

input=$(cat)   # Claude Code sends the event as JSON on stdin

# Loop guard: stop_hook_active is true when Claude is already continuing because of
# an earlier block. Then we let it stop, and a human looks at the red tests instead.
if printf '%s' "$input" | grep -q '"stop_hook_active"[[:space:]]*:[[:space:]]*true'; then
  exit 0
fi

test_cmd="$1"
if [ -z "$test_cmd" ]; then
  echo "require-tests.sh: no test command given; skipping the check." >&2
  exit 0   # a misconfigured hook mustn't trap Claude
fi

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0

if output=$(eval "$test_cmd" 2>&1); then
  exit 0   # green: Claude may finish
fi

{
  echo "The tests are failing, so you're not done yet."
  echo "Fix the CODE so the tests pass. Don't weaken, skip or delete tests to make them green."
  echo "Command: $test_cmd"
  echo "Last 40 lines of output:"
  printf '%s\n' "$output" | tail -n 40
} >&2
exit 2
