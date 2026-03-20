---
name: code-review-partner
description: "Pair on code reviews together. Use when the user says 'review PRs', 'code review', 'let's review', 'check my PRs', 'review session', or wants to batch-review open pull requests. Fetches open PRs and walks through them interactively."
---

# Code Review Partner

A cowork session for reviewing pull requests together. Fetches your open review requests and walks through each one, discussing changes and leaving feedback.

## Step 1: Find PRs to Review

```bash
# PRs where review is requested
gh search prs --review-requested=@me --state=open --json repository,title,number,url,author,createdAt,additions,deletions --limit 20

# Also check your own PRs for feedback received
gh search prs --author=@me --state=open --json repository,title,number,url,reviewDecision,updatedAt --limit 10
```

## Step 2: Present the Queue

```
## Review Queue

### Needs Your Review
1. **my-app #45**: "Add dark mode toggle" by @teammate (3 files, +120/-30) — opened 2 days ago
2. **api-server #22**: "Refactor auth middleware" by @other (8 files, +340/-200) — opened today

### Your PRs with Updates
3. **my-app #42**: "Fix token refresh" — changes requested by @reviewer
4. **shared-lib #18**: "Update types" — approved, ready to merge

Which one do you want to start with? Or say "all" to go through the queue.
```

## Step 3: Review Each PR

For each PR the user wants to review:

### Fetch the Diff
```bash
gh pr view <number> --repo <owner/repo> --json title,body,files,additions,deletions,commits
gh pr diff <number> --repo <owner/repo>
```

### Analyze the Changes
Read through the diff and provide:

```
## PR #45: "Add dark mode toggle"

### Summary
[What this PR does in 1-2 sentences, based on the diff not just the description]

### Key Changes
- `src/components/ThemeToggle.tsx` — New component, renders toggle switch
- `src/hooks/useTheme.ts` — New hook, manages theme state in localStorage
- `src/App.tsx` — Wraps app in ThemeProvider

### Observations
- ✅ Clean component structure, follows existing patterns
- ✅ Persists preference in localStorage
- ⚠️ No loading state — might flash wrong theme on page load
- ⚠️ Missing test for ThemeToggle component
- 💡 Consider using CSS custom properties instead of inline styles for theme values

### Suggested Comments
1. **src/hooks/useTheme.ts:15** — The initial state reads from localStorage synchronously, which is fine, but `useLayoutEffect` instead of `useEffect` on line 20 would prevent the theme flash.
2. **src/App.tsx:8** — Minor: the ThemeProvider could be extracted to its own file to keep App.tsx focused on routing.
```

### Ask for Input
```
Want to:
- Leave these comments on the PR?
- Approve / Request changes / Just comment?
- Skip to the next PR?
- Discuss any of these points further?
```

If the user wants to leave comments:
```bash
gh pr review <number> --repo <owner/repo> --comment --body "Review comments..."
# or
gh pr review <number> --repo <owner/repo> --approve --body "LGTM! One minor suggestion..."
# or
gh pr review <number> --repo <owner/repo> --request-changes --body "A few things to address..."
```

## Step 4: Handle Your Own PRs

For PRs where you received feedback:

```bash
gh pr view <number> --repo <owner/repo> --comments
```

Summarize the feedback and suggest responses or code changes:

```
## Your PR #42: "Fix token refresh"

### Feedback from @reviewer
- Requested change: "Add retry logic for failed refresh attempts"
- Comment: "Consider using exponential backoff"

### Suggested Fix
[Code suggestion based on the feedback]

Want me to implement this fix on the branch?
```

## Step 5: Wrap Up

```
## Review Session Complete

- Reviewed: 2 PRs
- Approved: #45 (with suggestions)
- Requested changes: #22 (missing error handling)
- Your PRs: addressed feedback on #42, merged #18

Anything else to review?
```

## Tips

- **Read the full diff, not just the description.** PR descriptions can be incomplete or misleading.
- **Be constructive.** Frame issues as suggestions, not demands. "Consider using X" not "This is wrong."
- **Prioritize by impact.** Security issues > bugs > performance > style. Don't nitpick formatting if there's a real bug.
- **Batch small PRs.** If there are several small PRs, offer to quick-approve them all at once.
- **Ask before posting comments.** Always show the user what you'd comment before actually posting it.
