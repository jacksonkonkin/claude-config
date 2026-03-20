---
name: document
description: "Write documentation for an implemented feature. Use when the user says 'document this', 'write docs', 'update the readme', 'add documentation', or when the feature pipeline reaches the documentation stage. Reviews the implementation and produces appropriate documentation."
---

# Feature Documentation

This skill writes documentation for a completed feature. It reads the spec, implementation, and tests to produce accurate docs that match what was actually built.

## Inputs

This skill can be invoked:
1. **From the pipeline** — receives task title, spec, architecture plan, repo, branch, and page_id from `/feature-pipeline`
2. **Directly by the user** — "document the dark mode feature"

If invoked directly, search Notion for the matching task and read its fields.

**Prerequisite:** The task should be in the Testing or Documentation stage with passing tests.

## Step 1: Setup

Navigate to the repo and switch to the feature branch:

```bash
cd <repo-path>
git checkout <branch-name>
```

Update Notion:
```
Use notion-update-page with:
  page_id: "<the page id>"
  command: "update_properties"
  properties: { "Stage": "Documentation" }
```

## Step 2: Analyze What Needs Documentation

Use the Explore agent to understand:
- What documentation already exists (README, docs/, wiki, JSDoc/docstrings)
- The project's documentation style and conventions
- What was changed in this feature branch

```bash
# See all changes in the branch
git diff main --stat
git diff main --name-only
```

Read the spec and architecture plan for context on what was built and why.

## Step 3: Write Documentation

Only write documentation that's appropriate for the project. Don't add docs where there aren't any — follow the existing pattern.

### README Updates (if the project has a README)
- Add the new feature to any feature lists
- Update usage examples if relevant
- Update configuration docs if new config was added

### Code Documentation
- Add docstrings/JSDoc to new public functions and classes
- Add inline comments only where logic is non-obvious
- Update any existing doc comments that are now outdated

### API Documentation (if applicable)
- Document new endpoints with request/response examples
- Update any API docs (Swagger, OpenAPI, etc.)

### Migration/Upgrade Guides (if there are breaking changes)
- What changed
- How to update
- Before/after examples

### Changelog (if the project maintains one)
- Add an entry following the existing format

```bash
# Commit docs
git add <doc-files>
git commit -m "docs(<scope>): add documentation for <feature>

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
git push origin <branch-name>
```

## Step 4: Update Notion

Mark the task as complete:

```
Use notion-update-page with:
  page_id: "<the page id>"
  command: "update_properties"
  properties: {
    "Stage": "Done",
    "Done": "__YES__"
  }
```

## Step 5: Report

```
Documentation complete for "[Task title]":
- [List of docs updated/created]
- Branch: <branch-name>
- PR: <pr-url> (updated with docs)

Feature pipeline complete. ✓
```

## Tips

- **Document what was built, not what was planned.** Read the actual code, not just the spec. If the implementation deviated from the spec, document the reality.
- **Less is more.** A concise, accurate paragraph beats a lengthy, vague page. Users read docs to solve problems — get to the point.
- **Examples are worth 1000 words.** Show usage examples, not just API signatures.
- **Don't add documentation infrastructure.** If the project doesn't have a docs/ folder, don't create one. Just update what exists.
