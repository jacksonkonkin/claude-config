---
name: sync-github
description: "Sync GitHub issues and PRs into the user's Notion To-Do List. Use when the user says things like 'sync my github', 'pull in my issues', 'what's open on github', 'sync repos', 'update my tasks from github', or wants to see their GitHub work reflected in Notion. Also trigger when the user asks about open PRs, assigned issues, or review requests in the context of their task list."
---

# GitHub → Notion Sync

This skill pulls the user's GitHub issues and PRs into their Notion To-Do List database, so everything lives in one place. It uses the `gh` CLI for GitHub data and Notion MCP tools to create/update tasks.

## Workflow

### Step 1: Find the Notion Database

Search for the existing "To-Do List" database:

```
Use notion-search with query "To-Do List" to find the database.
```

If it doesn't exist, tell the user to run `/notion-todo` first to set it up, then come back.

Use `notion-fetch` on the database to get the `data_source_id`.

### Step 2: Fetch GitHub Data

Run `gh` CLI commands to pull the user's open work. Run these in parallel:

```bash
# Issues assigned to the user across all repos
gh search issues --assignee=@me --state=open --json repository,title,number,url,labels,createdAt,updatedAt --limit 50

# PRs authored by the user
gh search prs --author=@me --state=open --json repository,title,number,url,labels,createdAt,updatedAt,isDraft --limit 50

# PRs where the user is requested as a reviewer
gh search prs --review-requested=@me --state=open --json repository,title,number,url,labels,createdAt,updatedAt --limit 50
```

### Step 3: Check What's Already in Notion

Search the Notion database for items tagged "GitHub" to avoid creating duplicates:

```
Use notion-search with:
  query: "GitHub"
  data_source_url: "collection://<data-source-id>"
```

Compare results against the GitHub data. Match on the GitHub URL stored in the Notes field. Skip items that already exist and haven't changed.

### Step 4: Create New Notion Tasks

For each new GitHub item not already in Notion, create a task:

**For Issues:**
```
Use notion-create-pages with:
  parent: { data_source_id: "<the-data-source-id>" }
  pages: [{
    properties: {
      "Task": "[repo-name] #123: Issue title",
      "Tags": "Work",
      "Notes": "GitHub Issue\nURL: <github-url>\nRepo: <owner/repo>\nLabels: <labels if any>",
      "Done": "__NO__"
    }
  }]
```

**For authored PRs:**
```
properties: {
  "Task": "[repo-name] PR #123: PR title",
  "Tags": "Work",
  "Notes": "GitHub PR (author)\nURL: <github-url>\nRepo: <owner/repo>\nDraft: yes/no",
  "Done": "__NO__"
}
```

**For review requests:**
```
properties: {
  "Task": "Review: [repo-name] PR #123: PR title",
  "Tags": "Work",
  "Notes": "GitHub PR (review requested)\nURL: <github-url>\nRepo: <owner/repo>",
  "Done": "__NO__"
}
```

Batch all new items into a single `notion-create-pages` call when possible.

### Step 5: Mark Closed Items as Done

For items that are in Notion (tagged "GitHub") but no longer appear in the open GitHub results, mark them as done:

```
Use notion-update-page with:
  page_id: "<the page id>"
  command: "update_properties"
  properties: { "Done": "__YES__" }
```

This keeps the list clean — when you close an issue or merge a PR, it auto-resolves in Notion on next sync.

### Step 6: Report

Give the user a concise summary:

```
Synced GitHub → Notion:
- X new issues added
- X new PRs added
- X review requests added
- X items marked done (closed/merged)
- X items already up to date
```

## Filtering by Repo

If the user specifies a repo (e.g., "sync my github issues from myrepo"), filter the `gh` commands:

```bash
gh issue list --repo owner/repo --assignee=@me --state=open --json title,number,url,labels,createdAt --limit 50
```

## Selective Sync

If the user says something like "just sync my PRs" or "only issues", only run the relevant `gh` commands and skip the others.

## Tips

- **Always include the GitHub URL in Notes.** This is how we detect duplicates on future syncs and lets the user click through to GitHub.
- **Use `[repo-name]` prefix in task titles.** Makes it easy to scan and group by project.
- **Don't sync closed items as new tasks.** Only open issues/PRs should come in.
- **Review requests are high priority.** Consider mentioning if there are any when reporting, since someone is waiting.
- **Keep it fast.** Run gh commands in parallel, batch Notion writes, and keep the output brief.
