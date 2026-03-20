# Project: claude-config

Shared Claude Code workflows, skills, agents, commands, and best practices. A living repo of configuration and collaboration patterns for Claude Code.

## Structure

```
skills/            — Custom slash-command skills (.md files)
agents/            — Agent definitions and configurations
commands/          — Reusable command patterns and snippets
best-practices/    — Guides and conventions for using Claude Code effectively
cowork/            — Cowork session skills and patterns
recurring-convos/  — Templates for recurring conversation workflows
specs/             — Feature specifications (spec-driven dev)
architecture/      — Implementation plans (spec-driven dev)
```

## How This Repo Works

This is a **configuration and knowledge repo**, not an application. The "code" here is:
- **Skill files** (markdown with frontmatter) that define custom slash commands
- **Agent configs** that define specialized agent behaviors
- **Best practice docs** that capture what works well with Claude Code
- **Templates** for common workflows and recurring sessions

## Sharing

To use these configs:
1. Clone this repo
2. Symlink or copy skill files into `~/.claude/commands/` (user-level) or `.claude/commands/` (project-level)
3. Reference agent configs from your project's CLAUDE.md or settings

To share with friends:
- They clone the repo and pick what they want
- Or add this repo as a git submodule in their projects

## Development Workflow

This project uses spec-driven development for non-trivial additions:

```
Spec → Architecture → Implementation → Testing → Documentation
```

- Specs live in `specs/<feature-slug>.md`
- Architecture plans live in `architecture/<feature-slug>.md`
- Use `/feature-pipeline` to advance features through stages

## Conventions

- Skill files use `.md` extension with YAML frontmatter
- One skill per file, named descriptively (e.g., `review-pr.md`, `daily-standup.md`)
- Best practices docs should be actionable — examples over theory
- Keep configs portable — avoid hardcoded paths; use `~` or relative paths
- Tag skills and agents with categories in their frontmatter for discoverability

## Quick Reference

- **Add a skill:** Create a `.md` file in `skills/` with proper frontmatter
- **Add an agent:** Create a config in `agents/` following the agent template
- **Add a best practice:** Write a guide in `best-practices/`
- **Test a skill locally:** Symlink into `~/.claude/commands/` and invoke with `/skill-name`
