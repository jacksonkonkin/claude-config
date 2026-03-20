---
name: implement
description: "Implement a feature based on an architecture plan. Use when the user says 'implement this', 'build it', 'write the code', 'start coding', or when the feature pipeline reaches the implementation stage. Takes an architecture plan and writes the actual code, creating a feature branch and committing changes."
---

# Feature Implementation

This skill takes an architecture plan and implements it — writing code, creating branches, and making commits. It works methodically through the implementation order defined in the plan.

## Inputs

This skill can be invoked:
1. **From the pipeline** — receives task title, spec, architecture plan, repo, and page_id from `/feature-pipeline`
2. **Directly by the user** — "implement the dark mode feature"

If invoked directly, search Notion for the matching task and read its Spec and Architecture Plan fields.

**Prerequisite:** The task must have an Architecture Plan. If empty, tell the user to run `/architect` first.

## Step 1: Setup

Navigate to the repo and prepare:

```bash
# Ensure we're on the latest main/master
cd <repo-path>
git checkout main && git pull origin main

# Create a feature branch
git checkout -b feature/<task-slug>
```

Update Notion with the branch name:
```
Use notion-update-page with:
  page_id: "<the page id>"
  command: "update_properties"
  properties: { "Branch": "feature/<task-slug>", "Stage": "Implementation" }
```

## Step 2: Implement

Follow the **Implementation Order** from the Architecture Plan. For each step:

1. **Read the relevant files** before making changes — understand what's there
2. **Write the code** using Edit/Write tools
3. **Verify it compiles/runs** — run the build command for the project

```bash
# Detect and run the appropriate build command
# Node: npm run build / yarn build / pnpm build
# Python: python -m py_compile <file>
# Go: go build ./...
# Rust: cargo build
```

4. **Commit after each logical step** with a clear message:

```bash
git add <specific-files>
git commit -m "feat(<scope>): <what this step accomplished>

Part of: <Task title>
Step X of Y from architecture plan

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

### Implementation Guidelines

- **Follow the architecture plan.** Don't deviate unless you discover the plan has an error — in that case, note the deviation and why.
- **Use existing patterns.** Match the coding style, naming conventions, and patterns already in the codebase.
- **Don't import new dependencies** unless the architecture plan explicitly called for them.
- **Handle errors properly.** Follow the project's error handling patterns.
- **Write clean, readable code.** No TODO comments, no commented-out code, no placeholder implementations.

## Step 3: Verify

After all implementation steps are complete:

```bash
# Run the build
<build-command>

# Run existing tests to make sure nothing is broken
<test-command>

# Run linting if available
<lint-command>
```

If anything fails, fix it before proceeding. Do not advance the stage with broken code.

## Step 4: Push and Create PR

```bash
git push -u origin feature/<task-slug>
```

Create a PR using `gh`:

```bash
gh pr create --title "feat: <Task title>" --body "$(cat <<'EOF'
## Summary
<Summary from the spec>

## Changes
<List of changes from the architecture plan, noting what was implemented>

## Test Plan
<From the architecture plan's test strategy>

## Notion Task
<Link or reference to the Notion item>

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

Update Notion with the PR URL:
```
Use notion-update-page with:
  page_id: "<the page id>"
  command: "update_properties"
  properties: { "PR URL": "<pr-url>" }
```

## Step 5: Report

```
Implementation complete for "[Task title]":
- Branch: feature/<task-slug>
- PR: <pr-url>
- X files changed, Y insertions, Z deletions
- Build: ✓ passing
- Existing tests: ✓ passing

Ready for testing stage.
```

## Tips

- **Commit frequently.** One commit per logical step in the plan. This makes review easier and rollback possible.
- **Don't gold-plate.** Implement exactly what the spec and plan call for. No extra features, no bonus refactoring.
- **If you hit a blocker, stop.** Don't hack around it. Report it and let the user (or the pipeline) decide how to proceed.
- **Check the build after every major change.** Catching errors early is much cheaper than debugging a pile of changes at the end.
