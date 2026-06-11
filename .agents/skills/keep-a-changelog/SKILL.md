---
name: keep-a-changelog
description: Add a new version entry to CHANGELOG.md, or restructure the entire file, following the Keep a Changelog format and Semantic Versioning.
---

# Keep a Changelog

Use this skill when the user wants to add a new version entry to a `CHANGELOG.md`, or restructure the entire changelog file following the Keep a Changelog format and Semantic Versioning guidelines.

## Workflow — New Version Entry

1. **Read `CHANGELOG.md`** to identify the last released version and its date.
2. **Find recent commits:** Run `git log --oneline <last-tag>..HEAD` to list all commits since that tag. If no tag exists for the last version, use `git log --oneline` and filter manually.
3. **Get today's date:** Run `date +%Y-%m-%d` to get today's release date — never hardcode or guess it.
4. **Determine the new version number** (ask the user if not specified):
   - **MAJOR bump:** Breaking changes or major redesign.
   - **MINOR bump:** New features, backward-compatible.
   - **PATCH bump:** Bug fixes only.
5. **Group commits** into Keep a Changelog sections (see Section rules below).
6. **Prepend the new version block** immediately after the file header (before the previous latest version).
7. **Do NOT** remove or alter any existing version entries.

## Workflow — Restructure Entire CHANGELOG.md

1. **Read the full `CHANGELOG.md`** and note all existing version blocks.
2. **Rewrite the file** preserving all versions and dates but enforcing:
   - Correct header and intro paragraph (see File header below).
   - Consistent section names and ordering.
   - Bullet style: start each item with a capital letter, no trailing period.
3. **Get today's date:** Run `date +%Y-%m-%d` and confirm the latest version date is still accurate.

## File Header

```markdown
# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
```

## Version Block Format

```markdown
## [X.Y.Z] - YYYY-MM-DD
### Added
- ...

### Changed
- ...

### Fixed
- ...
```
*Omit any section that has no entries. Do not add empty sections.*

## Section Rules

Use only these standard Keep a Changelog section names, in this order when multiple sections are present:

| Section | When to use |
| :--- | :--- |
| **Added** | New features or capabilities |
| **Changed** | Changes to existing behavior |
| **Deprecated** | Features marked for future removal |
| **Removed** | Features removed in this release |
| **Fixed** | Bug fixes |
| **Security** | Security-related fixes or improvements |

## Commit → Section Mapping Heuristics

- `feat:` / `add` / `new` → **Added**
- `refactor:` / `change` / `rename` / `move` / `update` / `improve` → **Changed**
- `fix:` / `bug` / `patch` → **Fixed**
- `remove:` / `delete` / `drop` → **Removed**
- `deprecate:` → **Deprecated**
- `security:` / `cve` / `vuln` → **Security**
- `docs:` / `chore:` / `ci:` / `test:` → *Omit unless user-facing.*

*When a commit message is ambiguous, infer intent from the diff or file name.*

## Style Rules

- Write in English throughout.
- Each bullet: capital letter, present tense, no trailing period. *Example: `Add retry logic for HTTP requests`*
- Keep bullets concise — one line per entry where possible.
- Wrap code identifiers, file paths, and module names in backticks.
- Never guess dates — always retrieve the current date programmatically.
