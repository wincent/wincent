const MODE_REGEXP = /^0[0-7]{3}$/;

export default function assertMode(mode: string): asserts mode is Mode {
  if (!MODE_REGEXP.test(mode)) {
    throw new Error(`Invalid mode ${mode}`);
  }
}
