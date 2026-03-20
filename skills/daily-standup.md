---
name: daily-standup
description: "Run a quick daily standup. Use when the user says 'standup', 'daily standup', 'what did I do yesterday', 'what's my status', or wants a quick update on recent work and today's plan. Pulls from git history, Notion tasks, and GitHub activity."
---

# Daily Standup

A fast, structured standup that auto-generates your update from actual data — no memory required.

## Step 1: Gather Yesterday's Activity (Run in Parallel)

### Git History
```bash
# What was committed yesterday (across all local repos)
# Find repos the user works in
for repo in $(find ~/repos ~/Documents -maxdepth 3 -name ".git" -type d 2>/dev/null | head -20); do
  dir=$(dirname "$repo")
  name=$(basename "$dir")
  commits=$(git -C "$dir" log --oneline --after="yesterday 00:00" --before="today 00:00" --author="$(git config user.name)" 2>/dev/null)
  if [ -n "$commits" ]; then
    echo "### $name"
    echo "$commits"
  fi
done
```

If that's too broad, focus on the current repo:
```bash
git log --oneline --since="yesterday" --author="$(git config user.name)"
```

### GitHub Activity
```bash
# PRs merged yesterday
gh search prs --author=@me --merged --json repository,title,number,mergedAt --limit 10 | jq '[.[] | select(.mergedAt > "YESTERDAY_ISO")]'

# PRs reviewed yesterday
gh api search/issues -q '.items[] | "\(.repository_url | split("/") | .[-1]) #\(.number): \(.title)"' --method GET -f q="reviewed-by:@me is:pr updated:>YESTERDAY_ISO" 2>/dev/null || true
```

### Notion Tasks
Search for tasks completed yesterday or updated recently:
```
Use notion-search with query "" in the To-Do List database
```

Filter for items marked Done recently or with stage changes.

## Step 2: Generate the Standup

```
## Standup — [Today's Date]

### Yesterday
- Merged PR #42: "Add dark mode support" (my-app)
- 3 commits on feature/auth-refactor
- Reviewed PR #38 on shared-lib
- Completed: "Write auth spec" (moved to Architecture)

### Today
- Continue auth refactor (Implementation stage)
- Review PR #45 (requested)
- Team meeting at 11 AM

### Blockers
- None / Waiting on design review for Feature X
```

## Step 3: Ask if Anything's Missing

```
Anything to add or correct? Otherwise, want to copy this for Slack/standup?
```

If the user wants to share it, format it cleanly for copy-paste (plain text, no markdown tables).

## Tips

- **Auto-generate, don't interrogate.** The whole point is that the user doesn't have to remember what they did. Pull it from git, GitHub, and Notion.
- **Keep it to 3 sections max.** Yesterday, Today, Blockers. That's it.
- **Be brief.** Each bullet should be one line. This is a status update, not a report.
- **Infer blockers.** If a task has been in the same stage for 3+ days, mention it as a potential blocker.
