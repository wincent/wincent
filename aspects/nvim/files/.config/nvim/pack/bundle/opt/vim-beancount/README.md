# vim-beancount

This is the beancount filetype for Vim.  Includes highlighting and some basic
functions.

## Installation

I suggest [Vundle](https://github.com/gmarik/Vundle.vim) or
[Pathogen](https://github.com/tpope/vim-pathogen), but you can also just
copy all of the files into the appropriate places inside your '.vim' directory.

## Feature Highlights

* Syntax highlighting and indenting.

* Completion: Type `Ex:Oth` followed by `^X^O` to get `Expenses:Donations:Other`
  (provided that you have opened an account with that name).

* Use `:make` to run `bean-check` and load errors in the quickfix window.

* The `AlignCommodity` command lines up all your decimal points.

For full details, see [doc/beancount.txt](doc/beancount.txt).
