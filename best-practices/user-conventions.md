# User-Level Conventions

## Spec-Driven Development

All non-trivial features follow this workflow. Do not skip stages.

```
Backlog → Spec → Architecture → Implementation → Testing → Documentation → Done
```

### Rules

1. **Never implement without a spec.** If a task has no spec, write one first or ask the user to run `/write-spec`.
2. **Never implement without an architecture plan.** The plan maps spec requirements to file changes. Write one first or ask the user to run `/architect`.
3. **Specs and plans live in the repo** under `specs/` and `architecture/` directories (as committed markdown files), AND are mirrored to the Notion task's Spec/Architecture Plan fields.
4. **Each stage produces a durable artifact.** Specs, architecture plans, branches, PRs, and test results are all persisted — never just discussed in chat.
5. **Context must survive session boundaries.** When resuming work, read the spec and architecture plan files before doing anything. Do not rely on conversation history.

### Starting a new session on an in-progress feature

1. Check the Notion task for current Stage, Spec, Architecture Plan, Branch
2. Read the spec file in `specs/<feature-slug>.md`
3. Read the architecture plan in `architecture/<feature-slug>.md`
4. Check out the feature branch and read the git log to understand progress
5. Resume from where things left off

### Commit conventions

- Use conventional commits: `feat:`, `fix:`, `docs:`, `test:`, `refactor:`
- Reference the feature name in multi-step implementations
- One commit per logical step in the architecture plan

## Task Management

- Tasks are tracked in the Notion "To-Do List" database
- Use `/notion-todo` to manage tasks, `/sync-github` to pull in GitHub work
- Use `/feature-pipeline` to advance tasks through stages
- Pipeline stages map to Notion's Stage field: Backlog, Spec, Architecture, Implementation, Testing, Documentation, Done

## Code Quality

- Follow existing project patterns — don't introduce new paradigms
- Minimize blast radius — touch the fewest files possible
- Run build + tests after every significant change
- No placeholder code, no TODOs, no commented-out code in committed work

## Project Setup

- New projects should be initialized with `/new-project` to set up spec-driven dev structure
- Every project gets a project-level CLAUDE.md with stack-specific conventions
