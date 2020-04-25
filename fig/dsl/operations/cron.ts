export default async function cron({
    day = '*',
    hour = '*',
    id,
    job,
    minute = '*',
    month = '*',
    weekday = '*',
}: {
    day?: string;
    hour?: string;
    id: string;
    job: string;
    minute?: string;
    month?: string;
    weekday?: string;
}): Promise<void> {
    validate('day', day);
    validate('hour', hour);
    validate('minute', minute);
    validate('month', month);
    validate('weekday', weekday);

    console.log('TODO: actually implement', id, job);
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
    value: string
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
            /^(?:\*|(?<first>\d+)(?:-(?<last>\d+))?)(?:\/(?<step>\d+))?$/
        );

        if (match && match.groups) {
            const {groups} = match;
            const first =
                groups.first === undefined ? undefined : Number(groups.first);
            const last =
                groups.last === undefined ? undefined : Number(groups.last);
            const step =
                groups.step === undefined ? undefined : Number(groups.step);

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
