# Skills

Custom slash-command skills for Claude Code. Each `.md` file defines a skill that can be invoked as a slash command.

## Usage

To use a skill from this repo:
1. Symlink or copy the `.md` file into `~/.claude/commands/` (available globally) or `.claude/commands/` in a project (project-scoped)
2. Invoke with `/<skill-name>` in Claude Code

## Writing Skills

Skills are markdown files with an optional YAML frontmatter block. The body is the prompt that Claude receives when the skill is invoked.

### Frontmatter Fields
- `description` — One-line description (shown in skill list)
- `allowed-tools` — Tools the skill is allowed to use
- `model` — Model override for this skill

### Tips
- Be specific in your instructions — Claude follows them literally
- Include examples of expected input/output
- Use `$ARGUMENTS` to accept user input when invoking
- Test skills locally before committing
