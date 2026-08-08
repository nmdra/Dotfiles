---
name: git-commiter
description: >
  Execute git commits using the Conventional Commits specification. Use this skill whenever
  the user says "commit", "git commit", "/commit", "stage and commit", "make a commit",
  "save my changes", or asks to commit specific files or all changes. Also triggers on phrases
  like "push my changes" (commit first), "commit everything", "commit with message X",
  or whenever git diff/status suggests uncommitted work the user wants to save.
  Handles auto-staging, diff analysis, message generation, breaking change detection,
  batch splitting of unrelated changes, safe pushes, and pre-commit hook failures gracefully.
  Always use this skill rather than ad-hoc git commit commands.
license: MIT
allowed-tools: Bash, git, gh
---

# Git Commiter Skill

Create standardized git commits with [Conventional Commits](https://www.conventionalcommits.org/): analyze the diff, stage intelligently, compose a precise message, commit safely. Split unrelated changes; push only when asked.

## 1. Pre-flight

```bash
git branch --show-current    # on main/master? ask first
git status --porcelain       # merge/rebase in progress? conflict markers?
```

**Hard stops:** on `main`/`master` → ask before committing; merge/rebase in progress or conflict markers → stop and resolve via the `resolving-merge-conflicts` skill; secrets visible (`.env*`, `*.pem`, `*.key`, `credentials.*`) → warn before staging anything.

## 2. Workspace & staging

```bash
git status --porcelain
git diff --stat; git diff --staged --stat
git log --oneline -10        # repo's usual types/scopes
git diff --staged            # the primary diff once staged
```

- Staged changes exist → commit those. Working-tree only → stage below first. Nothing at all → report "nothing to commit", stop. Untracked only → ask whether to include.
- User named files → stage only those.
- Never `git add .`. Never stage secrets, `.gitignore`d files, or large binaries not mentioned.

```bash
git add path/to/file         # explicit scope
git add -u                   # tracked modifications (safe default)
git add -A                   # only when user wants untracked included
```

## 3. Compose the message

`<type>[scope]: <subject>` + body + footers. Types: see the table at the end.

- **Subject:** ≤72 chars; imperative ("add" not "added"); no leading capital or trailing period; specific — `fix(auth): handle expired JWT refresh token`, never `fix: bug fix`; avoid vague words (stuff, things, misc, update, improve).
- **Scope:** the module most affected; match scopes from recent `git log`; omit when 3+ unrelated modules.
- **Body:** blank line after subject; bullet points preferred (one `-` per change, imperative); prose is fine for one cohesive change; say *why*, not what the diff shows.
- **Breaking change?** → append `!` and a `BREAKING CHANGE:` footer: public API removed/signature changed/required param added; schema column/type dropped or changed; config key removed or default reversed; HTTP route/response/status changed; exported symbol removed.
- **Issue refs** (never invent): branch `PROJ-123` → `Refs: PROJ-123`; `issue-123` or numeric branch → `Closes #123`; `#123` in diff tied to the change; user-provided.
- **Footer order:** body → `BREAKING CHANGE:` → issue refs.
- **Never include:** `Co-authored-by:` or any AI attribution, emoji, or file-operation descriptions ("add file to docs folder") — describe the work done.

## 4. Execute

```bash
git commit -m "$(cat <<'EOF'
feat(api)!: replace v1 endpoint with v2

- remove /v1/users route handler
- return 410 Gone for /v1 paths

BREAKING CHANGE: clients calling /api/v1/users must migrate to /api/v2/users.
Closes #89
EOF
)"
```

Then show `git log --oneline -1`.

## 5. Batch mode — unrelated changes

Group by affinity: co-dependent files (impl + its test); manifest + lockfile; same module; same type. Target 2–5 commits, never more than 7; one group → single commit.

Present the plan (numbered commits with file lists), ask "Proceed with these commits?", wait. Then per group: `git reset` → `git add <files>` → commit → verify `git status`. **Any failure stops the sequence.**

## 6. Push — only when asked

Announce first: `Pushing to origin/<branch>...`. Use `git push`; `-u` if no upstream; skip if detached HEAD or no `origin`. Never force-push unless explicitly requested. On failure: report the error verbatim, don't retry automatically.

## 7. Failures & edge cases

- **Pre-commit hook:** read output → auto-fix (`lint:fix`, `prettier --write`, `black .`) → re-stage → **new** commit (never amend or `--no-verify` without an explicit ask); else show the error and ask.
- **Nothing to commit:** report it; if changes were expected, check `git stash list` or `git diff HEAD~1`.
- **Huge diffs (>1000 lines/file):** `--stat` first, then read ~100 lines of key files.
- **Binaries:** commit without analyzing content. **Submodules:** note in the message, don't dig inside.

## Reference: commit types

| Type | Use when | Changelog? |
| --- | --- | --- |
| `feat` | New capability exposed to users/API consumers | Yes |
| `fix` | Corrects wrong behaviour | Yes |
| `security` | Security hardening or vulnerability fix | Yes |
| `perf` | Measurably faster or less memory | Yes |
| `docs` | README, JSDoc — no code logic | No |
| `style` | Formatting, whitespace — zero logic change | No |
| `refactor` | Internal restructure, same external behaviour | No |
| `test` | Tests only, no production code | No |
| `build` | Build scripts, deps, bundler config | No |
| `ci` | Pipeline configs, Dockerfiles | No |
| `chore` | Housekeeping that fits no other type | No |
| `revert` | Undoing a prior commit | No |

Changelog-worthy types (`feat`, `fix`, `security`, `perf`) feed the `keep-a-changelog` skill.

## Safety protocol

- Never modify `git config`; never run destructive commands (`reset --hard`, `clean -fd`, force) without explicit instruction.
- Never `--no-verify`; never amend a pushed commit, unless explicitly asked.
- Never commit secrets or credentials.
- Unsure about scope or splitting? Ask one question.
