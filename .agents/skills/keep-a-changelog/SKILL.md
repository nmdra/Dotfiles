---
name: keep-a-changelog
description: Maintain CHANGELOG.md — add new version entries, keep the Unreleased section, cut a release, or restructure the whole file — following the Keep a Changelog format and Semantic Versioning.
---

# Keep a Changelog

Use this skill when the user wants to add a new version entry to a `CHANGELOG.md`, maintain the `Unreleased` section, cut a release, or restructure the changelog following the [Keep a Changelog](https://keepachangelog.com/en/2.0.0/) format and Semantic Versioning.

## Principles

- Changelogs are **for humans**, not machines. They are *curated*: record **notable, user-facing** changes only — a changelog is not a commit log.
- Machines can draft; humans curate. When generating from commits, summarize from the reader's point of view; never paste `git log` output.
- List the latest version first. Show the release date (`YYYY-MM-DD`). Write plainly — many readers are not native speakers.
- **Never guess dates** — always retrieve the current date programmatically (`date +%Y-%m-%d`).

## Structure

### File header

Pin the link to the spec version the file follows (2.0.0 unless the repo pins an older one):

```markdown
# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/2.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
```

### Unreleased section (top of file)

```markdown
## [Unreleased]
### Added
- ...
```

### Version blocks and comparison links (bottom of file)

```markdown
## [1.1.0] - 2025-06-01
### Added
- ...
### Fixed
- ...

[Unreleased]: https://github.com/owner/repo/compare/v1.0.0...HEAD
[1.1.0]: https://github.com/owner/repo/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/owner/repo/releases/tag/v1.0.0
```

`[Unreleased]` compares the latest tag to `HEAD`; each version links to the diff vs the one before it; the **oldest** version links to its tag (nothing earlier to compare). Keep the link out of the heading so the file reads cleanly.

---

## Workflow — Maintain Unreleased

As notable changes land, append them to `## [Unreleased]` under the right section. This is the default ongoing workflow.

## Workflow — Cut a Release

1. Confirm the new version with the user (or determine from the spec):
   - **MAJOR:** breaking changes
   - **MINOR:** new features, backward-compatible
   - **PATCH:** bug fixes only
2. Rename `## [Unreleased]` to `## [X.Y.Z] - YYYY-MM-DD` (heading **and** its link at the bottom).
3. Change the `[Unreleased]` link to compare the new tag against `HEAD`; add the new version's comparison link.
4. Add a fresh, empty `## [Unreleased]` section pointing at `HEAD`.
5. Get the date via `date +%Y-%m-%d` — never hardcode.

## Workflow — New Version Entry (no Unreleased section / backfill)

1. Read `CHANGELOG.md` to identify the last released version and its date.
2. Find commits since then: `git log --oneline <last-tag>..HEAD`. If no tag exists for the last version, use `git log --oneline` and filter manually.
3. Get today's date programmatically.
4. Determine the new version number (ask the user if not specified).
5. Group commits into Keep a Changelog sections (see mapping below), **curating**: fold several commits into one reader-facing entry where they form one change.
6. Prepend the new version block after the file header.
7. Add/update the comparison links at the bottom.
8. **Do NOT** remove or alter any existing version entries.

## Workflow — Restructure Entire CHANGELOG.md

1. Read the full file; note all version blocks and their dates.
2. Rewrite, preserving every version and date, enforcing: correct header, `Unreleased` section, consistent section names/order, comparison links at the bottom, consistent bullet style (capital letter, no trailing period).
3. Confirm dates via `date +%Y-%m-%d` where a version claims today.

---

## Section Rules

Use only these six sections, in this order when multiple are present. **Omit any empty section.**

| Section | When to use |
| :--- | :--- |
| **Added** | New features or capabilities |
| **Changed** | Changes to existing behavior |
| **Deprecated** | Features marked for future removal |
| **Removed** | Features removed in this release |
| **Fixed** | Bug fixes |
| **Security** | Security-related fixes or improvements |

**Fixed vs Changed — the decision rule:** was the old behavior a *bug*? If yes → `Fixed`. If it was intentional and you changed it → `Changed`.

**Dependencies are not a type of change.** A dependency update can be harmless, a fix, or breaking — describe its effect under the right type, or leave it out.

**Breaking changes** — mark with `**Breaking:**` at the start of the entry, *inside* its type (usually `Changed` or `Removed`), never a separate section:

```markdown
### Changed
- **Breaking:** `parse()` now returns a result object instead of raising.
- Rename the `color` option to `theme`.
```

**CVEs** — lead the entry with the CVE ID so readers and tools can match it:

```markdown
### Security
- CVE-2024-12345: out-of-bounds read when parsing malformed input.
```

**Deprecate before removing** — mark `Deprecated` in one release, `Removed` in a later one, and say which version will remove it.

**Yanked releases** — list, don't hide: `## [0.0.5] - 2014-12-13 [YANKED]`.

---

## Commit → Section Mapping Heuristics

This mapping assumes Conventional Commits messages produced by the `git-commiter` skill.

| Commit | Section |
| :--- | :--- |
| `feat:` / `add` / `new` | **Added** |
| `refactor:` / `change` / `rename` / `move` / `update` / `improve` | **Changed** |
| `fix:` / `bug` / `patch` | **Fixed** |
| `remove:` / `delete` / `drop` | **Removed** |
| `deprecate:` | **Deprecated** |
| `security:` / `cve` / `vuln` | **Security** |
| `docs:` / `chore:` / `ci:` / `test:` | *Omit unless user-facing* |

*When a commit is ambiguous, infer intent from the diff or file name. Remember: several commits often collapse into one entry — write for the reader, not the history.*

---

## Style Rules

- Write in English throughout.
- Each bullet: capital letter, present tense, no trailing period. *Example: `Add retry logic for HTTP requests`*
- Keep bullets concise — one line per entry where possible.
- Wrap code identifiers, file paths, and module names in backticks.
- Never guess dates — always retrieve the current date programmatically.
- When in doubt about plain wording, follow the `simple-english` skill.
