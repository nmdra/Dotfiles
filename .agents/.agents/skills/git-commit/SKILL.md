---
name: git-commiter
description: >
  Execute git commits using the Conventional Commits specification. Use this skill whenever
  the user says "commit", "git commit", "/commit", "stage and commit", "make a commit",
  "save my changes", or asks to commit specific files or all changes. Also triggers on phrases
  like "push my changes" (commit first), "commit everything", "commit with message X",
  or whenever git diff/status suggests uncommitted work the user wants to save.
  Handles auto-staging, diff analysis, message generation, breaking change detection,
  multi-scope commits, and pre-commit hook failures gracefully. Always use this skill
  rather than ad-hoc git commit commands.
license: MIT
allowed-tools: Bash, git, gh
---

# Git Commiter Skill

Create standardized, semantic git commits using the [Conventional Commits](https://www.conventionalcommits.org/) specification. Analyze the actual diff, stage intelligently, generate a precise message, and commit safely.

---

## Step 1 — Understand the Workspace

Run these together to get a full picture before touching anything:

```bash
git status --porcelain
git diff --stat
git diff --staged --stat
git log --oneline -5          # context: what kind of commits does this repo use?
```

**Decision tree:**
- Staged changes exist → use `git diff --staged` as the primary diff
- Nothing staged, working-tree changes exist → stage appropriately (see Step 2), then use `git diff --staged`
- Nothing staged AND nothing in working tree → report "nothing to commit" and stop
- Untracked files only → ask user if they should be included

If the user specified files (e.g. "commit only src/"), honour that scope and only stage those paths.

---

## Step 2 — Stage Intelligently

Never blindly `git add .`. Use judgment:

```bash
# Stage specific files the user named
git add path/to/file

# Stage all tracked modifications (safe default when user says "commit everything")
git add -u

# Stage new + modified (use when user explicitly wants untracked files included)
git add -A

# Stage a subset by pattern
git add 'src/**/*.ts' 'tests/**/*.ts'
```

**Hard rules — never stage:**
- `.env`, `.env.*`, `*.pem`, `*.key`, `credentials.*`, `secrets.*`
- Any file matching `.gitignore` patterns
- Large binary blobs the user didn't mention

If you detect secrets or sensitive-looking filenames in the diff, **stop and warn the user** before staging anything.

---

## Step 3 — Analyze the Diff

```bash
git diff --staged          # what's about to be committed
```

Extract from the diff:

| Signal | Look for |
|--------|----------|
| **Type** | New exports/functions → `feat`; error handling, wrong logic → `fix`; `.md` only → `docs`; whitespace/rename → `style`; same behavior, restructured → `refactor`; benchmark improvements → `perf`; `*.test.*` / `*.spec.*` → `test`; `package.json`, lock files → `build`; CI configs → `ci` |
| **Scope** | Directory name, module name, component name, or package name most affected |
| **Breaking?** | Removed exports, changed function signatures, renamed env vars, DB schema changes |
| **Issue refs** | Comments or branch name containing `#123`, `JIRA-456` |

**When multiple types apply:** pick the most significant. A PR that adds a feature AND fixes a bug is `feat` (the fix is secondary). If they're truly independent, suggest splitting — but don't block the commit.

---

## Step 4 — Compose the Message

### Format
```
<type>[optional scope]: <description>

[optional body — explain *why*, not *what*]

[optional footers]
```

### Description rules
- ≤72 characters
- Imperative mood, present tense: **"add"** not "added", **"fix"** not "fixes"
- No capital first letter, no trailing period
- Be specific: `fix(auth): handle expired JWT refresh token` not `fix: bug fix`

### Body (include when useful)
- Explain *why* the change was needed, not what the diff already shows
- Wrap at 72 chars
- Separate from subject with a blank line

### Footers
```
Closes #123
Refs #456
Co-authored-by: Name <email>
BREAKING CHANGE: description of the break
```

### Breaking changes
```
# Option A — exclamation mark shorthand
feat(api)!: remove v1 endpoint

# Option B — footer (more detail)
feat(api): replace v1 with v2 response format

BREAKING CHANGE: v1 /users endpoint removed; migrate to /v2/users
```

Use `!` when the break is self-evident from the description. Use the footer when clients need migration guidance.

---

## Step 5 — Execute the Commit

```bash
# Single-line message
git commit -m "feat(auth): add refresh token rotation"

# Multi-line message (body/footer)
git commit -m "$(cat <<'EOF'
feat(api)!: replace v1 endpoint with v2

v1 was deprecated in 2.0. All clients should migrate to /v2/users
which returns paginated results and proper HTTP status codes.

BREAKING CHANGE: /v1/users endpoint removed
Closes #89
EOF
)"
```

After committing, show the user the commit hash and subject:
```bash
git log --oneline -1
```

---

## Step 6 — Handle Failures Gracefully

### Pre-commit hook failure
If a hook (lint, format, tests) fails:

1. **Read the hook output** — what exactly failed?
2. **Fix the issue** if it's auto-fixable (e.g. `npm run lint:fix`, `black .`, `prettier --write`)
3. **Re-stage the fixed files** (`git add -u`)
4. **Create a NEW commit** — never amend or `--no-verify` unless the user explicitly asks
5. If not auto-fixable, show the error and ask the user how to proceed

### Nothing to commit
```bash
git status
```
Report clearly: "Working tree is clean — nothing to commit." If the user expected changes, help them check `git stash list` or `git diff HEAD~1`.

### Merge conflict markers in staged files
Stop immediately. Do not commit. Show the conflicting files and guide the user to resolve them first.

---

## Multi-commit Scenarios

When the diff contains logically unrelated changes (e.g. a refactor + a bug fix), suggest splitting:

```
I see two separate concerns in the diff:
1. Refactor of the auth module (src/auth/)
2. Bug fix in the payment handler (src/payments/)

Shall I create two separate commits for cleaner history?
  [A] Yes, split them
  [B] No, combine into one commit
```

If user says split, stage and commit each group in sequence.

---

## Reference: Commit Type Quick-Pick

| Type | When | Example |
|------|------|---------|
| `feat` | New capability exposed to users or API consumers | `feat(search): add fuzzy matching` |
| `fix` | Corrects wrong behaviour | `fix(cart): prevent duplicate item addition` |
| `docs` | README, JSDoc, wikis — no code logic | `docs(api): document rate limit headers` |
| `style` | Formatting, whitespace, semicolons — zero logic change | `style: apply prettier to all files` |
| `refactor` | Internal restructure, same external behaviour | `refactor(db): extract query builder class` |
| `perf` | Measurably faster or less memory | `perf(images): switch to WebP encoding` |
| `test` | Tests only, no production code | `test(auth): add edge cases for token expiry` |
| `build` | Build scripts, deps, bundler config | `build: upgrade vite to 5.x` |
| `ci` | Pipeline configs, GitHub Actions, Dockerfiles | `ci: add staging deploy workflow` |
| `chore` | Housekeeping that fits no other type | `chore: remove unused i18n keys` |
| `revert` | Undoing a prior commit | `revert: feat(search): add fuzzy matching` |

---

## Safety Protocol

- **NEVER** modify `git config` (global or local)
- **NEVER** run destructive commands (`--force`, `reset --hard`, `clean -fd`) without explicit user instruction
- **NEVER** use `--no-verify` unless the user explicitly says to skip hooks
- **NEVER** force-push to `main`, `master`, or `production`
- **NEVER** amend a commit that has already been pushed
- **NEVER** commit files containing secrets or credentials

When in doubt about scope or whether to split commits, ask the user — a single clarifying question is better than a wrong commit.
