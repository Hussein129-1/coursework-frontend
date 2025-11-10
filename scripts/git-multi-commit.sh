#!/usr/bin/env bash
set -euo pipefail

# Make multiple commits quickly and optionally push.
# Usage examples:
#   ./scripts/git-multi-commit.sh -n 10 -m "progress" --push --empty
#   ./scripts/git-multi-commit.sh -n 5 -m "checkpoint" -b main -r origin --push
# Flags:
#   -n <count>        Number of commits to create (required)
#   -m <message>      Commit message prefix (default: "auto commit")
#   -b <branch>       Branch to push (default: current branch)
#   -r <remote>       Remote name (default: origin)
#   --empty           Make all commits empty (no file changes required)
#   --push            Push to remote after committing

count=""
msg_prefix="auto commit"
branch=""
remote="origin"
all_empty=false
do_push=false

while (( "$#" )); do
  case "$1" in
    -n)
      count="$2"; shift 2 ;;
    -m)
      msg_prefix="$2"; shift 2 ;;
    -b)
      branch="$2"; shift 2 ;;
    -r)
      remote="$2"; shift 2 ;;
    --empty)
      all_empty=true; shift ;;
    --push)
      do_push=true; shift ;;
    *)
      echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "$count" ]]; then
  echo "Error: -n <count> is required" >&2
  exit 1
fi

if [[ -z "$branch" ]]; then
  branch=$(git rev-parse --abbrev-ref HEAD)
fi

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Not in a git repository" >&2; exit 1; }

if [[ "$all_empty" == false ]]; then
  git add -A
  if ! git diff --cached --quiet; then
    git commit -m "${msg_prefix} 1/{$count}"
    start=2
  else
    start=1
    all_empty=true
  fi
else
  start=1
fi

for (( i=start; i<=count; i++ )); do
  git commit --allow-empty -m "${msg_prefix} ${i}/${count}"
done

if [[ "$do_push" == true ]]; then
  git push "$remote" "$branch"
fi

echo "Done: created $count commits on $branch"
