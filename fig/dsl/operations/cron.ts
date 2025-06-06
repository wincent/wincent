import Context from '../../Context.ts';
import ErrorWithMetadata from '../../ErrorWithMetadata.ts';
import {log} from '../../console.ts';
import tempfile from '../../fs/tempfile.ts';
import run from '../../run.ts';
import stringify from '../../stringify.ts';

export default async function cron({
  day = '*',
  hour = '*',
  id,
  job,
  minute = '*',
  month = '*',
  notify,
  state = 'present',
  weekday = '*',
}: {
  day?: string;
  hour?: string;
  id: string;
  job: string;
  minute?: string;
  month?: string;
  notify?: Array<string> | string;
  state?: 'absent' | 'present';
  weekday?: string;
}): Promise<OperationResult> {
  if (!/^\S+$/.test(id)) {
    throw new Error(`cron job id ${stringify(id)} must not contain whitespace`);
  }

  validate('day', day);
  validate('hour', hour);
  validate('minute', minute);
  validate('month', month);
  validate('weekday', weekday);

  const entry = [minute, hour, day, month, weekday, job].join(' ');

  // TODO maybe allow management of other user crontabs with sudo.
  await log.debug(`Reading crontab`);

  const result = await run('crontab', ['-l']);

  if (result.status !== 0) {
    if (!result.stderr.includes('no crontab')) {
      throw new ErrorWithMetadata('Unable to read crontab', {
        ...result,
        error: result.error?.toString() ?? null,
      });
    }
  }

  let jobs = parseJobs(result.stdout);

  // Remove, if duplicate or unwanted.
  let seen = false;

  jobs = jobs.filter(({id: jobId}) => {
    if (id === jobId) {
      if (seen || state === 'absent') {
        return false;
      } else {
        seen = true;
        return true;
      }
    }
    return true;
  });

  // Add, if missing and required.
  if (!seen && state === 'present') {
    jobs.push({id, entry});
  }

  let crontab = jobs
    .flatMap(({id: jobId, entry: entryBody}) => {
      if (jobId) {
        if (jobId === id) {
          return [`# fig-cron-job-id: ${jobId}`, entry];
        } else {
          return [`# fig-cron-job-id: ${jobId}`, entryBody];
        }
      } else {
        return entryBody;
      }
    })
    .filter(Boolean)
    .join('\n')
    .trim();

  // Normalize line-ending at EOF.
  if (crontab.length) {
    crontab = crontab + '\n';
  }

  if (crontab !== result.stdout) {
    await log.debug(
      [
        '---- Begin new crontab contents ----',
        crontab,
        '----  End new crontab contents  ----',
      ].join('\n'),
    );

    if (Context.options.check) {
      return await Context.informSkipped(`cron ${id}`);
    } else {
      const src = await tempfile('cron', crontab);

      const result = await run('crontab', [src]);

      if (result.status !== 0) {
        throw new ErrorWithMetadata('Unable to write crontab', {
          ...result,
          error: result.error?.toString() ?? null,
        });
      }

      return await Context.informChanged(`cron ${id}`, notify);
    }
  } else {
    return await Context.informOk(`cron ${id}`);
  }
}

type Job = {
  id?: string;
  entry: string;
};

function parseJobs(crontab: string): Array<Job> {
  const lines = crontab.split(/\r?\n/g);

  const jobs = [];

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];

    const match = line.match(/^\s*#\s*fig-cron-job-id\s*:\s*(?<id>\S+)\s*$/);

    if (match && match.groups && match.groups.id) {
      const id = match.groups.id;
      const nextLine = lines[i + 1] || '';

      if (/^\s*#/.test(nextLine)) {
        // Expected a job, but got a comment.
        jobs.push({
          id,
          entry: '',
        });
      } else {
        // Consume next line as job.
        i++;
        jobs.push({
          id,
          entry: nextLine,
        });
      }
    } else {
      // Note, a "job" without an id can even be a comment or blank line.
      jobs.push({
        id: undefined,
        entry: line,
      });
    }
  }

  return jobs;
}

const MAXIMUMS = {
  day: 31,
  hour: 23,
  minute: 59,
  month: 12,
  weekday: 7,
};

const MINIMUMS = {
  day: 1,
  hour: 0,
  minute: 0,
  month: 1,
  weekday: 0,
};

const MONTHS = new Set([
  'jan',
  'feb',
  'mar',
  'apr',
  'may',
  'jun',
  'jul',
  'aug',
  'sep',
  'oct',
  'nov',
  'dec',
]);

const WEEKDAYS = new Set(['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']);

export function validate(
  field: 'day' | 'hour' | 'minute' | 'month' | 'weekday',
  value: string,
) {
  if (
    (field === 'month' && MONTHS.has(value.toLowerCase())) ||
    (field === 'weekday' && WEEKDAYS.has(value.toLowerCase()))
  ) {
    return;
  }

  const subfields = value.split(',');

  for (const range of subfields) {
    const match = range.match(
      /^(?:\*|(?<first>\d+)(?:-(?<last>\d+))?)(?:\/(?<step>\d+))?$/,
    );

    if (match && match.groups) {
      const {groups} = match;
      const first = groups.first === undefined
        ? undefined
        : Number(groups.first);
      const last = groups.last === undefined ? undefined : Number(groups.last);
      const step = groups.step === undefined ? undefined : Number(groups.step);

      // Simple validation: for example, will catch:
      //
      //      */200 (ie. first-last in steps of 200: out of range)
      //
      // but not:
      //
      //      1-3/5 (ie. 1 through 3 in steps of 5: also out of range)
      //      1,1,1,1 (ie. repeat items)
      //      1-7,3-10 (ie. overlapping items)
      //
      if (
        (first !== undefined && first < MINIMUMS[field]) ||
        (first !== undefined && first > MAXIMUMS[field]) ||
        (last !== undefined && last > MAXIMUMS[field]) ||
        (step !== undefined && (step === 0 || step > MAXIMUMS[field]))
      ) {
        throw new Error(`value \`${value}\` is not a valid ${field}`);
      }
    } else {
      throw new Error(`value \`${value}\` is not a valid ${field}`);
    }
  }
}
