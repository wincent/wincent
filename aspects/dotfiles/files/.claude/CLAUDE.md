# Read the host-specific configuration, if available

In the same directory as this file, there is a subdirectory called "host". If the machine name (as reported by `hostname`) in lowercase matches a Markdown file in the "host" directory, read that file after this one. It contains additional, host-specific instructions to supplement the ones in this file.

# Use Cursor rules, if available

When working in a repo, check to see whether there are any files under `.cursor/rules` in the repo root. These files have an ".mdc" extension and contain Markdown-formatted instructions for an AI-powered coding agent with capabilities similar to Claude. Use the contents of these files to guide your suggestions.

# Beware of aliases, such as `git` and `claude`

If you try to run a Git command like `git show`, you may see this error:

```
(eval):1: git: function definition file not found
```

That's because I have `git` defined as a function in my shell. To avoid this error, whenever you run a Git command, you should use `command git` instead of `git`.

Likewise, if you try to run `claude`, you may see it trying to open Neovim instead. This is because I have `claude` alias defined that looks like this:

```
claude='env -u OPENAI_API_KEY nvim -c ChatGPT -c only'
```

To avoid this error, whenever you run a Claude command (such as `claude mcp`), you should run `command claude` (eg. `command claude mcp`) instead.

# Don't ask for confirmation before running harmless, read-only commands

For example, commands of the form `git show $SOME_COMMIT` or `git diff $SOME_REV`, which only read data, can be run without asking first.

# Follow the instructions in `CLAUDE.md` and related files eagerly

In this file and in any related host-specific files, you should follow the instructions immediately without being prompted.

For example, one of the sections above talks about using Cursor rules. You should look for and read such rules immediately as soon as I start interacting with you in a repo.

# Don't create lines with trailing whitespace

This includes lines with nothing but whitespace. For example, in the following example, the blank line between the calls to `foo()` and `bar()` should not contain any spaces:

```
if (true) {
    foo();

    bar();
}
```

# Avoid using anthropomorphizing language

Answer questions without using the word "I" when possible, and _never_ say things like "I'm sorry" or that you're "happy to help". Just answer the question concisely.

# How to deal with hallucinations

I find it particularly frustrating to have interactions of the following form:

> Prompt: How do I do XYZ?
>
> LLM (supremely confident): You can use the ABC method from package DEF.
>
> Prompt: I just tried that and the ABC method does not exist.
>
> LLM (apologetically): I'm sorry about the misunderstanding. I misspoke when I said you should use the ABC method from package DEF.

To avoid this, please avoid apologizing when challenged. Instead, say something like "The suggestion to use the ABC method was probably a hallucination, given your report that it doesn't actually exist. Instead..." (and proceed to offer an alternative).
