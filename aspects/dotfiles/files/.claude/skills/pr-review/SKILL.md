---
description: Review a GitHub pull request, examining the summary, linked resources, and diff
argument-hint: "[PR number or URL]"
allowed-tools:
  - Bash
  - Read
  - Glob
  - Grep
  - WebFetch
  - AskUserQuestion
---

Review a GitHub pull request using the `gh` CLI. Examine it as a thorough human reviewer would.

## Steps

1. **Identify the PR**:
   - If the user provided a PR number or URL, use that.
   - Otherwise, find the PR for the current branch: `gh pr view --json number,url`
   - If no PR is found, inform the user.

2. **Fetch PR details** by running:
   ```
   gh pr view <number> --json title,body,baseRefName,headRefName,files,additions,deletions,commits,reviews,comments,url
   ```

3. **Read the PR description carefully**:
   - Understand the stated motivation and approach.
   - If the description contains links (to issues, docs, RFCs, etc.), use WebFetch to read them and understand the context.

4. **Examine the diff**:
   ```
   gh pr diff <number>
   ```
   If the diff is very large, also look at the file-level summary:
   ```
   gh pr diff <number> --stat
   ```
   and then examine the most important files in detail.

5. **Conduct the review** by evaluating:
   - **Correctness**: Are there bugs, logic errors, or edge cases not handled?
   - **Design**: Is the approach sound? Are there simpler alternatives?
   - **Readability**: Is the code clear and well-structured?
   - **Testing**: Are changes adequately tested? Are there missing test cases?
   - **Security**: Are there potential security issues (injection, XSS, etc.)?
   - **Performance**: Are there obvious performance concerns?
   - **Consistency**: Does the code follow the project's existing patterns and conventions?

6. **Present the review** to the user:
   - Start with a brief overall assessment (1-2 sentences).
   - List specific issues found, grouped by severity:
     - **Blocking**: Must be fixed before merging
     - **Suggestions**: Improvements worth considering
     - **Nits**: Minor style or preference items
   - For each issue, reference the specific file and line(s), and explain what the problem is and how to fix it.

7. **Offer next steps** using AskUserQuestion. Give the user a choice:

   **Option A: Post review comments on the PR**
   - Use `gh pr review <number>` to submit the review.
   - Each comment must be clearly prefixed with `[Claude Code Review]` so it is obvious the feedback was AI-generated.
   - Use `--comment` for suggestion-level reviews, `--request-changes` if there are blocking issues.

   **Option B: Check out the branch and implement fixes locally**
   - Check out the PR branch: `gh pr checkout <number>`
   - For each identified issue, make the fix and create a separate commit.
   - Each commit message should reference the issue it addresses.
   - Push the fixes when done.

   **Option C: Do nothing** (just keep the review as conversation output).

## Notes

- Be thorough but fair. Acknowledge what the PR does well, not just problems.
- Do not nitpick formatting if the project has a formatter configured.
- If the PR is very large, focus review effort on the most critical or complex changes.
- When posting comments via `gh`, always label them as AI-generated.
