---
name: feature-pipeline
description: "Orchestrate the full feature development pipeline from Notion. Use when the user says 'run the pipeline', 'process my features', 'work on my backlog', 'start the pipeline', 'run features', or wants to advance feature tasks through stages. This is the main entry point for the automated dev workflow that takes features from request through spec, architecture, implementation, testing, and documentation."
---

# Feature Development Pipeline

This skill orchestrates the full feature development lifecycle, driven by your Notion To-Do List. Each feature task moves through stages: **Backlog → Spec → Architecture → Implementation → Testing → Documentation → Done**.

## Execution Modes

The user controls how much autonomy the pipeline has. Parse their intent:

- **Full auto**: "run the pipeline", "process everything", "go full auto" — run all stages back-to-back without stopping.
- **Step-by-step**: "step through", "one at a time", "pause between stages" — run one stage, report, wait for approval before advancing.
- **Custom**: "run spec and architecture", "just implement and test", "go through implementation then stop" — run only the specified stages, in order.
- **Default** (no mode specified): Step-by-step. Always default to this if unclear.

## Step 1: Load the Notion Database

```
Use notion-search with query "To-Do List" to find the database.
Use notion-fetch on the result to get the data_source_id.
```

## Step 2: Find Pipeline Tasks

Search for tasks that have a Stage set and are not Done:

```
Use notion-search with:
  query: ""
  data_source_url: "collection://<data-source-id>"
```

Filter results to items where:
- "Done" is not checked
- "Stage" is set (has a pipeline stage)
- Prioritize by: items the user specifically mentioned > items with due dates sooner > items in later stages (closer to done)

If the user mentioned a specific task, only process that one. Otherwise, show the list and ask which to work on (unless in full-auto mode, in which case process all eligible tasks in priority order).

## Step 3: Determine the Repo

For each task, read the "Repo" field. This tells you which GitHub repo to work in.

- If "Repo" is set (e.g., "owner/repo"), clone or navigate to that repo.
- If "Repo" is empty, ask the user which repo this feature belongs to, then update the Notion item.

To work in the repo:
```bash
# Check if repo is already cloned locally
find ~ -maxdepth 4 -name ".git" -type d 2>/dev/null | xargs -I {} dirname {} | xargs -I {} sh -c 'cd "{}" && git remote get-url origin 2>/dev/null' | grep "owner/repo"

# If not found, clone it
gh repo clone owner/repo ~/repos/repo-name
```

## Step 4: Execute the Current Stage

Based on the task's current "Stage", invoke the corresponding skill:

| Stage | Action |
|---|---|
| Backlog | Advance to Spec → run `/write-spec` |
| Spec | Run `/write-spec` if spec is empty, otherwise advance to Architecture → run `/architect` |
| Architecture | Run `/architect` if plan is empty, otherwise advance to Implementation → run `/implement` |
| Implementation | Run `/implement` |
| Testing | Run `/test-feature` |
| Documentation | Run `/document` |

Pass the task details (Task title, Spec, Architecture Plan, Repo, Branch, page_id) to each skill.

## Step 5: Update Notion After Each Stage

After each stage completes successfully, update the Notion item:

```
Use notion-update-page with:
  page_id: "<the page id>"
  command: "update_properties"
  properties: {
    "Stage": "<next stage>",
    "Spec": "<spec content if just written>",
    "Architecture Plan": "<plan if just written>",
    "Branch": "<branch name if just created>",
    "PR URL": "<pr url if just created>"
  }
```

## Step 6: Control Flow

**Step-by-step mode:**
After completing a stage, report what was done and ask:
```
Completed [Stage] for "[Task title]".
[Brief summary of what was produced]

Next stage: [Next Stage]. Continue? (y/n/skip to [stage])
```

**Full-auto mode:**
After completing a stage, immediately proceed to the next. Only stop if:
- An error occurs
- Tests fail
- The spec or architecture needs user input (ambiguous requirements)

Report progress as you go:
```
[Task title]: Spec ✓ → Architecture ✓ → Implementation ✓ → Testing...
```

**Custom mode:**
Run only the stages the user requested, in order. Stop after the last requested stage.

## Step 7: Final Report

When all requested work is complete, summarize:

```
Pipeline complete:
- "[Task 1]": Spec → Architecture → Implementation ✓ (branch: feature/task-1, PR: #42)
- "[Task 2]": Spec ✓ (ready for architecture review)
```

## Error Handling

- If a stage fails, do NOT advance the stage in Notion. Report the error and ask the user how to proceed.
- If tests fail during Testing, stay in Testing stage. Report failures and attempt fixes (up to 3 attempts) before escalating to the user.
- If the repo can't be found or cloned, ask the user for the correct repo path.

## Tips

- **Always read the full Notion item before starting.** The Spec and Architecture Plan fields contain context from prior stages.
- **Create feature branches early.** During Implementation, create a branch named `feature/<task-slug>` and track it in Notion.
- **Don't skip stages.** Even in full-auto, each stage builds on the last. A bad spec leads to a bad architecture leads to bad code.
- **Respect the user's mode choice.** If they said step-by-step, don't auto-advance. If they said full-auto, don't ask for confirmation at every step.
