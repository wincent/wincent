import ErrorWithMetadata from '../ErrorWithMetadata.ts';

export default function fail(reason: string): never {
  throw new ErrorWithMetadata(reason);
}
