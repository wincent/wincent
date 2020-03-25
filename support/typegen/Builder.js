const assert = require('assert');

class Builder {
  constructor({tabWidth = 2} = {}) {
    this.indentLevel = 0;
    this.output = '';
    this.tabWidth = tabWidth;
  }

  arrow(params, value) {
    this.printIndent().print(`${params} => `);

    if (typeof value === 'function') {
      return this.line(`{`).block(value).line('}');
    } else {
      return this.print(value);
    }
  }

  assert(condition, message = null) {
    if (message) {
      return this.line(`assert(${condition}, ${message});`);
    } else {
      return this.line(`assert(${condition});`);
    }
  }

  blank() {
    return this.print('\n');
  }

  block(callback) {
    this.indent();

    callback();

    return this.dedent();
  }

  call(name, args) {
    this.print(`.${name}`);

    if (typeof args === 'function') {
      return this.line('(').block(args).line(');');
    } else {
      return this.print(`(${args})`);
    }
  }

  dedent() {
    this.indentLevel--;

    assert(this.indentLevel >= 0, 'Indent level must be non-negative');

    return this;
  }

  ['function'](open, callback) {
    return this.line(`export function ${open} {`).block(callback).line('}');
  }

  getIndent() {
    return ' '.repeat(this.indentLevel * this.tabWidth);
  }

  // TODO: handle else if/else with ...rest
  ['if'](condition, callback, ...rest) {
    return this.line(`if (${condition}) {`).block(callback).line('}');
  }

  indent() {
    this.indentLevel++;

    return this;
  }

  interface(name, callback = () => {}) {
    return this.line(`export interface ${name} {`).block(callback).line(`}`);
  }

  docblock(...lines) {
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

  print(text) {
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

  line(line) {
    return this.printIndent().print(`${line}\n`);
  }

  property(key, value) {
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

module.exports = Builder;
