import ErrorWithMetadata from '../ErrorWithMetadata.js';

export default function fail(reason: string): never {
  throw new ErrorWithMetadata(reason);
}
