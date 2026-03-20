---
name: weekly-retro
description: "Run a weekly retrospective. Use when the user says 'weekly retro', 'week in review', 'what did I ship this week', 'weekly review', 'friday retro', or wants to review the week's work and plan ahead. Analyzes git history, merged PRs, completed tasks, and upcoming work."
---

# Weekly Retro

A structured weekly review that shows what shipped, what's in flight, and what to focus on next week.

## Step 1: Gather the Week's Data (Run in Parallel)

### Git Activity
```bash
# Commits this week across repos
git log --oneline --since="last monday" --author="$(git config user.name)"

# Files changed this week
git diff --stat HEAD~$(git rev-list --count --since="last monday" HEAD) HEAD 2>/dev/null || git diff --stat @{1.week.ago} HEAD
```

### GitHub
```bash
# PRs merged this week
gh search prs --author=@me --merged --json repository,title,number,url,mergedAt --limit 25

# PRs opened this week
gh search prs --author=@me --json repository,title,number,url,state,createdAt --limit 25

# Issues closed this week
gh search issues --assignee=@me --state=closed --json repository,title,number,url,closedAt --limit 25
```

Filter results to this week only (since last Monday).

### Notion Tasks
Search the To-Do List for:
- Tasks marked Done this week
- Tasks that changed Stage this week
- Tasks still in progress
- Overdue tasks

## Step 2: Generate the Retro

```
## Week in Review — [Date Range]

### Shipped
- PR #42: "Dark mode support" (my-app) — merged Tue
- PR #39: "Fix auth token refresh" (api-server) — merged Wed
- Completed: "User auth spec" → moved through full pipeline to Done

### In Progress
- "Feature X" — Implementation stage (3/5 steps done)
- PR #45 — open, awaiting review

### Metrics
- X commits across Y repos
- Z PRs merged, W issues closed
- N tasks completed in Notion

### Stale / Stuck
- "Old task" has been in Backlog for 2 weeks
- PR #38 has been open for 5 days with no review

### Next Week
Based on what's in progress and in the backlog:
1. Finish Feature X implementation
2. Write spec for Feature Y (next in backlog)
3. Clean up stale tasks
```

## Step 3: Discuss and Plan

```
Thoughts on the week? Anything to:
- Carry forward to next week?
- Deprioritize or drop?
- Add to the backlog?
```

If the user provides input, update Notion tasks accordingly (reprioritize, add new tasks, close stale ones).

## Step 4: Clean Up

Offer to:
- Close stale Notion tasks that are no longer relevant
- Archive completed branches
- Update due dates for carried-over work

## Tips

- **Celebrate wins.** Start with what shipped. It's motivating to see progress.
- **Be honest about stale work.** If something has been sitting for weeks, surface it — the user can decide to drop it or reprioritize.
- **Metrics should be descriptive, not judgmental.** "5 PRs merged" is useful context. Don't frame it as good or bad.
- **Next week suggestions should be concrete.** "Continue Feature X" with which specific steps, not just "keep working."
