---
name: test-feature
description: "Generate and run tests for an implemented feature. Use when the user says 'test this', 'write tests', 'run tests', 'verify the feature', or when the feature pipeline reaches the testing stage. Analyzes the implementation and creates comprehensive tests, then runs them."
---

# Feature Testing

This skill generates and runs tests for a feature that's been implemented. It reads the spec and architecture plan to understand what needs testing, examines the implementation to write targeted tests, and runs everything to verify.

## Inputs

This skill can be invoked:
1. **From the pipeline** — receives task title, spec, architecture plan, repo, branch, and page_id from `/feature-pipeline`
2. **Directly by the user** — "test the dark mode feature"

If invoked directly, search Notion for the matching task and read its fields.

**Prerequisite:** The task must be in the Implementation or Testing stage with code on a branch.

## Step 1: Setup

Navigate to the repo and switch to the feature branch:

```bash
cd <repo-path>
git checkout <branch-name>
git pull origin <branch-name>
```

Update Notion:
```
Use notion-update-page with:
  page_id: "<the page id>"
  command: "update_properties"
  properties: { "Stage": "Testing" }
```

## Step 2: Analyze What Needs Testing

Read the Spec's **Acceptance Criteria** — each criterion should map to at least one test.

Read the Architecture Plan's **Test Strategy** — this outlines what types of tests are needed.

Use the Explore agent to understand:
- The testing framework and conventions in the project
- Where tests live (e.g., `__tests__/`, `*.test.ts`, `*_test.go`, `tests/`)
- How existing tests are structured (setup, assertions, mocking patterns)
- What the implementation actually did (read the changed files on the branch)

```bash
# See what files were changed in this branch
git diff main --name-only
```

## Step 3: Write Tests

Create tests following the project's existing patterns. Cover:

### Unit Tests
- Each new function/method gets at least one happy-path test and one edge-case test
- Test error handling paths
- Test boundary conditions

### Integration Tests
- Test that new components work with existing ones
- Test API endpoints end-to-end if applicable
- Test data flow through the system

### Based on Acceptance Criteria
- Each acceptance criterion from the spec gets a dedicated test
- These are the most important tests — they prove the feature works as specified

Write tests in the project's test files following its conventions:

```bash
# After writing tests, add and commit them
git add <test-files>
git commit -m "test(<scope>): add tests for <feature>

Covers acceptance criteria from spec.
Tests: unit (X), integration (Y)

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

## Step 4: Run Tests

```bash
# Run the full test suite
<test-command>
```

### If Tests Pass
Push the changes and move on:

```bash
git push origin <branch-name>
```

### If Tests Fail
1. **Analyze the failure** — is it a test bug or an implementation bug?
2. **Fix it** — if it's a test issue, fix the test. If it's an implementation issue, fix the code.
3. **Re-run tests** — verify the fix works
4. **Commit the fix** — separate commit for the fix

Retry up to 3 times. If tests still fail after 3 attempts, report to the user with the failure details and stop.

## Step 5: Report

```
Testing complete for "[Task title]":
- X tests written (Y unit, Z integration)
- All acceptance criteria covered:
  - ✓ [Criterion 1]
  - ✓ [Criterion 2]
- Full test suite: ✓ passing (N tests total)

Ready for documentation stage.
```

If there were issues:
```
Testing for "[Task title]" — needs attention:
- X tests written, Y passing, Z failing
- Failing tests:
  - test_name: [brief failure reason]
- [What was attempted to fix it]
- Recommendation: [what to do next]
```

## Tips

- **Match the project's test style exactly.** If they use describe/it blocks, use those. If they use test functions with table-driven tests, match that.
- **Don't over-mock.** If the project has test utilities or factories, use them. Mock at the boundaries (external APIs, databases) not in between internal modules.
- **Test behavior, not implementation.** "When user clicks toggle, theme changes" not "toggleTheme function sets state.theme to 'dark'".
- **Run the FULL test suite, not just new tests.** The feature might break existing functionality.
