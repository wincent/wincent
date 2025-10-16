# projectionist.vim

Projectionist provides granular project configuration using "projections".
What are projections?  Let's start with an example.

## Example

A while back I went and made a bunch of plugins for working with [rbenv][].
Here's what a couple of them look like:

    ~/.rbenv/plugins $ tree
    .
    ├── rbenv-ctags
    │   ├── bin
    │   │   └── rbenv-ctags
    │   └── etc
    │       └── rbenv.d
    │           └── install
    │               └── ctags.bash
    └── rbenv-sentience
        └── etc
            └── rbenv.d
                └── install
                    └── sentience.bash

As you can see, rbenv plugins have hooks in `etc/rbenv.d/` and commands in
`bin/` matching `rbenv-*`.  Here's a projectionist configuration for that
setup:

    let g:projectionist_heuristics = {
          \   "etc/rbenv.d/|bin/rbenv-*": {
          \     "bin/rbenv-*": {
          \        "type": "command",
          \        "template": ["#!/usr/bin/env bash"],
          \     },
          \     "etc/rbenv.d/*.bash": {"type": "hook"}
          \   }
          \ }

The key in the outermost dictionary says to activate for any directory
containing a subdirectory `etc/rbenv.d/` *or* files matching `bin/rbenv-*`.
The corresponding value contains projection definitions.  Here, two
projections are defined.  The first creates an `:Ecommand` navigation command
and provides boilerplate to pre-populate new files with, and the second
creates an `:Ehook` command.

[rails.vim]: https://github.com/tpope/vim-rails
[rbenv]: https://github.com/sstephenson/rbenv

## Features

See `:help projectionist` for the authoritative documentation.  Here are some
highlights.

### Global and per project projection definitions

In the above example, we used the global `g:projectionist_heuristics` to
declare projections based on requirements in the root directory.  If that's
not flexible enough, you can use the autocommand based API, or create a
`.projections.json` in the root of the project.

### Navigation commands

Navigation commands encapsulate editing filenames matching certain patterns.
Here are some examples for this very project:

    {
      "plugin/*.vim": {"type": "plugin"},
      "autoload/*.vim": {"type": "autoload"},
      "doc/*.txt": {"type": "doc"},
      "README.markdown": {"type": "doc"}
    }

With these in place, you could use `:Eplugin projectionist` to edit
`plugin/projectionist.vim` and `:Edoc projectionist` to edit
`doc/projectionist.txt`.  If no argument is given, it will edit an alternate
file of that type (see below) or a projection without a glob.  So in this
example `:Edoc` would default to editing `README.markdown`.

The `E` stands for `edit`.  You also get `S`, `V`, and `T` variants that
`split`, `vsplit`, and `tabedit`.

Tab complete is smart.  Not quite "fuzzy finder" smart but smart nonetheless.
(On that note, fuzzy finders are great, but I prefer the navigation command
approach when there are multiple categories of similarly named files.)

### Alternate files

Projectionist provides `:A`, `:AS`, `:AV`, and `:AT` to jump to an "alternate"
file, based on ye olde convention originally established in [a.vim][].  Here's
an example configuration for Maven that allows you to jump between the
implementation and test:

    {
      "src/main/java/*.java": {"alternate": "src/test/java/{}.java"},
      "src/test/java/*.java": {"alternate": "src/main/java/{}.java"}
    }

In addition, the navigation commands (like `:Eplugin` above) will search
alternates when no argument is given to edit a related file of that type.

Bonus feature: `:A {filename}` edits a file relative to the root of the
project.

[a.vim]: http://www.vim.org/scripts/script.php?script_id=31

### Buffer configuration

Check out these examples for a minimal Ruby project:

    {
      "*": {"make": "rake"},
      "spec/*_spec.rb": {"dispatch": "rspec {file}"}
    }

That second one sets the default for [dispatch.vim][].  Plugins can use
projections for their own configuration.

[dispatch.vim]: https://github.com/tpope/vim-dispatch

## Installation

Install using your favorite package manager, or use Vim's built-in package
support:

    mkdir -p ~/.vim/pack/tpope/start
    cd ~/.vim/pack/tpope/start
    git clone https://tpope.io/vim/projectionist.git
    vim -u NONE -c "helptags projectionist/doc" -c q

## FAQ

> Why not a clearer filename like `.vim_projections.json`?

Nothing about the file is Vim specific.  See
[projectionist](https://github.com/glittershark/projectionist) for an example
of another tool that uses it.

## License

Copyright © Tim Pope.  Distributed under the same terms as Vim itself.
See `:help license`.
