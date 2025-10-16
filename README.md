# vim-ledger

[![Vint](https://github.com/ledger/vim-ledger/workflows/Vint/badge.svg)](https://github.com/ledger/vim-ledger/actions?workflow=Vint)
[![Vader](https://github.com/ledger/vim-ledger/workflows/Vader/badge.svg)](https://github.com/ledger/vim-ledger/actions?workflow=Vader)

Filetype detection, syntax highlighting, auto-formatting, auto-completion, and other tools for working with ledger files.
Compatible with both [`ledger`][ledgercli] and [`hledger`][hledger].
See [plaintextaccounting.org][pta] for background information and other useful links.

## Usage

Install as you would any other VIM plugin.
There are a variety of ways depending on your plugin manager.
For example with [Pathogen](https://github.com/tpope/vim-pathogen) you would clone this repository into your configuration directory.
With [vim-plug](https://github.com/junegunn/vim-plug) and many similar ones, you would declare it in your rc file like this, then run `:PlugInstall`:


```vimscript
Plug 'ledger/vim-ledger'
```

### Install using VIM packages functionality (vim 8+)

To install as a single plugin, using VIM packages functionality first create a target folder:
``` plugin
mkdir -p ~/.vim/pack/ledger/start
cd ~/.vim/pack/ledger/start
git clone <URL>
```

Edit .vimrc and append the line:
```
set loadplugins
```


You can also manually copy the corresponding directories into your VIM plugins directory.

One installed this plugin will identify files ending with `.ldg`, `.ledger`, or `.journal` as ledger files automatically.
Alternatively if you use a different extension you can add a modeline to each like this:

```ledger
; vim: filetype=ledger
```

## Tips and useful commands

* Try account-completion (as explained below)

* `:call ledger#transaction_date_set(line('.'), 'auxiliary')`

  will set today's date as the auxiliary date of the current transaction.
  You can use also `primary` or `unshift` in place of `auxiliary`.
  When you pass "unshift" the old primary date will be set as the auxiliary date and today's date will be set as the new primary date.
  To use a different date pass a date measured in seconds since 1st Jan 1970 as the third argument.

* `:call ledger#transaction_state_set(line('.'), '*')`

  sets the state of the current transaction to '*'.
  You can use this in custom mappings.

* `:call ledger#transaction_state_toggle(line('.'), ' *?!')`

  will toggle through the provided transaction states.
  You can map this to double-clicking for example:

        noremap <silent><buffer> <2-LeftMouse>\
        :call ledger#transaction_state_toggle(line('.'), ' *?!')<CR>

* Align commodities at the decimal point. See `help ledger-tips`.

* `:call ledger#entry()`

  will replace the text on the current line with a new transaction based on the replaced text.

## Configuration

Include the following let-statements somewhere in your `.vimrc` to modify the behaviour of the ledger filetype.

* Number of columns that will be used to display the foldtext.
  Set this when you think that the amount is too far off to the right.

        let g:ledger_maxwidth = 80

* String that will be used to fill the space between account name and amount in the foldtext.
  Set this to get some kind of lines or visual aid.

        let g:ledger_fillstring = '    -'

* If you want the account completion to be sorted by level of detail/depth instead of alphabetical, include the following line:

        let g:ledger_detailed_first = 1

* If you want account completion based on fuzzy matching instead of the default sub-level completion, include the following line:

        let g:ledger_fuzzy_account_completion = 1

* By default vim will fold ledger transactions, leaving surrounding blank lines unfolded.
  You can use `g:ledger_fold_blanks` to hide blank lines following a transaction.

        let g:ledger_fold_blanks = 0

  A value of 0 will disable folding of blank lines, 1 will allow folding of a single blank line between transactions; any larger value will enable folding unconditionally.

  Note that only lines containing no trailing spaces are considered for folding.
  You can take advantage of this to disable this feature on a case-by-case basis.

## Completion

Omni completion is implemented for transactions descriptions and posting account names.

### Accounts

By default, account names are matched by the start of every sub-level.
When you insert an account name like this:

    Asse<C-X><C-O>

You will get a list of top-level accounts that start like this.

Go ahead and try something like:

    As:Ban:Che<C-X><C-O>

When you have an account like this, 'Assets:Bank:Checking' should show up.

If fuzzy matching based account completion is enabled, the matches are
loaded based on string similarity and without regard for the sub-levels.

In the previous example, with fuzzy matching enabled, you could load up
matches by doing something like:

    Chec<C-X><C-O>

Notice that we did not need to write the initial account components.

When you want to complete on a virtual transaction, it's currently best to keep the cursor in front of the closing bracket.
Of course you can insert the closing bracket after calling the completion, too.

## License

Copyright 2019–2025 Caleb Maclennan  
Copyright 2009–2017 Johann Klähn  
Copyright 2009 Stefan Karrmann  
Copyright 2005 Wolfgang Oertl

This program is free software:
you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 2 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.
If not, see <https://www.gnu.org/licenses/>.

 [hledger]: https://hledger.org/
 [ledgercli]: https://www.ledger-cli.org/
 [pta]: https://plaintextaccounting.org/
