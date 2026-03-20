---
name: morning-planning
description: "Start your day with a structured planning session. Use when the user says 'morning planning', 'plan my day', 'what's on today', 'daily kickoff', 'start my day', or any morning routine request. Pulls from calendar, Notion tasks, and GitHub to build a focused plan for the day."
---

# Morning Planning Session

A cowork skill that kicks off your day by pulling context from all your tools and helping you build a focused plan.

## Step 1: Gather Context (Run in Parallel)

Pull data from all sources simultaneously:

### Calendar
```
Use gcal_list_events to get today's events:
  timeMin: today at 00:00 (ISO 8601)
  timeMax: today at 23:59 (ISO 8601)
  orderBy: startTime
  singleEvents: true
```

Also check tomorrow for anything that needs prep today.

### Notion Tasks
```
Use notion-search with:
  query: ""
  data_source_url: "collection://<data-source-id>"
```

Find the To-Do List database first, then search for:
- Tasks that are not Done
- Tasks with due dates today or overdue
- Tasks in active pipeline stages (Spec, Architecture, Implementation, Testing, Documentation)

### GitHub
Run these in parallel:
```bash
# PRs needing my review
gh search prs --review-requested=@me --state=open --json repository,title,number,url,updatedAt --limit 10

# My open PRs (check for reviews/comments)
gh search prs --author=@me --state=open --json repository,title,number,url,reviewDecision,updatedAt --limit 10

# Issues assigned to me
gh search issues --assignee=@me --state=open --json repository,title,number,url,updatedAt --limit 10
```

## Step 2: Present the Day at a Glance

Format everything into a scannable summary:

```
## Good morning! Here's your day:

### Calendar
- 9:00 AM — Team standup (30min)
- 11:00 AM — Design review (1hr)
- 2:00 PM — Focus time (blocked)
[X hours of meetings, Y hours of free time]

### Tasks Due Today
- [ ] Task 1 (due today)
- [ ] Task 2 (overdue — was due yesterday)

### Active Features
- "Feature X" — Implementation stage, branch: feature/x
- "Feature Y" — Spec stage, needs architecture

### GitHub Needs Attention
- 🔍 2 PRs waiting for your review
- ✅ PR #42 approved, ready to merge
- 💬 PR #38 has new comments

### Overdue / Stale
- Task from 3 days ago still in Backlog
```

## Step 3: Build the Plan

Based on the context, suggest a prioritized plan:

```
### Suggested Plan

1. **First thing** — Review PR #45 (someone's blocked on this)
2. **Before standup** — Merge PR #42 (already approved)
3. **After standup** — Continue "Feature X" implementation (in progress)
4. **Afternoon focus block** — Write spec for "Feature Y"
5. **End of day** — Respond to PR #38 comments

### Time Budget
- Meetings: 1.5 hrs
- Reviews: ~30 min
- Feature work: ~4 hrs
- Buffer: ~2 hrs
```

## Step 4: Interactive Planning

After presenting the plan, ask:

```
Want to adjust the plan? You can:
- Reprioritize ("move Feature Y spec to first thing")
- Add something ("I also need to do X today")
- Skip something ("push the PR review to tomorrow")
- Start working ("let's start with #1")
```

If the user says to start working, transition into the relevant skill:
- PR review → open the PR and start reviewing
- Feature work → run `/implement` or pick up where the architecture plan left off
- Spec writing → run `/write-spec`

## Step 5: Sync Back

After the plan is finalized:
- Update any Notion task due dates if things were rescheduled
- Optionally create calendar blocks for focus work

```
Use gcal_create_event to block focus time:
  summary: "Focus: <task name>"
  start: { dateTime: "<start>" }
  end: { dateTime: "<end>" }
```

## Tips

- **Keep the summary scannable.** Bullet points, not paragraphs. The user wants to see their day at a glance, not read an essay.
- **Highlight what needs attention.** Overdue tasks, PRs blocking others, and meetings that need prep should stand out.
- **Respect the user's energy.** Suggest deep work for focus blocks and lighter tasks around meetings.
- **Don't over-schedule.** Leave buffer time. A plan with zero slack is a plan that fails.
- **Be opinionated but flexible.** Suggest a plan, but accept changes without pushback.
