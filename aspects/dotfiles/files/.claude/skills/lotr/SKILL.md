---
description: Orchestrate interactions between multiple agents
allowed-tools:
  - Bash
  - Read
  - Glob
  - Grep
  - AskUserQuestion
---

This skill describes conventions for distributing and coordinating work across multiple Claude instances, called a "fellowship". Character names from the Lord of the Rings are used in order to provide memorable labels with which to address the different agents in the fellowship, labels which very likely _won't_ clash with directory and branch names that exist in the systems being worked on. Beyond this, the agent nicknames have no intrinsic meaning and are completely arbitrary labels.

# Types of agents

- **Leaders** These are powerful agents charged with doing the bulk of the proactive work. The principal agent is "gandalf", and he may delegate to three others: "aragorn", "legolas", and "gimli".

- **Followers** These are subordinate agents charged with doing reactive work, such as reviewing the work of other agents. These agents are named "frodo", "sam", "merry", and "pippin".

# Use of worktrees

Generally, "gandalf" will work in the top-level of a repository, while the other agents will work in worktrees (created with `claude --worktree aragorn`, `claude --worktree legolas` etc). Due to Claude's default behavior, this means that the agents in newly created worktrees will start out on branches named `worktree-aragorn`, `worktree-legolas` etc. This is necessary because Git does not allow the same branch to be checked out in two worktrees at once. After the initial creation, agents operating in worktrees are free to switch to other branches, provided they do not violate Git's "no-duplicate-checkouts" rule for branches. For example, Leader agents will often check out branches for PRs that they are preparing, and Follower agents like "frodo" may check out branches that they are reviewing.

# Coordination between agents

In general, the whole idea of running multiple agents is to make similar, repetitive changes in parallel. That is, all of the agents involved in a task will be performing the same kinds of actions in different parts of the codebase. Typically, "gandalf" will be used to create a plan that all of the agents can follow, which will be stored under `.claude-notes` at the top level of the main repository. For example, imagine we have a project to update an API calling convention across hundreds of files: the user would work interactively with "gandalf" to develop a plan at `.claude-notes/api-update-plan.md`, and "gandalf" would create tasks lists, one per agent, in files like `.claude-notes/api-update-tasklist-aragorn.md`.

The agents will each read from the overall plan to understand the overall goal, related procedures, and how the work is to be divided up among agents and verified. Each agent will then work through its tasklist, updating it to reflect progress as it goes.

# Sharing learnings among agents

In addition to updating their own task lists, agents will maintain a record of their learnings in `.claude-notes/${project-name}-learnings-${agent-alias}.md` (eg. `.claude-notes/api-update-learnings-aragorn.md`). Gandalf will periodically read these learnings and use them to update to top-level plan document

Therefore, it is very important that all agents operate in a loop so as to benefit from these learnings. The general pattern is:

1. Read the top-level plan document.
2. Read the agent-specific task list.
3. Read the learnings files of all agents.
4. Work on a specific task.
5. Mark the task as completed.
6. Update the agent-specific learning file.
7. Go to "1", starting the loop again.

# Minimizing context bloat

As the use case here is automation of many changes, it is all too easy for a long-running agent to fill up its context window, requiring regular compaction (which is undesirable because it is slow, and often results in loss of information).

To avoid this, agents should use subagents and background agents as much as possible, so that their context remains relatively lightly populated, and the work of actually performing changes is delegated to these other short-lived subagents and background agents.
