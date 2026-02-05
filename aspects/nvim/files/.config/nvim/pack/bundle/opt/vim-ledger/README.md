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

### Ledger / HLedger Configuration

* Path to the `ledger` executable:

        let g:ledger_bin = 'ledger'

* Whether to use ledger or hledger specific features.
  Setting this value is optional and in most cases will be guessed correctly based on `g:ledger_bin`, but in the event it isn't guessed correctly or you want to use different syntax features even with your default tooling setup for the other engine this flag can be set to override the value.

        let g:ledger_is_hledger = v:true

* Additional default options for the `ledger` executable:

        let g:ledger_extra_options = ''

* The file to be used to generate reports:

        let g:ledger_main = '%:p'

  The default is to use the current file.

=== Completion Settings ===

* To use a custom external system command to generate a list of account names for completion, set the following.
  If g:ledger_bin is set, this will default to running that command with arguments to parse the current file using the accounts subcommand (works with ledger or hledger), otherwise it will parse the postings in the current file itself.

        let g:ledger_accounts_cmd = 'ledger accounts'

* To use a custom external system command to generate a list of descriptions for completion, set the following.
  If `g:ledger_bin` is set, this will default to running that command with arguments to parse the current file using the descriptions subcommand (works with ledger or hledger), otherwise it will parse the transactions in the current file itself.

        let g:ledger_descriptions_cmd = 'ledger payees'

* If you want account completion based on fuzzy matching instead of the default sub-level completion:

        let g:ledger_fuzzy_account_completion = 1

* If you want the account completion to be sorted by level of detail/depth instead of alphabetical:

        let g:ledger_detailed_first = 1

* Show only exact matches in completion:

        let g:ledger_exact_only = 1

* Include the original text in completion results:

        let g:ledger_include_original = 1

* Enable spell checking for account names:

        let g:ledger_accounts_spell = 1

### Alignment and Formatting Settings

* Specify at which column decimal separators should be aligned:

        let g:ledger_align_at = 60

* Decimal separator for alignment:

        let g:ledger_decimal_sep = '.'

* Specify alignment on the first or last matching separator:

        let g:ledger_align_last = v:false

* Default commodity used by `ledger#align_amount_at_cursor()`:

        let g:ledger_default_commodity = ''

* Align on the commodity location instead of the amount:

        let g:ledger_align_commodity = 1

* Flag that tells whether the commodity should be prepended or appended to the amount:

        let g:ledger_commodity_before = 1

* String to be put between the commodity and the amount:

        let g:ledger_commodity_sep = ''

* Enable spell checking for commodity symbols:

        let g:ledger_commodity_spell = 1

### Folding Settings

* Number of columns that will be used to display the foldtext.
  Set this when you think that the amount is too far off to the right.

        let g:ledger_maxwidth = 80

* String that will be used to fill the space between account name and amount in the foldtext.
  Set this to get some kind of lines or visual aid.

        let g:ledger_fillstring = '    -'

* By default vim will fold ledger transactions, leaving surrounding blank lines unfolded.
  You can use `g:ledger_fold_blanks` to hide blank lines following a transaction.

        let g:ledger_fold_blanks = 0

  A value of 0 will disable folding of blank lines, 1 will allow folding of a single blank line between transactions; any larger value will enable folding unconditionally.

  Note that only lines containing no trailing spaces are considered for folding.
  You can take advantage of this to disable this feature on a case-by-case basis.

### Date Format

* Format of transaction date:

        let g:ledger_date_format = '%Y/%m/%d'

### Report Window Settings

* Position of a report buffer:

        let g:ledger_winpos = 'B'

  Use `b` for bottom, `t` for top, `l` for left, `r` for right.
  Use uppercase letters if you want the window to always occupy the full width or height.

### Quickfix Window Settings

* Flag that tells whether a location list or a quickfix list should be used:

        let g:ledger_use_location_list = 0

  The default is to use the quickfix window.
  Set to 1 to use a location list.

* Position of the quickfix/location list:

        let g:ledger_qf_vertical = 0

  Set to 1 to open the quickfix window in a vertical split.

* Size of the quickfix window:

        let g:ledger_qf_size = 10

  This is the number of lines of a horizontal quickfix window, or the number of columns of a vertical quickfix window.

* Flag to show or hide filenames in the quickfix window:

        let g:ledger_qf_hide_file = 1

  Filenames in the quickfix window are hidden by default.
  Set this to 0 if you want filenames to be visible.

* Format of quickfix register reports (see `:Register`):

        let g:ledger_qf_register_format =
                \ '%(date) %(justify(payee, 50)) '.
                \  '%(justify(account, 30)) %(justify(amount, 15, -1, true)) '.
                \  '%(justify(total, 15, -1, true))\n'

  The format is specified using the standard Ledger syntax for `--format`.

* Format of the reconcile quickfix window (see `:Reconcile`):

        let g:ledger_qf_reconcile_format =
                \ '%(date) %(justify(code, 4)) '.
                \ '%(justify(payee, 50)) %(justify(account, 30)) '.
                \ '%(justify(amount, 15, -1, true))\n'

  The format is specified using the standard Ledger syntax for `--format`.

### Balance Display Settings

* Text of the output of the `:Balance` command:

        let g:ledger_cleared_string = 'Cleared: '
        let g:ledger_pending_string = 'Cleared or pending: '
        let g:ledger_target_string = 'Difference from target: '

### Advanced Settings

* Disable automatic detection of ledger binary:

        let g:ledger_no_bin = 1

* Enable automatic formatting with the ledger binary (potentially dangerous):

        let g:ledger_dangerous_formatprg = 1

  WARNING: This feature can cause data loss when run on non-transaction blocks.

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
