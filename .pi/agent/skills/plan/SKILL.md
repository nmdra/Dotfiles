---
name: plan
description: Create a concise, evidence-backed implementation plan and save it to .agents/plans/Plan.md. Use when the user asks to plan a feature or task.
---

The plan file is `.agents/plans/Plan.md`: a record of decisions and executable tasks.

## 1. Understand the request

Restate the goal in your own words; ask when the intent is ambiguous or a trade-off matters. When the direction itself is unsettled, run a `grilling` session first to settle it. Read the repository instructions (AGENTS.md, README, docs) and any existing plans in `.agents/plans/`.

Done when the goal is restated and no ambiguity that could change the plan is left unasked.

## 2. Research

- Inspect the code, tests, schemas, and configuration the task would change; trace the current behavior through real entry points.
- Use web search for external knowledge — library or API behavior, version compatibility, security guidance, community best practice. Fetch the authoritative source.
- Use subagents for wide or parallel exploration — a large or unfamiliar codebase, many candidate locations, independent concerns. Dispatch one read-only subagent per area; demand evidence with `file:line` references.
- Follow every claim back to the source that owns it — primary sources (code, official docs, specs), not secondary write-ups. Record facts separately from proposals.

Done when the current behavior is traced and every claim the plan will make carries a citation (`file:line` for code, URL for web).

## 3. Draft the plan

Use only sections that carry information:

```markdown
# Plan: [Feature]

## Goal

What outcome changes, for whom, and why.

## Current State

Relevant behavior, entry points, constraints, and evidence, with
citations (file:line or URL).

## Decisions

Each decision: the choice, the alternatives considered, and why they were
rejected. Decisions describe contracts and intent, not file paths — they
must stay true as the code moves.

## Scope

In scope. Intentionally out of scope.

## Tasks

Ordered, bite-sized tasks with checkboxes. Each task:

- Names the files it touches (`**Files:**`).
- Names the seam at which its tests hook in (`**Seam:**`) — prefer an
  existing seam, and the highest one possible.
- Gives a way to verify it (`**Verify:**` command or check).

- [ ] Task 1: ... (**Seam:** ...; **Files:** ...; **Verify:** ...)
- [ ] Task 2: ...

## Verification

Focused checks and observable acceptance criteria.

## Open Questions

Only unresolved decisions that can change the plan.
```

Rules:

- Name concrete files and symbols only where evidence supports them.
- No placeholders: "TBD", "implement later", or "add error handling"
  without specifics are plan failures. Each task must be executable from
  the plan alone.

Done when the self-review passes — every goal maps to at least one task,
names, signatures, and paths are consistent across tasks, and no
placeholder remains. Fix issues inline.

## 4. Save

Write the final plan to `.agents/plans/Plan.md` with the write tool. If
the file exists and the new plan supersedes the old one, overwrite it;
otherwise, ask the user for a filename.

Done when the plan is saved. End your turn with a short summary and the
file path.
