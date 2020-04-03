import * as os from 'os';
import * as path from 'path';

import ErrorWithMetadata from './ErrorWithMetadata';
import Context from './Fig/Context';
import {root} from './Fig';
import {debug, log, setLogLevel} from './console';
import getOptions from './getOptions';
import merge from './merge';
import prompt from './prompt';
import readAspect from './readAspect';
import readProject from './readProject';
import regExpFromString from './regExpFromString';
import simplify from './simplify';
import stringify from './stringify';
import test from './test';

async function main() {
    if (Context.attributes.uid === 0) {
        throw new ErrorWithMetadata('Cannot run as root');
    }

    // Skip first two args (node executable and main.js script).
    const options = await getOptions(process.argv.slice(2));

    setLogLevel(options.logLevel);

    debug(() => {
        log.debug('process.argv:\n\n' + stringify(process.argv) + '\n');
        log.debug('getOptions():\n\n' + stringify(options) + '\n');
    });

    if (process.cwd() === root) {
        log.info(`Working from root: ${simplify(root)}`);
    } else {
        log.notice(`Changing to root: ${simplify(root)}`);
        process.chdir(root);
    }

    log.info('Running tests');

    await test();

    if (options.testsOnly) {
        return;
    }

    const project = await readProject(path.join(root, 'project.json'));

    const hostname = os.hostname();

    const profiles = project.profiles ?? {};

    const [profile] =
        Object.entries(profiles).find(([, {pattern}]) => {
            if (regExpFromString(pattern).test(hostname)) {
                return true;
            }
        }) || [];

    log.info(`Profile: ${profile || 'n/a'}`);

    const profileVariables: {[key: string]: JSONValue} = profile
        ? profiles[profile]!.variables ?? {}
        : {};

    const platform = Context.attributes.platform;

    log.info(`Platform: ${platform}`);

    const {aspects, variables: platformVariables = {}} = project.platforms[
        platform
    ];

    // Register tasks.
    const candidateTasks = [];

    for (const aspect of aspects) {
        switch (aspect) {
            case 'launchd':
                require('../aspects/launchd');
                break;
            case 'terminfo':
                require('../aspects/terminfo');
                break;
        }

        // Check for an exact match of the starting task if `--start-at-task=` was
        // supplied.
        for (const [, name] of Context.tasks.get(aspect)) {
            if (name === options.startAt.literal) {
                options.startAt.found = true;
            } else if (
                !options.startAt.found &&
                options.startAt.fuzzy &&
                options.startAt.fuzzy.test(name)
            ) {
                candidateTasks.push(name);
            }
        }
    }

    if (!options.startAt.found && candidateTasks.length === 1) {
        log.notice(`Matching task found: ${candidateTasks[0]}`);

        log();

        const reply = await prompt('Start running at this task? [y/n]: ');

        if (/^\s*y(?:e(?:s)?)?\s*$/i.test(reply)) {
            options.startAt.found = true;
            options.startAt.literal = candidateTasks[0];
        } else {
            throw new ErrorWithMetadata('User aborted');
        }
    } else if (!options.startAt.found && candidateTasks.length > 1) {
        log.notice(`${candidateTasks.length} tasks found:\n`);

        const width = candidateTasks.length.toString().length;

        while (!options.startAt.found) {
            candidateTasks.forEach((name, i) => {
                log(`${(i + 1).toString().padStart(width)}: ${name}`);
            });

            log();

            const reply = await prompt('Start at task number: ');

            const choice = parseInt(reply.trim(), 10);

            if (
                Number.isNaN(choice) ||
                choice < 1 ||
                choice > candidateTasks.length
            ) {
                log.warn(
                    `Invalid choice ${JSON.stringify(
                        reply
                    )}; try again or press CTRL-C to abort.`
                );

                log();
            } else {
                options.startAt.found = true;
                options.startAt.literal = candidateTasks[choice - 1];
            }
        }
    }

    const baseVariables = merge(profileVariables, platformVariables);

    // Execute tasks.
    try {
        for (const aspect of aspects) {
            const {variables: aspectVariables = {}} = await readAspect(
                path.join(root, 'aspects', aspect, 'aspect.json')
            );

            if (options.focused.size && !options.focused.has(aspect)) {
                log.info(`Skipping aspect: ${aspect}`);
                continue;
            }

            const variables = merge(aspectVariables, baseVariables);

            // log.debug(`variables:\n\n${JSON.stringify(variables, null, 2)}\n`);

            for (const [callback, name] of Context.tasks.get(aspect)) {
                if (
                    !options.startAt.found ||
                    name === options.startAt.literal
                ) {
                    options.startAt.found = false;
                    log.info(`Task: ${name}`);

                    await Context.withContext({aspect, variables}, async () => {
                        await callback();
                    });
                }
            }
        }
    } finally {
        const counts = Object.entries(Context.counts)
            .map(([name, count]) => {
                return `${name}=${count}`;
            })
            .join(' ');

        log.info(`Summary: ${counts}`);
    }
}

main().catch((error) => {
    if (error instanceof ErrorWithMetadata) {
        if (error.metadata) {
            log.error(
                `${error.message}\n\n${JSON.stringify(
                    error.metadata,
                    null,
                    2
                )}\n`
            );
        } else {
            log.error(error.message);
        }
    } else {
        log.error(error.toString());
    }

    process.exit(1);
});
