import * as assert from 'node:assert';

type Callback = () => void;

export default class Builder {
  indentLevel: number;
  output: string;
  tabWidth: number;

  constructor({tabWidth = 2} = {}) {
    this.indentLevel = 0;
    this.output = '';
    this.tabWidth = tabWidth;
  }

  arrow(params: string, value: Callback | string) {
    this.printIndent().print(`${params} => `);

    if (typeof value === 'function') {
      return this.line(`{`).block(value).line('}');
    } else {
      return this.print(value);
    }
  }

  assert(condition: string, message = null) {
    if (message) {
      return this.line(`assert(${condition}, ${message});`);
    } else {
      return this.line(`assert(${condition});`);
    }
  }

  blank() {
    return this.print('\n');
  }

  block(callback: Callback) {
    this.indent();

    callback();

    return this.dedent();
  }

  call(name: string, args: Callback | string) {
    this.print(`.${name}`);

    if (typeof args === 'function') {
      return this.line('(').block(args).line(');');
    } else {
      return this.print(`(${args})`);
    }
  }

  dedent() {
    this.indentLevel--;

    assert.ok(this.indentLevel >= 0, 'Indent level must be non-negative');

    return this;
  }

  forOf(binding: string, collection: string, callback: Callback) {
    return this.line(`for (const ${binding} of ${collection}) {`)
      .block(callback)
      .line('}');
  }

  ['function'](
    open: string,
    ...rest: [Callback] | [{export?: boolean}, Callback]
  ) {
    let callback: Callback | undefined;
    let options = {export: true};

    if (typeof rest[0] === 'function') {
      callback = rest[0];
    } else {
      options = {...options, ...rest[0]};
      callback = rest[1];
    }
    assert.ok(callback);

    if (options.export) {
      this.line(`export function ${open} {`).block(callback).line('}');
    } else {
      this.line(`function ${open} {`).block(callback).line('}');
    }

    return this;
  }

  getIndent() {
    return ' '.repeat(this.indentLevel * this.tabWidth);
  }

  // `rest`, if supplied, is an `else` callback.
  // TODO: make it handle `else if` too
  ['if'](condition: string, callback: Callback, ...rest: [Callback] | []) {
    if (rest.length) {
      return this.line(`if (${condition}) {`)
        .block(callback)
        .line('} else {')
        .block(rest[0])
        .line('}');
    } else {
      return this.line(`if (${condition}) {`).block(callback).line('}');
    }
  }

  indent() {
    this.indentLevel++;

    return this;
  }

  interface(name: string, callback = () => {}) {
    return this.line(`export interface ${name} {`).block(callback).line(`}`);
  }

  docblock(...lines: Array<string>) {
    this.line('/**');

    lines.forEach((line) => {
      if (/^\s*$/.test(line)) {
        this.line(` *`);
      } else {
        this.line(` * ${line}`);
      }
    });

    return this.line(' */');
  }

  print(text: string) {
    this.output += text;

    return this;
  }

  last() {
    const length = this.output.length;

    if (length) {
      return this.output[length - 1];
    } else {
      return null;
    }
  }

  line(line: string) {
    return this.printIndent().print(`${line}\n`);
  }

  property(key: string, value: Callback | string) {
    this.printIndent().print(`${key}: `);

    if (typeof value === 'function') {
      value();
    } else {
      this.line(`${value};`);
    }

    return this;
  }

  printIndent() {
    const length = this.output.length;

    if (!length || this.last() === '\n') {
      const indent = this.getIndent();

      this.print(indent);
    }

    return this;
  }
}
