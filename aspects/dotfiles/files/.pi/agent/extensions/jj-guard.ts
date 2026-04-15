/**
 * Jujutsu Guard Extension
 *
 * Blocks raw `git add` and `git commit` commands when running inside a
 * Jujutsu repository. These operations should go through `jj` instead.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { isToolCallEventType } from "@mariozechner/pi-coding-agent";
import { existsSync } from "node:fs";
import { join } from "node:path";

const BLOCKED_PATTERNS = [/\bgit\s+add\b/, /\bgit\s+commit\b/];

async function isJujutsuRepo(pi: ExtensionAPI): Promise<boolean> {
	const { stdout, code } = await pi.exec("git", ["rev-parse", "--show-toplevel"]);
	if (code !== 0) return false;
	return existsSync(join(stdout.trim(), ".jj"));
}

export default function (pi: ExtensionAPI) {
	pi.on("tool_call", async (event) => {
		if (!isToolCallEventType("bash", event)) return;

		const command = event.input.command;
		if (!BLOCKED_PATTERNS.some((p) => p.test(command))) return;

		if (!(await isJujutsuRepo(pi))) return;

		return {
			block: true,
			reason: "This is a Jujutsu repository. Use `jj` commands instead of raw git add/commit.",
		};
	});
}
