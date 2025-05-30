import Context from './Context.js';
const EXECUTABLES: {
  darwin: {[key: string]: string};
  linux: {[key: string]: string};
} = {
  darwin: {
    // Hack: hard-code Apple-supplied paths to avoid GNU coreutils from Homebrew
    // (or elsewhere), which might be ahead of `/usr/bin/stat` in the `$PATH` on
    // Darwin.
    chmod: '/bin/chmod',
    chown: '/usr/sbin/chown',
    cp: '/bin/cp',
    ln: '/bin/ln',
    mv: '/bin/mv',
    rm: '/bin/rm',
    stat: '/usr/bin/stat',
    touch: '/usr/bin/touch',
  },
  linux: {},
} as const;

export default function executable(command: string): string {
  return EXECUTABLES[Context.attributes.platform][command] || command;
}
