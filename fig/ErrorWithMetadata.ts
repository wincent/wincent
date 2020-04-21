export type Metadata = {[key: string]: JSONValue};

export default class ErrorWithMetadata extends Error {
    metadata?: Metadata;

    constructor(message: string, metadata?: Metadata) {
        super(message);

        this.metadata = metadata;
    }
}
