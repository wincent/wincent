type JSONValue =
  | boolean
  | null
  | number
  | string
  | {[property: string]: JSONValue}
  | Array<JSONValue>;

// TODO move this somewhere else so that we can explicitly import it?
type Variables = {
  [key: string]: JSONValue;
};
