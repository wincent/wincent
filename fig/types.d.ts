type JSONValue =
  | boolean
  | null
  | number
  | string
  | {[property: string]: JSONValue}
  | Array<JSONValue>;

// See `man 1 chmod`.
type Permission =
  | '7' // Read + Write + Execute.
  | '6' // Read + Write.
  | '5' // Read + Execute.
  | '4' // Read.
  | '3' // Write + Execute.
  | '2' // Write.
  | '1' // Execute.
  | '0'; // No permission.

// See `man 1 chmod`.
type SpecialPermission =
  | '7' // set-uid + set-gid + Sticky.
  | '6' // set-uid + set-gid.
  | '5' // set-uid + Sticky.
  | '4' // set-uid.
  | '3' // set-gid + Sticky.
  | '2' // set-gid.
  | '1' // Sticky.
  | '0'; // No special permission.

// Mode can be anything from "0000" through "7777".
type Mode = `${SpecialPermission}${Permission}${Permission}${Permission}`;

// TODO move this somewhere else so that we can explicitly import it?
type Variables = {
  [key: string]: JSONValue;
};

type OperationResult = 'changed' | 'failed' | 'ok' | 'skipped';

// TODO: remove once TS updates its bundled type definitions.
declare interface RegExpConstructor {
  escape(str: string): string;
}
