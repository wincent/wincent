---
name: snippet
description: Export the current session as a GitLab snippet. Use when the user asks to "create a snippet", "share session", "export to GitLab", or "/snippet". The user must run /export first to copy the session to the clipboard.
allowed-tools: Bash(pbpaste:*), Bash(mktemp:*), Bash(${CLAUDE_SKILL_DIR}/scripts/create-gitlab-snippet.sh:*), Write
---

# Create a GitLab snippet from the current session

## Step 1: Verify clipboard has session content

Run `pbpaste | head -5` to check whether the clipboard contains a session export. If it does not look like a Claude Code session (should start with a box drawing header or session content), tell the user to run `/export` first and stop.

## Step 2: Choose a title

Read enough of the clipboard to identify the first user prompt (look for the first `>` or `❯` line after the header). Suggest a short, descriptive title based on what the session is about. Use AskUserQuestion to let the user confirm or customize the title. Offer your suggested title as the first option and "Claude Code Session - YYYY-MM-DD HH:MM" (with the current date/time) as the second.

## Step 3: Write a session summary

Read the full clipboard content with `pbpaste` and write a Markdown summary of the session. The summary should include:

- A `## Summary` heading
- A brief description of what the session accomplished
- Key topics discussed, decisions made, and actions taken
- Notable outcomes (files changed, commands run, problems solved)

Create a temp file with `mktemp` and write the summary to it using the Write tool.

## Step 4: Create the GitLab snippet

Pipe the clipboard content to the snippet creation script, passing the chosen title and the summary file via the `SUMMARY_FILE` environment variable:

```bash
pbpaste | SUMMARY_FILE="/path/from/mktemp" ${CLAUDE_SKILL_DIR}/scripts/create-gitlab-snippet.sh - "TITLE"
```

## Step 5: Report the result

Show the user the snippet URL returned by the script.
