---
name: generating-commit-messages
description: Generates clear commit messages from Git diffs. Use when writing commit messages or reviewing staged changes.
---

# Generating Commit Messages

## Instructions

1. Run `command git diff` to see changes that will be committed (or `command git diff --staged` if they have already been staged).
2. Suggest a commit message with:

- A subject of 72 characters or less in Conventional Commits format (eg. "docs: add migration notes" or "fix: avoid double-render in list component").
- A detailed description, wrapped to 72 characters, using basic Markdown syntax.

## Best practices

- Subjects should start with a type (eg. "docs", "fix", "feat", "chore" etc) following by a statement beginning with a verb (eg. "add", "remove", "rename" etc).
- Explain what and why, not how.
- Note alternatives which were considered but not implemented.
- Include references to previous commits or other artifacts (documentation, PRs) that are relevant.
