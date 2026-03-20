---
name: write-spec
description: "Write a specification for a feature or task. Use when the user says 'write a spec', 'spec this out', 'define requirements', 'flesh out this feature', or when the feature pipeline needs a spec written. Takes a feature request and produces a clear, actionable specification document."
---

# Write Feature Specification

This skill takes a feature request (from Notion or the user directly) and produces a clear, actionable spec. The spec is written back to the Notion item's "Spec" field and also output to the user for review.

## Inputs

This skill can be invoked:
1. **From the pipeline** — receives task title, notes, repo, and page_id from `/feature-pipeline`
2. **Directly by the user** — "spec out dark mode support for my-app"

If invoked directly, search Notion for the matching task or create a new one.

## Step 1: Gather Context

### From the Notion item:
- Task title and Notes field (the raw feature request)
- Repo field (which codebase this targets)

### From the codebase (if Repo is set):
Navigate to the repo and explore:

```bash
# Understand the project structure
ls -la
cat README.md 2>/dev/null | head -100
```

Use the Explore agent to understand:
- What tech stack is used
- What existing patterns exist for similar features
- What files/modules would be affected
- Any existing tests or documentation patterns

### From the user:
If the feature request is vague, ask **at most 3 clarifying questions**. Focus on:
- What is the expected behavior from the user's perspective?
- Are there any constraints (performance, compatibility, etc.)?
- What's out of scope?

If the request is clear enough to spec without questions, skip straight to writing.

## Step 2: Write the Spec

Produce a spec in this format:

```markdown
## Feature: [Title]

### Summary
[1-2 sentence description of what this feature does and why]

### User Stories
- As a [user type], I want [action] so that [benefit]
- ...

### Requirements
1. [Functional requirement]
2. [Functional requirement]
...

### Technical Considerations
- [Relevant architecture notes from codebase exploration]
- [Dependencies or integrations needed]
- [Performance considerations if any]

### Out of Scope
- [What this feature explicitly does NOT include]

### Acceptance Criteria
- [ ] [Testable criterion]
- [ ] [Testable criterion]
...
```

Keep it concise. A spec should be 1-2 pages, not a novel. Focus on clarity and testability.

## Step 3: Save to Notion

Update the Notion item with the spec:

```
Use notion-update-page with:
  page_id: "<the page id>"
  command: "update_properties"
  properties: {
    "Spec": "<the full spec markdown>",
    "Stage": "Spec"
  }
```

## Step 4: Report

Show the spec to the user. If in step-by-step mode (default), ask for feedback:

```
Spec written for "[Task title]". Here's what I've defined:

[Spec content]

Want to adjust anything before moving to architecture?
```

If in full-auto mode, just confirm and move on:
```
Spec ✓ for "[Task title]" — [1-line summary]. Moving to architecture.
```

## Tips

- **Don't over-spec.** The goal is to give the architect enough to design a solution, not to prescribe every implementation detail.
- **Ground it in the codebase.** If you explored the repo, reference real files and patterns. "This should follow the same pattern as `src/components/Settings.tsx`" is more useful than abstract descriptions.
- **Acceptance criteria must be testable.** "Works well" is not a criterion. "User can toggle dark mode and the theme persists across page reloads" is.
- **Flag unknowns.** If something needs research or a decision from the user, call it out explicitly rather than guessing.
