# Pi runtime

The Node aspect installs this locked dependency tree into `~/n/pi` and links `~/n/bin/pi` to its executable. The existing `bin/pi` and `bin/pi-naked` wrappers, Pi configuration, and sessions are unchanged. The runtime stays outside the dotfiles checkout, under the existing read-only `~/n` sandbox grant.

Provisioning skips npm when the installed Pi reports the pinned version. We assume installations use this flow: there is no fingerprint or dependency-drift detection. Otherwise, the helper runs `npm ci --ignore-scripts --omit=dev --include=optional --min-release-age=7` in a temporary sibling directory, checks `pi --version`, and replaces the runtime. Failed installation leaves the old runtime intact; there is no retained release history or automatic global uninstall.

The initial lock preserves the already-installed Pi 1.0.0 tree, taken from its published shrinkwrap with missing integrity values filled from npm registry metadata and normalized offline by npm. It includes optional dependencies for macOS and Linux. This is not an upgrade or a fresh version resolution; 1.0.0 still ships its own shrinkwrap.

## Install

From the dotfiles repo root, outside the agent sandbox:

```sh
./install node

# Or, when Node is already provisioned:
aspects/node/support/pi/install
```

The helper replaces the `pi` command link only after the runtime is ready. Any previous global npm package remains on disk. If you later remove that package, rerun the helper to restore the command link if necessary.

Base VM builds run the same provisioning and check the pinned Pi version before promoting the image. Project VMs inherit the installed runtime when cloned; neither cloning nor code injection upgrades it. Rebuild the base image and recreate project VMs, or explicitly provision the Node aspect inside an existing guest. Install separately on each OS; never copy a macOS `node_modules` tree into Linux.

## Update

Choose an explicit Pi release that is at least seven days old. Generate the lock without installing code or running lifecycle scripts:

```sh
cd aspects/node/support/pi
npm install --package-lock-only --save-exact --ignore-scripts --min-release-age=7 \
  @earendil-works/pi-coding-agent@<eligible-version>
```

Review the manifest and lock diff (including transitive versions, integrity hashes, origins, install scripts, and advisories) before provisioning. Do not relax the cooldown on failure. The age filter is important when resolving the lock: `npm ci` replays approved versions and must not be treated as a fresh age check of every locked dependency. Keep the cross-platform optional entries, and test on macOS and in a base VM before rolling out broadly.

Use this flow instead of `pi update` or a global npm upgrade. After provisioning, check extension loading through the usual sandbox/proxy launcher and manually run `bin/install-types` in public/private wincent and wincent-agent-plugins. The type-copy helpers must support this local runtime and both nested and hoisted dependencies.

Version-only skipping also means a lock-only change at the same Pi version does not reinstall anything. To deliberately reinstall such a change, move `~/n/pi` aside before running the helper; keep that copy until the replacement works.
