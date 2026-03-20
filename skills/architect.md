---
name: architect
description: "Design an implementation plan for a feature. Use when the user says 'architect this', 'design the implementation', 'plan this out', 'how should we build this', or when the feature pipeline needs architecture. Takes a spec and produces a detailed implementation plan with file changes, dependencies, and ordering."
---

# Architecture & Implementation Planning

This skill takes a feature spec and the target codebase, then produces a detailed implementation plan. It explores the codebase deeply to design a solution that fits the existing architecture.

## Inputs

This skill can be invoked:
1. **From the pipeline** — receives task title, spec, repo, and page_id from `/feature-pipeline`
2. **Directly by the user** — "architect the dark mode feature"

If invoked directly, search Notion for the matching task and read its Spec field.

**Prerequisite:** The task must have a Spec. If the Spec field is empty, tell the user to run `/write-spec` first.

## Step 1: Deep Codebase Exploration

Navigate to the repo and use the Explore agent (subagent_type=Explore) to thoroughly understand:

1. **Project structure** — directory layout, module organization, build system
2. **Tech stack** — frameworks, libraries, language version, key dependencies
3. **Existing patterns** — how similar features are implemented, coding conventions
4. **Affected files** — which files need to change based on the spec
5. **Integration points** — APIs, database schemas, shared state, event systems
6. **Test infrastructure** — how tests are structured, what testing frameworks are used

Run multiple Explore agents in parallel for speed:
- One for understanding the overall architecture
- One for finding files related to the specific feature area
- One for understanding the test setup

## Step 2: Design the Architecture

Based on the spec and codebase exploration, produce an implementation plan:

```markdown
## Architecture Plan: [Feature Title]

### Approach
[1-2 paragraph summary of the implementation strategy and key design decisions]

### File Changes

#### New Files
1. `path/to/new/file.ts` — [Purpose]
   - [Key contents/exports]

#### Modified Files
1. `path/to/existing/file.ts` — [What changes and why]
   - [Specific modifications]
2. `path/to/another/file.ts` — [What changes and why]
   - [Specific modifications]

### Dependencies
- [Any new packages needed, with versions]
- [Any internal modules to leverage]

### Data Model Changes
- [Database migrations, schema changes, new types/interfaces]

### Implementation Order
1. [First thing to implement — usually data model / types]
2. [Second — usually core logic]
3. [Third — usually integration / UI]
4. [Fourth — usually tests]
5. [Fifth — usually docs]

[Each step should note which files it touches and any dependencies on prior steps]

### Risks & Considerations
- [Potential issues, edge cases, or things that need careful handling]
- [Breaking changes or migration concerns]
- [Performance implications]

### Test Strategy
- [Unit tests needed]
- [Integration tests needed]
- [Manual testing steps if applicable]
```

## Step 3: Save to Notion

Update the Notion item with the plan:

```
Use notion-update-page with:
  page_id: "<the page id>"
  command: "update_properties"
  properties: {
    "Architecture Plan": "<the full plan markdown>",
    "Stage": "Architecture"
  }
```

## Step 4: Report

Show the plan to the user. If in step-by-step mode:

```
Architecture plan ready for "[Task title]":

[Plan content]

Ready to implement? Any changes to the plan?
```

If in full-auto mode:
```
Architecture ✓ for "[Task title]" — [1-line summary of approach]. Moving to implementation.
```

## Tips

- **Follow existing patterns.** If the codebase uses a repository pattern, don't introduce direct database calls. If they use Redux, don't add MobX. Match what's there.
- **Minimize blast radius.** The best implementation plan touches the fewest files while still being clean. Don't reorganize the codebase as part of a feature.
- **Order matters.** The implementation order should let you build and test incrementally. Don't save all testing for the end.
- **Be specific about file paths.** "Update the component" is useless. "`src/components/Settings/ThemeToggle.tsx` — new component, renders toggle switch, dispatches theme change action" is useful.
- **Call out decisions.** If there are multiple valid approaches, briefly explain why you chose one over the other. This helps the user understand and override if needed.
