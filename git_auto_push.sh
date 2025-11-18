#!/usr/bin/env bash
set -euo pipefail

commit_message="${1:-}"

git status -sb
echo
read -p "Continuar com git add -A e commit? [y/N] " answer
if [[ ! "$answer" =~ ^[Yy]$ ]]; then
  echo "Operação cancelada."
  exit 0
fi

git add -A
if git diff --cached --quiet; then
  echo "Nenhuma alteração para commitar."
  exit 0
fi

if [ -z "$commit_message" ]; then
  added=$(git diff --cached --name-only --diff-filter=A | wc -l | tr -d ' ')
  modified=$(git diff --cached --name-only --diff-filter=M | wc -l | tr -d ' ')
  deleted=$(git diff --cached --name-only --diff-filter=D | wc -l | tr -d ' ')

  summary_parts=()
  if [ "$added" -gt 0 ]; then
    summary_parts+=("$added added")
  fi
  if [ "$modified" -gt 0 ]; then
    summary_parts+=("$modified modified")
  fi
  if [ "$deleted" -gt 0 ]; then
    summary_parts+=("$deleted removed")
  fi

  if [ ${#summary_parts[@]} -eq 0 ]; then
    commit_message="chore: update files"
  else
    commit_message="auto: ${summary_parts[*]}"
  fi
fi

git commit -m "$commit_message"
git push -u origin main

