---
description: Check for pi updates, review local resources, then prepare a reviewed lockfile update and provisioning handoff.
argument-hint: "[instructions]"
---

# Update pi

You are helping the user understand what upgrading pi (`@earendil-works/pi-coding-agent`) will entail: what version they are on, what version is pinned in their dotfiles, what version is available, what breaking changes are in between, and whether any of their locally installed extensions, skills, or prompt templates will need adjustment to remain compatible. Then offer to prepare a lockfile update for review and hand off provisioning to the user outside the agent sandbox. Never use a global npm upgrade or `pi update` for this runtime.

User request: $ARGUMENTS

## Step 1: Determine the installed version and the dotfiles pin

Read `~/code/wincent/aspects/node/support/pi/README.md`, `install`, `package.json`, and `package-lock.json` first. These define the managed installation and update procedure; if they are unavailable or contradict this prompt, stop and ask rather than falling back to a global install.

The source manifest and reviewed lockfile live under `~/code/wincent/aspects/node/support/pi`. The executable dependency tree lives outside the checkout at `~/n/pi`, and `~/n/bin/pi` links to its executable. Existing launchers, settings, and sessions remain unchanged. An old global npm package can still be present, so `npm list -g` and `npm root -g` are not authoritative for this runtime.

Record:

- `PINNED`: the exact `@earendil-works/pi-coding-agent` dependency version in the source manifest. Check that the lockfile's root dependency and package entry agree with it.
- `CURRENT`: the version reported by `~/n/pi/node_modules/.bin/pi --version`. If execution is unavailable, read `~/n/pi/node_modules/@earendil-works/pi-coding-agent/package.json` and mark the version as unverified by execution.
- The result of `pi --version` and the command/link resolution, to verify that the normal launcher reaches the managed runtime rather than a leftover global installation.

If the managed runtime is missing or command resolution disagrees with it, report the migration or PATH issue and ask before preparing an upgrade. Do not silently substitute the old global package's version. If `CURRENT != PINNED`, explain the pending provisioning or drift separately from available releases. Never automatically lower either the installed version or the source pin.

## Step 2: Determine the latest released version and cooldown-eligible target

Run:

```bash
npm view @earendil-works/pi-coding-agent version
npm view @earendil-works/pi-coding-agent time --json
```

Record the registry's latest version as `LATEST`. The timestamps object maps versions to ISO publish times; ignore its `created` and `modified` keys.

This user's locked-install policy requires **7 days** of release age. Set `COOLDOWN = 7 days` and pass `--min-release-age=7` explicitly when generating the lock. Do not try to detect the value with `npm config`: it has failed to surface this setting reliably. Do **not** read `~/.npmrc`, which contains auth tokens. Do not offer a cooldown override or relax the policy on resolution failure.

Let `CUTOFF = now - 7 days`. Set `COOLDOWN_LATEST` to the highest stable semver version whose publish time is less than or equal to `CUTOFF`, or record that none exists. Exclude pre-releases unless the user explicitly requested them, and apply the same age requirement to any requested release. Use semver ordering, not lexical ordering.

`COOLDOWN_LATEST` is only a candidate for lock generation, not a promise that resolution will succeed: transitive dependencies must also satisfy the policy. A published shrinkwrap may constrain the dependency tree, so inspect it and the generated lock rather than assuming every transitive version was freshly age-filtered. Provisioning uses `npm ci` to replay approved versions; it is **not** a fresh age check of every locked dependency.

Classify the situation using `CURRENT`, `PINNED`, `COOLDOWN_LATEST`, and `LATEST`:

1. **Up to date**: `CURRENT == PINNED == LATEST`. Tell the user and stop unless they explicitly want to see recent changes anyway. Version equality alone does not prove dependency-tree equality.
2. **Eligible upgrade**: `COOLDOWN_LATEST > CURRENT` and `COOLDOWN_LATEST >= PINNED`. Offer that explicit target. If newer releases are cooling down, report their changes separately as preview-only.
3. **No eligible upgrade**: no eligible release exists, or `COOLDOWN_LATEST <= CURRENT`, or `COOLDOWN_LATEST < PINNED`. Keep the existing runtime and pin; do not downgrade or regenerate the lock merely to stay put. Report any newer releases and their eligibility dates as preview-only.

If `PINNED > CURRENT`, distinguish provisioning an already-reviewed pin from generating a new lock. Verify its review status with the user; do not infer approval from the mere presence of a lockfile. If `PINNED < CURRENT`, call out that provisioning the existing manifest would downgrade the runtime and ask how to reconcile it. Resolve such discrepancies before making changes.

## Step 3: Fetch the changelog

Fetch the raw changelog via `curl`:

```bash
curl -sSL https://raw.githubusercontent.com/earendil-works/pi/main/packages/coding-agent/CHANGELOG.md
```

The human-readable URL is <https://github.com/earendil-works/pi/blob/main/packages/coding-agent/CHANGELOG.md>.

Extract the entries for every version strictly greater than `CURRENT` and less than or equal to `LATEST`, also covering any explicitly requested target or pending `PINNED` version beyond that range. Separate changes available in the eligible target from preview-only changes still inside the cooldown. Check the exact target version's exports and dependencies, including changes to host-provided transitive packages used by extensions. Pay particular attention to:

- Sections or bullets labeled **Breaking**, **BREAKING CHANGE**, **Migration**, **Removed**, or **Deprecated**.
- Changes to extension APIs, event names, `ExtensionContext` or `pi.*` method signatures, tool registration, skill loading, prompt template loading or interpolation, or session format.
- Changes to CLI flags, config file locations, or default behaviors.

Summarize these for the user, grouped by version, with the breaking ones called out first.

## Step 4: Inventory the user's extensions, skills, and prompt templates

The goal of this step is to discover every extension, skill, and prompt template that pi will load for this user, so that the impact analysis in Step 5 covers all of them. Missing a configured root and then declaring all resources compatible based on a partial sample is a serious failure mode of this prompt; treat completeness as a hard requirement.

### Step 4a: Always read `settings.json` first

Before enumerating anything, read `~/.pi/agent/settings.json` if it exists, or the settings under `PI_CODING_AGENT_DIR` when overridden. Also inspect applicable trusted project settings at `.pi/settings.json` in the current working directory. The `extensions`, `skills`, and `prompts` arrays accept files or directories; `packages` can contribute all three resource types. Tilde-expand `~` against `$HOME` and resolve relative entries against the directory containing their settings file.

Configured resource paths are mandatory inventory inputs, but they are **additive**, not replacements for auto-discovered defaults. Even a present or empty array does not by itself disable discovery. Inventory the union of enabled configured entries, auto-discovered resources, package resources, and explicit CLI resources. Honor resource filters, exclusions, project trust, and any known `--no-*` discovery flags using the installed Pi version's documented rules. Do not silently omit a configured root or an enabled default root.

The usual auto-discovered roots are:

- Extensions: `~/.pi/agent/extensions` and trusted `.pi/extensions` in the current working directory.
- Skills: `~/.pi/agent/skills`, `~/.agents/skills`, trusted `.pi/skills` in the current working directory, and trusted `.agents/skills` in cwd and ancestors up to the Git root (or filesystem root outside a repository).
- Prompts: `~/.pi/agent/prompts` and trusted `.pi/prompts` in the current working directory.

Apply `PI_CODING_AGENT_DIR` to the global Pi roots above. Ordinary `.pi` resource directories are cwd-local; do not apply the ancestor-walking rule for `.agents/skills` to them. Inspect package manifests and filters, explicit `-e`/`--extension`, `--skill`, and `--prompt-template` inputs when known, and any resource-discovery hooks in loaded extension source. Mark unverifiable dynamic or CLI resources as uncertain rather than claiming completeness. Do not install packages or execute unfamiliar extension code merely to inventory it.

List every root or explicit file you ended up with, its source, and any empty, missing, disabled, or untrusted locations explicitly in your scratch reasoning so it is obvious which extensions, skills, and prompts are in scope.

### Step 4b: Enumerate every item from every enabled source

Follow the installed Pi version's loader rules, not just filename guesses:

- **Extensions:** include explicit files, direct `*.ts` and `*.js` entries, and immediate extension subdirectories exposing `index.ts`, `index.js`, or entrypoints declared by their package manifest. Do not treat every helper or test file below an extension directory as a separate extension; inspect imported implementation files during the compatibility review.
- **Skills:** include explicit files and recursively discovered `SKILL.md` directories, including symlinked skills. Root Markdown discovery differs by location: Pi/configured roots can expose direct skill `.md` files, while `.agents/skills` ignores root Markdown other than `SKILL.md` and can discover skill Markdown in grouping folders. Validate frontmatter and record discovery warnings; check installed loader behavior for ambiguous layouts.
- **Prompts:** include explicit files and direct `*.md` files in each directory. Prompt directory discovery is non-recursive unless nested locations are explicitly configured or selected by a package manifest.
- **Packages:** honor `pi.extensions`, `pi.skills`, and `pi.prompts` manifest entries, patterns, and configured filters. Without a manifest, inspect the conventional resource directories. Record configured but unavailable packages instead of installing them during the audit.

Resolve symlinks to deduplicate physical sources, retaining their configured names and aliases in the report. Do not rename a Pi skill after the directory its symlink resolves to. Record both names when multiple roots map to the same underlying file.

### Step 4c: Record name and purpose for each discovered item

For every extension, skill, and prompt template you found, read the file header, frontmatter, README entry, or source-level registration call and briefly note its name and purpose. This list must be the input to Step 5: any item present here must appear in the per-item verdict table you produce in Step 5 or Step 6. If you skip an item because you judge it irrelevant, say so explicitly rather than dropping it silently.

### Step 4d: Sanity-check coverage before continuing

Before moving on, ask yourself: have I accounted for every configured resource entry, enabled auto-discovered default, applicable trusted project resource, package resource, and known CLI or dynamic resource? Have I recorded missing, excluded, untrusted, or unverifiable sources rather than silently dropping them? If the answer is anything other than yes, go back and finish. Do not start Step 5 with an unexplained gap in coverage.

## Step 5: Cross-reference against breaking changes

For every breaking change identified in Step 3, check each extension, skill, and prompt template discovered in Step 4 for usage of the affected API, flag, or convention. The search must span every inventoried source, including configured roots, enabled defaults, and package resources, not just default `~/.pi/agent/...` paths. Concretely:

- For API renames or removals: use `rg` for the old symbol across all inventoried extension roots simultaneously, following relevant symlinks and including hidden source directories when necessary.
- For event name changes: search for the old event name across all extension roots.
- For skill, prompt, config, or frontmatter changes: inspect the relevant files directly.
- For prompt interpolation changes: inspect every prompt template for affected variables such as positional arguments, all-arguments placeholders, and argument slice placeholders.

Produce a per-item verdict, with one row per item enumerated in Step 4. Do not omit items just because they appear obviously fine; an explicit Compatible verdict tells the user you actually looked.

- **Compatible**: no action needed.
- **Needs update**: describe what must change and, where possible, propose the specific edit with file and diff-style snippet.
- **Uncertain**: explain what you could not verify and what the user should double-check manually.

When presenting the table in Step 6, organize rows by source root so the user can see at a glance that every root was covered.

## Step 6: Present findings and offer to prepare the update

Structure the report as:

1. **Version summary**: installed `CURRENT`, dotfiles `PINNED`, eligible `COOLDOWN_LATEST` (if any), and registry `LATEST`, with publish dates and any pending provisioning or drift.
2. **Eligible upgrade**: changes from `CURRENT` to the eligible target, with breaking changes first, followed by notable features, fixes, and deprecations. If no eligible upgrade exists, say that keeping the current runtime and pin requires no command.
3. **Cooldown preview**: if newer releases are still cooling down, summarize their additional changes and eligibility dates separately. These are not install options under this policy.
4. **Impact on your extensions, skills, and prompt templates**: the per-item verdicts from Step 5, grouped by source root. Distinguish eligible-target compatibility from preview-only compatibility where they differ.
5. **Recommended action**: offer to prepare the exact eligible version's manifest and lockfile for review, or **don't update**. List any compatibility fixes and ask whether to apply them as part of the preparation. For an already-reviewed pending pin, offer a provisioning handoff without regenerating the lock instead.

Show the lock-generation command from Step 7 with the literal target version. Make clear that this only prepares source files; it does not upgrade the running Pi. Require explicit approval before changing the manifest, lockfile, or local resources. Provisioning is a separate action after review, outside the agent sandbox. Never offer `npm install -g`, `pi update`, an unpinned target, or a cooldown override as an alternative.

## Step 7: Prepare and review the manifest and lockfile

Only proceed after the user explicitly chooses preparation in Step 6. Echo the exact target and approved compatibility fixes. Inspect the dotfiles repository instructions, worktree status, and existing manifest/lock changes first; do not overwrite unrelated or unreviewed work. If an existing pending lock is the intended target, review it rather than regenerating it unnecessarily.

From the source manifest directory, run the documented lock-only command with `<eligible-version>` replaced by the approved literal version:

```bash
cd ~/code/wincent/aspects/node/support/pi
npm install --package-lock-only --save-exact --ignore-scripts --min-release-age=7 \
  @earendil-works/pi-coding-agent@<eligible-version>
```

Capture stdout and stderr. On failure, report it and inspect any partial file changes; do not relax the cooldown, enable lifecycle scripts, switch to a global install, or delete the lock to force resolution. Ask how to proceed.

Review and summarize the complete manifest and lock diff before recommending provisioning:

- Confirm the exact Pi pin agrees across the manifest, lockfile root dependency, and locked Pi package entry.
- Review added, removed, and changed transitive versions, integrity hashes, resolved origins, install-script declarations, and security advisories. Flag unexpected origins, missing integrity, or unexplained dependency churn; state any checks that could not be completed.
- Check release ages for new or changed registry versions, including versions constrained by published shrinkwraps. Do not treat `npm ci --min-release-age=7` as proof that the lock satisfies the cooldown. If newly selected dependencies are too young or cannot be verified, stop and report the blocker rather than recommending provisioning.
- Preserve cross-platform optional dependency entries for macOS and Linux. Do not prune the lock to the current host's platform or install executable dependencies inside the dotfiles checkout.
- Revisit affected extension verdicts if the resolved dependency tree differs from the assumptions in Step 5. Apply only the compatibility fixes the user approved.

Present the diff summary and unresolved concerns for user review. Do not auto-commit, provision, or claim that Pi has been upgraded. Ask the user to approve the reviewed lock before moving to the provisioning handoff.

## Step 8: Hand off provisioning and verification

After the user approves the reviewed lock, provide these commands to run from the dotfiles repo root **outside the agent sandbox**:

```bash
cd ~/code/wincent
aspects/node/support/pi/install
```

If Node itself needs provisioning, use `./install node` instead. Do not execute provisioning from the agent sandbox or try to bypass its read-only `~/n` grant.

Explain the helper's behavior: it stages a copy of the manifest and lock in a temporary sibling directory, runs `npm ci --ignore-scripts --omit=dev --include=optional --min-release-age=7`, checks the pinned version, then replaces `~/n/pi` and updates `~/n/bin/pi`. Failed installation leaves the old runtime intact, but successful replacement retains no release history. Old global npm packages remain on disk; do not uninstall them as part of this workflow.

The helper skips installation when the installed Pi version matches the pin, even if the lock changed. For an intentional same-version lock update, explain that the user must move `~/n/pi` aside before provisioning and keep that copy until the replacement works. Treat this as a separate, explicit manual action, not automatic cleanup or a normal upgrade step. If that installation fails, the user must restore the saved copy.

After provisioning, ask the user to verify the managed executable's version and normal command resolution, then start a fresh Pi through the usual sandbox/proxy launcher to check extension loading. Until verified, report preparation or provisioning as pending, not a successful runtime upgrade.

Remind the user to manually run the `bin/install-types` helper in each repository where they keep Pi extensions:

- `wincent` (public dotfiles)
- `wincent` (private/corporate dotfiles)
- `wincent-agent-plugins` (public)

The helpers must read types from the managed `~/n/pi` runtime and support both nested and hoisted dependencies, not assume a global npm layout. Flag any helper still using the old layout for an approved compatibility fix. Do not run the helpers automatically; the repositories may not all be checked out on this machine.

Test on macOS and in a base VM before broad rollout. Base VM builds provision the same lock and check the pinned version before image promotion. Existing project VMs do not update through cloning or code injection: rebuild the base image and recreate project VMs, or explicitly provision the Node aspect in an existing guest. Install separately on each OS; never copy macOS `node_modules` into Linux.

## Notes

- Invoking this prompt authorizes an audit, not manifest changes, lock generation, provisioning, or commits. Keep preparation approval and post-review provisioning approval separate.
- If registry metadata or the changelog cannot be fetched, state what could not be verified. Package metadata may supplement missing release notes, but do not guess release ages or claim a complete compatibility review.
- Pre-release or beta versions such as `-next` or `-rc` should be mentioned but not recommended unless the user asked for them explicitly.
- If `CURRENT` is many versions behind, warn the user that the impact assessment is best-effort and that a staged upgrade or careful manual review may be wiser than a single jump.
- If the user changes the cooldown policy, reconcile this prompt with the dotfiles provisioning documentation and helper rather than adding runtime detection or a one-shot bypass.
