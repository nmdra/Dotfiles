---
name: plan-handoff
description: Execute an approved plan from .agents/plans/Plan.md in a fresh session. Use when handed an approved plan to implement.
---

The plan file `.agents/plans/Plan.md` is the source of truth — read it first.

## 1. Orient

- Read the plan file in full.
- Restate the goal and the task list briefly before you start.
- If the plan is missing or unclear, ask instead of guessing.

Done when you can state the goal and the task list.

## 2. Execute

- Work through the tasks in order. Update each task's checkbox
  (`- [ ]` → `- [x]`) in the plan file as it completes.
- Each task names its files, its test seam, and its verification —
  follow them.
- Keep the plan's decisions and scope; ask before changing either.

Done when every checkbox is ticked or every blocker has been raised.

## 3. Discipline

- Run typechecking regularly; run single test files regularly — follow the `tdd` skill for test-first tasks.
- Run the full test suite once at the end.
- Use /code-review before committing; commit to the current branch via the `git-commiter` skill.

## 4. Blockers

- When a task cannot be completed as written, stop and ask — do not
  silently improvise a different implementation.
- When all tasks are done, summarize what changed and the verification
  results.
