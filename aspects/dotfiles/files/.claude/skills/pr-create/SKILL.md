---
description: Create a GitHub pull request as a draft, auto-generating title and body from commits
allowed-tools:
  - Bash
  - Read
  - Glob
  - Grep
  - AskUserQuestion
---

Create a GitHub pull request for the current branch using the `gh` CLI.

## Steps

1. **Determine the default branch** by running:
   ```
   gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'
   ```
   Use this as the base branch unless the user has specified a different base.

2. **Gather context** by running these in parallel:
   - `git log <base>..HEAD --oneline` to see all commits being proposed
   - `git diff <base>...HEAD --stat` to see a summary of changed files
   - `git diff <base>...HEAD` to see the full diff

3. **Check for a PR template** by looking for files in these locations (in order of priority):
   - `.github/PULL_REQUEST_TEMPLATE.md`
   - `.github/PULL_REQUEST_TEMPLATE/` directory (if multiple templates exist, pick the default one, or ask the user which to use)
   - `PULL_REQUEST_TEMPLATE.md` (repo root)

   If a template is found, read it and use its structure for the PR body. Fill in the template sections based on the commits and diff.

4. **Draft the PR title and body**:
   - Auto-generate a concise title (under 72 characters) from the commits and diff
   - Generate the body using the template structure if one was found, otherwise write a clear summary of the changes
   - The body should explain what changed and why, based on commit messages and the diff

5. **Present the draft to the user** using AskUserQuestion:
   - Show the proposed title and body
   - Ask if they want to make any changes before creating the PR
   - If the user provides revisions, incorporate them

6. **Create the PR** by running:
   ```
   gh pr create --draft --title "<title>" --body "<body>" --base <base-branch>
   ```
   Use a HEREDOC for the body to preserve formatting.

7. **Report the PR URL** back to the user.

## Notes

- Always create PRs as drafts.
- If the user specifies a base branch (e.g., "base this on the feature-x branch"), use that instead of the default branch.
- If there are unpushed commits, push the branch first with `git push -u origin HEAD` (after checking that `origin` is the correct remote for GitHub by inspecting the output of `git remote -v`).
- If the current branch has no commits ahead of the base, inform the user and do not create a PR.
