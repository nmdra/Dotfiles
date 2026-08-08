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

Create standardized, semantic git commits using the [Conventional Commits](https://www.conventionalcommits.org/) specification. Analyze the actual diff, stage intelligently, generate a precise message, and commit safely. When changes form distinct concerns, split them into separate commits.

---

## Step 0 — Pre-flight Checks

```bash
git branch --show-current        # what branch are we on?
git status --porcelain           # merge/rebase in progress?
```

**Hard stops:**

- **Merge/rebase in progress, or conflict markers in status** — stop. Do not commit. Resolve first (see the `resolving-merge-conflicts` skill).
- **On `main`/`master`** — ask the user before committing; this work usually belongs on a feature branch.
- **Secrets in the diff** (`.env`, `.env.*`, `*.pem`, `*.key`, `credentials.*`, `secrets.*`) — stop and warn before staging anything.

---

## Step 1 — Understand the Workspace

Run these together to get a full picture before touching anything:

```bash
git status --porcelain
git diff --stat
git diff --staged --stat
git log --oneline -10         # context: what types/scopes does this repo use?
```

**Decision tree:**

- Staged changes exist → use `git diff --staged` as the primary diff
- Nothing staged, working-tree changes exist → stage appropriately (Step 2), then use `git diff --staged`
- Nothing staged AND nothing in working tree → report "nothing to commit" and stop
- Untracked files only → ask user if they should be included
- If the user specified files (e.g. "commit only src/"), honour that scope

---

## Step 2 — Stage Intelligently

Never blindly `git add .`:

```bash
git add path/to/file            # files the user named
git add -u                      # tracked modifications only (safe default)
git add -A                      # new + modified (only when user wants untracked included)
git add 'src/**/*.ts' 'tests/**/*.ts'
```

**Hard rules — never stage:** secrets, files matching `.gitignore`, large binary blobs the user didn't mention.

---

## Step 3 — Analyze the Diff

```bash
git diff --staged
```

### Type & scope

| Signal | Look for |
| -------- | ---------- |
| **Type** | New exports/functions → `feat`; error handling, wrong logic → `fix`; `.md` only → `docs`; whitespace/rename → `style`; same behavior, restructured → `refactor`; benchmark improvements → `perf`; `*.test.*` only → `test`; package.json/lock files → `build`; CI configs → `ci`; security hardening/CVE → `security` |
| **Scope** | Module or package most affected. **Match scopes already used in recent `git log`** — repo consistency beats novelty. Omit scope if changes span 3+ unrelated modules |
| **Issue refs** | See table below |

### Breaking change checklist

Append `!` after type/scope **and** add a `BREAKING CHANGE:` footer when any apply:

- **Public API**: function/method removed, signature changed, required parameter added
- **Schema**: column/table dropped, type changed, NOT NULL added without default
- **Config**: env var or config key removed/renamed, default behavior reversed
- **HTTP**: route removed, response shape changed, status code semantics changed
- **Library exports**: exported symbol removed or renamed

### Issue references

Extract from these sources, in priority order — never invent or guess numbers:

| Source | Example | Footer |
| -------- | --------- | -------- |
| Branch name: `PROJ-123` pattern | `feature/PROJ-123-foo` | `Refs: PROJ-123` |
| Branch name: numeric pattern | `fix/123-bar`, `issue-123-foo` | `Closes #123` |
| Diff content | `#123` in changed code, tied to the change | `Closes #123` |
| User-provided | user mentions an issue before committing | as given |

Footer order: body, blank line, `BREAKING CHANGE:`, blank line, issue refs.

---

## Step 4 — Compose the Message

### Format

```
<type>[optional scope]: <description>

[body — bullet points, explain *why*, not *what*]

[footers]
```

### Subject rules

- ≤72 characters; imperative mood ("add" not "added"); no capital first letter; no trailing period
- Be specific: `fix(auth): handle expired JWT refresh token` not `fix: bug fix`
- Avoid vague words: `stuff`, `things`, `misc`, `update`, `improve`, `minor changes`

### Body

- Blank line after subject; wrap at 72 chars
- **Bullet-point format** (preferred): one `-` bullet per change/action, imperative mood
- Prose paragraph is acceptable for a single cohesive change; explain *why*, not what the diff already shows

### Footers

```
Closes #123
Refs #456
BREAKING CHANGE: v1 /users endpoint removed; migrate to /v2/users
```

### Never include

- `Co-authored-by:` lines or any AI/tool attribution ("Generated by...", "Created with...")
- Emoji
- File-operation descriptions ("add file to docs folder") — focus on the work done

---

## Step 5 — Execute the Commit

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

After committing: `git log --oneline -1` and show the user the hash and subject.

---

## Step 6 — Batch Mode (unrelated changes)

When the working tree holds logically unrelated changes (e.g. a refactor + a bug fix + a dep update), split them instead of one messy commit.

### Grouping rules

1. Co-dependent files together (implementation + its test, component + its styles)
2. Manifest + lock file always together (`package.json` + `package-lock.json`) — never standalone
3. Same feature/module directory together
4. Same change type together (all config, all docs)
5. Remaining files form a catch-all group

Target 2–5 commits, never more than 7. If everything lands in one group, fall back to a single commit.

### Present the plan and confirm

```
Proposed commits:

1. feat(wizard): add discount calculation to pricing step
   - src/components/wizard/PricingStep.tsx
   - src/lib/pricing.ts

2. fix(db): correct meeting balance view
   - supabase/migrations/20250102_fix_balance.sql

3. chore: update dependencies
   - package.json
   - package-lock.json
```

Ask "Proceed with these commits?" — wait for the answer.

### Execute sequentially

For each group: `git reset` (clear prior staging) → `git add <files>` → commit with the same message rules → verify with `git status`. **If any commit fails (e.g. hook), stop immediately** — do not continue to the next group.

---

## Step 7 — Push (only when asked)

Push only if the user asked to push (or explicitly approves). Before any push, **announce the target branch**:

```
Pushing to origin/<branch>...
```

- Branch has upstream → `git push`; none → `git push -u origin <branch>`; detached HEAD or no `origin` → skip with a message
- **Never force-push** (`--force`, `--force-with-lease`) unless the user explicitly requests it
- On failure (rejected, non-fast-forward, network): report the git error verbatim, do **not** retry automatically, let the user resolve and run `git push` themselves

---

## Step 8 — Handle Failures Gracefully

### Pre-commit hook failure

1. Read the hook output — what exactly failed?
2. Fix it if auto-fixable (`npm run lint:fix`, `black .`, `prettier --write`)
3. Re-stage the fixed files (`git add -u`)
4. Create a **NEW** commit — never amend or `--no-verify` unless the user explicitly asks
5. If not auto-fixable, show the error and ask how to proceed

### Nothing to commit

Report: "Working tree is clean — nothing to commit." If the user expected changes, check `git stash list` or `git diff HEAD~1`.

### Merge conflict markers

Stop immediately. Do not commit. Show conflicting files; guide resolution (see the `resolving-merge-conflicts` skill).

---

## Edge Cases

| Scenario | Handling |
| ---------- | ---------- |
| Binary files | Commit, don't analyze content; note as "add/update binary assets" |
| Lock files | Always group with their manifest, never standalone |
| Very large diffs (>1000 lines/file) | Use `--stat`, read first ~100 lines for context |
| Submodule changes | Note in the message, don't analyze internals |
| Untracked files only | Stage and commit normally, usually `feat` or `chore` |

---

## Reference: Commit Type Quick-Pick

| Type | When | Changelog? |
| ------ | ------ | ----------- |
| `feat` | New capability exposed to users or API consumers | Yes |
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

Changelog-worthy commits (`feat`, `fix`, `security`, `perf`) feed the `keep-a-changelog` skill's section mapping.

---

## Safety Protocol

- **NEVER** modify `git config` (global or local)
- **NEVER** run destructive commands (`--force`, `reset --hard`, `clean -fd`) without explicit user instruction
- **NEVER** use `--no-verify` unless the user explicitly says to skip hooks
- **NEVER** amend a commit that has already been pushed
- **NEVER** commit files containing secrets or credentials

When in doubt about scope or whether to split commits, ask the user — a single clarifying question is better than a wrong commit.
