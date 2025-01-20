export default class UnsupportedValueError extends Error {
  constructor(value: never) {
    super(`Unsupported value: ${value}`);
  }
}
