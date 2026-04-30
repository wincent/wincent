export type Metadata = {[key: string]: JSONValue};

export type ErrorWithMetadataOptions = ErrorOptions & {metadata?: Metadata};

export default class ErrorWithMetadata extends Error {
  metadata?: Metadata;

  constructor(message: string, options?: ErrorWithMetadataOptions) {
    super(message, options);

    this.metadata = options?.metadata;
  }
}
