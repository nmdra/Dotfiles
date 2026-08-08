---
description: Stage and commit via the git-commiter skill (Conventional Commits)
argument-hint: "[message-or-scope]"
---
Commit the current changes by delegating to the git-commiter skill.

Steps:

1. Read the skill: `/home/nimendra/.agents/skills/git-commit/SKILL.md`.
2. Follow it exactly: inspect workspace → stage intelligently (never `git add .`) → analyze the diff → compose a Conventional Commits message (≤72-char subject, imperative mood, correct type/scope) → commit → show `git log --oneline -1`.
3. Honor the argument if given: "$@" is a message hint (use it as the subject if it is a valid conventional commit message, otherwise as the scope/type hint).
4. Respect the skill's hard rules: never stage secrets, never `--no-verify`, never amend pushed commits, never modify git config.
5. If the diff has no changes or contains merge conflict markers, stop and report instead of committing.
6. If the diff mixes unrelated concerns, suggest splitting and ask before proceeding.
