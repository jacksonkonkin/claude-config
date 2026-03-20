---
name: scaffold-project
description: "Initialize a new project with spec-driven development structure. Use when the user says 'init project', 'new project', 'set up a project', 'bootstrap', 'scaffold', or wants to create a new project with full spec-driven dev capabilities. Sets up directory structure, project CLAUDE.md, and optionally a Notion task board."
---

# Initialize Spec-Driven Project

This skill sets up a new project (or retrofits an existing one) with the full spec-driven development workflow — directory structure, project-level CLAUDE.md, and Notion integration.

## Inputs

Parse from the user's message:
- **Project name** (required) — the name/slug for the project
- **Repo path** (optional) — where the project lives. If not given, use current directory or `~/repos/<project-name>`
- **Tech stack** (optional) — e.g., "Next.js + TypeScript", "Python FastAPI", "Go CLI". If not given, detect from existing files or ask.
- **Description** (optional) — what this project does

## Step 1: Create or Navigate to the Repo

If creating a new project:
```bash
mkdir -p ~/repos/<project-name>
cd ~/repos/<project-name>
git init
```

If retrofitting an existing project:
```bash
cd <repo-path>
```

## Step 2: Detect the Tech Stack

If not provided, explore the project to detect:
```bash
# Check for common project files
ls package.json Cargo.toml go.mod pyproject.toml requirements.txt Makefile 2>/dev/null
cat package.json 2>/dev/null | head -30
cat README.md 2>/dev/null | head -50
```

Use the Explore agent if the project is complex — understand the frameworks, build tools, test setup, and key directories.

## Step 3: Create the Spec-Driven Directory Structure

```bash
mkdir -p specs
mkdir -p architecture
```

Create a README for each:

**specs/README.md:**
```markdown
# Feature Specs

This directory contains feature specifications. Each spec defines **what** a feature does and **why**, without prescribing implementation details.

## Naming Convention
`<feature-slug>.md` — e.g., `dark-mode.md`, `user-auth.md`

## Template
Use `/write-spec` to generate specs, or follow the template in `_template.md`.
```

**architecture/README.md:**
```markdown
# Architecture Plans

This directory contains implementation plans for features. Each plan maps a spec to specific file changes, dependencies, and implementation order.

## Naming Convention
`<feature-slug>.md` — matches the spec filename

## Template
Use `/architect` to generate plans, or follow the template in `_template.md`.
```

**specs/_template.md:**
```markdown
## Feature: [Title]

### Summary
[1-2 sentence description of what this feature does and why]

### User Stories
- As a [user type], I want [action] so that [benefit]

### Requirements
1. [Functional requirement]

### Technical Considerations
- [Relevant architecture notes]

### Out of Scope
- [What this feature explicitly does NOT include]

### Acceptance Criteria
- [ ] [Testable criterion]
```

**architecture/_template.md:**
```markdown
## Architecture Plan: [Feature Title]

### Approach
[1-2 paragraph summary of implementation strategy]

### File Changes

#### New Files
1. `path/to/file` — [Purpose]

#### Modified Files
1. `path/to/file` — [What changes and why]

### Dependencies
- [New packages needed]

### Implementation Order
1. [Step 1 — what to do and which files]
2. [Step 2]

### Test Strategy
- [Unit tests]
- [Integration tests]
```

## Step 4: Generate the Project-Level CLAUDE.md

Create a `CLAUDE.md` at the project root, tailored to the detected/specified tech stack.

The CLAUDE.md should include:

```markdown
# Project: <project-name>

<one-line description>

## Tech Stack
- <detected or specified stack details>

## Quick Reference
- **Build:** `<build command>`
- **Test:** `<test command>`
- **Lint:** `<lint command>`
- **Dev server:** `<dev command>`

## Architecture Overview
<Brief description of project structure — key directories and their purpose>

## Development Workflow

This project uses spec-driven development. All features follow:

```
Spec → Architecture → Implementation → Testing → Documentation
```

- Specs live in `specs/<feature-slug>.md`
- Architecture plans live in `architecture/<feature-slug>.md`
- Use `/feature-pipeline` to advance features through stages

### Starting work on a feature
1. Read the spec in `specs/`
2. Read the architecture plan in `architecture/`
3. Check out the feature branch
4. Follow the implementation order in the plan

## Conventions
<Stack-specific conventions detected from the codebase — e.g., component patterns, API structure, state management approach, naming conventions>

## Key Files
<Important files for understanding the project — entry points, config, routing, etc.>
```

**Tailor this to the stack.** For example:
- **Next.js**: Include App Router vs Pages Router, server vs client components, data fetching patterns
- **Python**: Include virtual env setup, package manager (pip/poetry/uv), type checking setup
- **Go**: Include module structure, build tags, key interfaces
- **Rust**: Include workspace structure, feature flags, key traits

## Step 5: Set Up Notion Integration (Optional)

Ask the user: "Want me to create a Notion task for this project setup?"

If yes:
```
Use notion-create-pages to create a task:
  Task: "Set up <project-name>"
  Tags: "Work"
  Repo: "<owner/repo>"
  Stage: "Done"
  Done: "__YES__"
  Notes: "Initial project setup with spec-driven dev structure"
```

Also ask: "Want me to add any initial feature ideas to the backlog?"

If they provide ideas, create Notion tasks for each at the Backlog stage with the repo pre-filled.

## Step 6: Initial Commit

Stage and commit the scaffolding:

```bash
git add CLAUDE.md specs/ architecture/
git commit -m "chore: initialize spec-driven development structure

Adds:
- CLAUDE.md with project conventions and workflow
- specs/ directory with template for feature specifications
- architecture/ directory with template for implementation plans

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

## Step 7: Report

```
Project "<project-name>" initialized with spec-driven dev:

Structure:
  CLAUDE.md          — project conventions (tailored to <stack>)
  specs/             — feature specifications
  architecture/      — implementation plans

Workflow:
  /write-spec    → define what to build
  /architect     → plan how to build it
  /implement     → write the code
  /test-feature  → verify it works
  /document      — write the docs

Ready to start? Run `/write-spec` with your first feature idea.
```

## Tips

- **Don't over-scaffold.** Only create the directories and files above. Don't generate boilerplate app code — that's what `/implement` is for.
- **Make the CLAUDE.md genuinely useful.** It should contain things Claude needs to know that aren't obvious from reading the code — build commands, conventions, architecture decisions.
- **Detect, don't assume.** Read the existing project before generating the CLAUDE.md. A React project with Zustand needs different conventions than one with Redux.
- **Keep it lightweight for new projects.** If there's no code yet, the CLAUDE.md can be sparse. It'll grow as features are built.
