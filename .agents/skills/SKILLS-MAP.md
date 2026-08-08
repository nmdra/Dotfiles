# Skills Interconnection Map

How the installed skills call each other. Arrow = one skill references or feeds another.
(Reference names are the skills' `name:` values, e.g. `git-commiter`.)

## Execution chain (feature work)

```
                     ┌────────────┐
                     │  grilling  │  stress-test direction/decisions
                     └─────┬──────┘
                           │ settled decisions
                     ┌─────▼──────┐
                     │    plan    │  writes .agents/plans/Plan.md
                     └─────┬──────┘
                           │ approved plan
                     ┌─────▼───────────┐   ┌───────────┐ (user-invoked)
                     │  plan-handoff   │◄──│ implement │  orchestrates spec/tickets
                     └──┬──────┬───────┘   └───────────┘
                        │      │                │
              ┌─────────▼┐  ┌──▼────────┐      │
              │   tdd    │  │ code-review│      │
              └─────────┘  └──┬────────┘      │
                              │ findings fixed │
                     ┌────────▼────────┐      │
                     │  git-commiter   │◄─────┘
                     └───┬─────────┬───┘
                         │         │
              ┌──────────▼─┐   ┌───▼──────────────────┐
              │ keep-a-    │   │ resolving-merge-     │
              │ changelog  │   │ conflicts            │
              └─────┬──────┘   └──────────────────────┘
                    │
              ┌─────▼──────────┐
              │ simple-english │
              └────────────────┘
```

## Skill-craft cluster

```
skill-creator ⇄ writing-for-agents
```

## Edges (with reason)

| From | To | Why |
| ------ | ---- | ----- |
| `grilling` | `plan` | Settled decisions become an executable plan |
| `plan` | `grilling` | Unsettled direction → stress-test before planning |
| `plan` | `plan-handoff` | Plan.md is the handoff artifact |
| `implement` | `tdd`, `plan-handoff`, `code-review` | Orchestrates: TDD at seams, discipline, review |
| `plan-handoff` | `tdd` | Test-first tasks follow the red-green loop |
| `plan-handoff` | `code-review` | Review before commit |
| `plan-handoff` | `git-commiter` | Commit discipline (message + safety rules) |
| `tdd` | `code-review` | Refactoring belongs to the review stage |
| `code-review` | `git-commiter` | Commit once findings are addressed |
| `git-commiter` | `keep-a-changelog` | Changelog-worthy types (feat/fix/security/perf) feed section mapping |
| `git-commiter` | `resolving-merge-conflicts` | Hard-stops on conflict markers route to resolution |
| `resolving-merge-conflicts` | `git-commiter` | Finish merge → commit via commiter |
| `keep-a-changelog` | `git-commiter` | Section mapping assumes Conventional Commits |
| `keep-a-changelog` | `simple-english` | Plain language for readers |
| `skill-creator` | `writing-for-agents` | Skill writing craft, frontmatter, triggering |
| `writing-for-agents` | `skill-creator` | Create → evaluate → iterate workflow |

## Standalone skills (no edges)

`teach`, `notebrain-assistant`, `graphify`, `pi-lens-ast-grep`, `pi-lens-lsp-navigation`,
`pi-lens-write-ast-grep-rule`, `pi-lens-write-tree-sitter-rule`
