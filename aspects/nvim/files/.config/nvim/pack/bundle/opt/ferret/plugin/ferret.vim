" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the BSD 2-clause license.

""
" @header
"
" @image https://raw.githubusercontent.com/wincent/ferret/media/ferret.jpg center
" @image https://raw.githubusercontent.com/wincent/ferret/media/ferret.gif center
"

""
" @plugin ferret Ferret plug-in for Vim
"
" # Intro
"
" > "ferret (verb)<br />
" > (ferret something out) search tenaciously for and find something: she had
" > the ability to ferret out the facts."
"
"                                                               *ferret-features*
" Ferret improves Vim's multi-file search in four ways:
"
" ## 1. Powerful multi-file search
"
" Ferret provides an |:Ack| command for searching across multiple files using
" ripgrep (https://github.com/BurntSushi/ripgrep), The Silver Searcher
" (https://github.com/ggreer/the_silver_searcher), or Ack
" (http://beyondgrep.com/). Support for passing options through to the
" underlying search command exists, along with the ability to use full regular
" expression syntax without doing special escaping. On modern versions
" of Vim (version 8 or higher, or Neovim), searches are performed
" asynchronously (without blocking the UI).
"
" Shortcut mappings are provided to start an |:Ack| search (`<Leader>a`) or to
" search for the word currently under the cursor (`<Leader>s`).
"
" Results are normally displayed in the |quickfix| window, but Ferret also
" provides a |:Lack| command that behaves like |:Ack| but uses the
" |location-list| instead, and a `<Leader>l` mapping as a shortcut to |:Lack|.
"
" |:Back| and |:Black| are analogous to |:Ack| and |:Lack|, but scoped to search
" within currently open buffers only. |:Quack| is scoped to search among the
" files currently in the |quickfix| list.
"
" ## 2. Streamlined multi-file replace
"
" The companion to |:Ack| is |:Acks| (mnemonic: "Ack substitute", accessible via
" shortcut `<Leader>r`), which allows you to run a multi-file replace across all
" the files placed in the |quickfix| window by a previous invocation of |:Ack|
" (or |:Back|, or |:Quack|).
"
" Correspondingly, results obtained by |:Lack| can be targeted for replacement
" with |:Lacks|.
"
" ## 3. Quickfix listing enhancements
"
" The |quickfix| listing itself is enhanced with settings to improve its
" usability, and natural mappings that allow quick removal of items from the
" list (for example, you can reduce clutter in the listing by removing lines
" that you don't intend to make changes to).
"
" Additionally, Vim's |:cn|, |:cp|, |:cnf| and |:cpf| commands are tweaked to
" make it easier to immediately identify matches by centering them within the
" viewport.
"
" ## 4. Easy operations on files in the quickfix listing
"
" Finally, Ferret provides a |:Qargs| command that puts the files currently in
" the |quickfix| listing into the |:args| list, where they can be operated on in
" bulk via the |:argdo| command. This is what's used under the covers on older
" versions of Vim by |:Acks| to do its work (on newer versions the built-in
" |:cdo| or |:cfdo| are used instead).
"
" Ferret also provides a |:Largs| command, which is a |location-list| analog
" for |:Qargs|.
"
" # Installation
"
" To install Ferret, use your plug-in management system of choice.
"
" If you don't have a "plug-in management system of choice", I recommend
" Pathogen (https://github.com/tpope/vim-pathogen) due to its simplicity and
" robustness. Assuming that you have Pathogen installed and configured, and that
" you want to install Ferret into `~/.vim/bundle`, you can do so with:
"
" ```
" git clone https://github.com/wincent/ferret.git ~/.vim/bundle/ferret
" ```
"
" Alternatively, if you use a Git submodule for each Vim plug-in, you could do
" the following after `cd`-ing into the top-level of your Git superproject:
"
" ```
" git submodule add https://github.com/wincent/ferret.git ~/vim/bundle/ferret
" git submodule init
" ```
"
" To generate help tags under Pathogen, you can do so from inside Vim with:
"
" ```
" :call pathogen#helptags()
" ```
"
" @mappings
"
" ## Circumstances where mappings do not get set up
"
" Note that Ferret will not try to set up the |<Leader>| mappings if any of the
" following are true:
"
" - A mapping with the same |{lhs}| already exists.
" - An alternative mapping for the same functionality has already been set up
"   from a |.vimrc|.
" - The mapping has been suppressed by setting |g:FerretMap| to 0 in your
"   |.vimrc|.
"
" ## Mappings specific to the quickfix window
"
" Additionally, Ferret will set up special mappings in |quickfix| listings,
" unless prevented from doing so by |g:FerretQFMap|:
"
" - `d` (|visual-mode|): delete visual selection
" - `dd` (|Normal-mode|): delete current line
" - `d`{motion} (|Normal-mode|): delete range indicated by {motion}
"
"
" @footer
"
" # Custom autocommands
"
"      *FerretAsyncStart* *FerretAsyncFinish* *FerretWillWrite* *FerretDidWrite*
" For maximum compatibility with other plug-ins, Ferret runs the following
" "User" autocommands before and after running the file writing operations
" during |:Acks| or |:Lacks|:
"
" - FerretWillWrite
" - FerretDidWrite
"
" For example, to call a pair of custom functions in response to these events,
" you might do:
"
" ```
" autocmd! User FerretWillWrite
" autocmd User FerretWillWrite call CustomWillWrite()
" autocmd! User FerretDidWrite
" autocmd User FerretDidWrite call CustomDidWrite()
" ```
"
" Additionally, Ferret runs these autocommands when an async search begins and
" ends:
"
" - FerretAsyncStart
" - FerretAsyncFinish
"
" # Overrides
"
" Ferret overrides the 'grepformat' and 'grepprg' settings, preferentially
" setting `rg`, `ag`, `ack` or `ack-grep` as the 'grepprg' (in that order) and
" configuring a suitable 'grepformat'.
"
" Additionally, Ferret includes an |ftplugin| for the |quickfix| listing that
" adjusts a number of settings to improve the usability of search results.
"
" @indent
"                                                                 *ferret-nolist*
"   ## 'nolist'
"
"   Turned off to reduce visual clutter in the search results, and because
"   'list' is most useful in files that are being actively edited, which is not
"   the case for |quickfix| results.
"
"                                                       *ferret-norelativenumber*
"   ## 'norelativenumber'
"
"   Turned off, because it is more useful to have a sense of absolute progress
"   through the results list than to have the ability to jump to nearby results
"   (especially seeing as the most common operations are moving to the next or
"   previous file, which are both handled nicely by |:cnf| and |:cpf|
"   respectively).
"
"                                                                 *ferret-nowrap*
"   ## 'nowrap'
"
"   Turned off to avoid ugly wrapping that makes the results list hard to read,
"   and because in search results, the most relevant information is the
"   filename, which is on the left and is usually visible even without wrapping.
"
"                                                                 *ferret-number*
"   ## 'number'
"
"   Turned on to give a sense of absolute progress through the results.
"
"                                                              *ferret-scrolloff*
"   ## 'scrolloff'
"
"   Set to 0 because the |quickfix| listing is usually small by default, so
"   trying to keep the current line away from the edge of the viewpoint is
"   futile; by definition it is usually near the edge.
"
"                                                           *ferret-nocursorline*
"   ## 'nocursorline'
"
"   Turned off to reduce visual clutter.
"
" @dedent
"
" To prevent any of these |quickfix|-specific overrides from being set up, you
" can set |g:FerretQFOptions| to 0 in your |.vimrc|:
"
" ```
" let g:FerretQFOptions=0
" ```
"
"
" # Troubleshooting
"
"                                                                 *ferret-quotes*
" ## Ferret fails to find patterns containing spaces
"
" As described in the documentation for |:Ack|, the search pattern is passed
" through as-is to the underlying search command, and no escaping is required
" other than preceding spaces by a single backslash.
"
" So, to find "foo bar", you would search like:
"
" ```
" :Ack foo\ bar
" ```
"
" Unescaped spaces in the search are treated as argument separators, so a
" command like the following means pass the `-w` option through, search for
" pattern "foo", and limit search to the "bar" directory:
"
" ```
" :Ack -w foo bar
" ```
"
" Note that wrapping in quotes will probably not do what you want.
"
" This, for example, is a search for `"foo` in the `bar"` directory:
"
" ```
" :Ack "foo bar"
" ```
"
" and this is a search for `'abc` in the `xyz'` directory:
"
" ```
" :Ack 'abc xyz'
" ```
"
" This approach to escaping is taken in order to make it straightfoward to use
" powerful Perl-compatible regular expression syntax in an unambiguous way
" without having to worry about shell escaping rules; for example:
"
" ```
" :Ack \blog\((['"]).*?\1\) -i --ignore-dir=src/vendor src dist build
" ```
"
" # FAQ
"
" ## Why do Ferret commands start with "Ack", "Lack" and so on?
"
" Ferret was originally the thinnest of wrappers (7 lines of code in my
" |.vimrc|) around `ack`. The earliest traces of it can be seen in the initial
" commit to my dotfiles repo in May, 2009 (https://wincent.dev/h).
"
" So, even though Ferret has a new name now and actually prefers `rg` then `ag`
" over `ack`/`ack-grep` when available, I prefer to keep the command names
" intact and benefit from years of accumulated muscle-memory.
"
"
" # Related
"
" Just as Ferret aims to improve the multi-file search and replace experience,
" Loupe does the same for within-file searching:
"
"   https://github.com/wincent/loupe
"
"
" # Website
"
" Source code:
"
"   https://github.com/wincent/ferret
"
" Official releases are listed at:
"
"   http://www.vim.org/scripts/script.php?script_id=5220
"
"
" # License
"
" Copyright 2015-present Greg Hurrell. All rights reserved.
"
" Redistribution and use in source and binary forms, with or without
" modification, are permitted provided that the following conditions are met:
"
" 1. Redistributions of source code must retain the above copyright notice,
"    this list of conditions and the following disclaimer.
"
" 2. Redistributions in binary form must reproduce the above copyright notice,
"    this list of conditions and the following disclaimer in the documentation
"    and/or other materials provided with the distribution.
"
" THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
" IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
" ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
" LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
" CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
" SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
" INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
" CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
" ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
" POSSIBILITY OF SUCH DAMAGE.
"
"
" # Development
"
" ## Contributing patches
"
" Patches can be sent via mail to greg@hurrell.net, or as GitHub pull requests
" at: https://github.com/wincent/ferret/pulls
"
" ## Cutting a new release
"
" At the moment the release process is manual:
"
" - Perform final sanity checks and manual testing
" - Update the |ferret-history| section of the documentation
" - Verify clean work tree:
"
" ```
" git status
" ```
"
" - Tag the release:
"
" ```
" git tag -s -m "$VERSION release" $VERSION
" ```
"
" - Publish the code:
"
" ```
" git push origin main --follow-tags
" git push github main --follow-tags
" ```
"
" - Produce the release archive:
"
" ```
" git archive -o ferret-$VERSION.zip HEAD -- .
" ```
"
" - Upload to http://www.vim.org/scripts/script.php?script_id=5220
"
"
" # Authors
"
" Ferret is written and maintained by Greg Hurrell <greg@hurrell.net>.
"
" Other contributors that have submitted patches include (in alphabetical
" order):
"
" - Andrew Macpherson
" - Daniel Silva
" - Filip Szymański
" - Joe Lencioni
" - Jon Parise
" - Nelo Wallus
" - Tom Dooner
" - Vaibhav Sagar
" - Yoni Weill
" - fent
"
" This list produced with:
"
" ```
" :read !git shortlog -s HEAD | grep -v 'Greg Hurrell' | cut -f 2-3 | sed -e 's/^/- /'
" ```
"
" # History
"
" ## main (not yet released)
"
" - Add |<Plug>(FerretBack)|, |<Plug>(FerretBlack)|, and |<Plug>(FerretQuack)|
"   targets for use in mappings (https://github.com/wincent/ferret/issues/79).
" - Fix hangs produced by options that take arguments in `rg` v13.0.0
"   (https://github.com/wincent/ferret/issues/82).
" - Fix |E42| and |E684| errors when deleting last item in listing, or trying to
"   delete from an empty listing (https://github.com/wincent/ferret/issues/83).
" - Add |g:FerretCommandNames| (https://github.com/wincent/ferret/issues/75).
"
" ## 5.1 (9 July 2021)
"
" - Add |g:FerretAckWordWord| setting, to pass `-w` to the underlying search
"   tool when |<Plug>(FerretAckWord)| is pressed
"   (https://github.com/wincent/ferret/issues/66).
" - Use `:normal!` instead of |:normal| to avoid running custom mappings
"   (patch from Yoni Weill, https://github.com/wincent/ferret/pull/67).
" - Append a trailing slash when autocompleting a directory name
"   (https://github.com/wincent/ferret/issues/69).
" - Fixed failure to detect pre-existing mapping to |<Plug>(FerretLack)|.
" - Worked around breakage caused by `rg` v13.0.0
"   (https://github.com/wincent/ferret/issues/78).
"
" ## 5.0 (8 June 2019)
"
" - The |<Plug>(FerretAcks)| mapping now uses |/\v| "very magic" mode by
"   default. This default can be changed using the |g:FerretVeryMagic| option.
" - |:Acks| now preferentially uses |:cdo| (rather than |:cfdo|) to make
"   replacements, which means that it no longer operates on a per-file level and
"   instead targets individual entries within the |quickfix| window. This is
"   relevant if you've used Ferrets mappings to delete entries from the window.
"   The old behavior can be restored with the |g:FerretAcksCommand| option.
" - Ferret now has a |:Lacks| command, an analog to |:Acks| which applies to the
"   |location-list|.
" - Likewise, Ferret now has a |:Largs| command, analogous to |:Qargs|, which
"   applies to the |location-list| instead of the |quickfix| window.
" - The Ferret bindings that are set-up in the |quickfix| window when
"   |g:FerretQFMap| is enabled now also apply to the |location-list|.
"
" ## 4.1 (31 January 2019)
"
" - Added |:Quack| command, analogous to |:Ack| but scoped to the files
"   currently listed in the |quickfix| window.
" - Fixed option autocompletion.
"
" ## 4.0.2 (11 January 2019)
"
" - Restore compatibility with versions of `rg` prior to v0.8
"   (https://github.com/wincent/ferret/issues/59).
"
" ## 4.0.1 (8 January 2019)
"
" - Make |:Acks| behavior the same irrespective of the |'gdefault'| setting.
"
" ## 4.0 (25 December 2018)
"
" - Try to avoid "press ENTER to continue" prompts.
" - Put search term in |w:quickfix_title| for use in statuslines
"   (https://github.com/wincent/ferret/pull/57).
" - Add |g:FerretExecutableArguments| and |ferret#get_default_arguments()|
"   (https://github.com/wincent/ferret/pull/46).
"
" ## 3.0.3 (23 March 2018)
"
" - Fix for |:Lack| results opening in quickfix listing in Neovim
"   (https://github.com/wincent/ferret/issues/47).
"
" ## 3.0.2 (25 October 2017)
"
" - Fix broken |:Back| and |:Black| commands
"   (https://github.com/wincent/ferret/issues/48).
"
" ## 3.0.1 (24 August 2017)
"
" - Fix failure to handle search patterns containing multiple escaped spaces
"   (https://github.com/wincent/ferret/issues/49).
"
" ## 3.0 (13 June 2017)
"
" - Improve handling of backslash escapes
"   (https://github.com/wincent/ferret/issues/41).
" - Add |g:FerretAutojump|.
" - Drop support for vim-dispatch.
"
" ## 2.0 (6 June 2017)
"
" - Add support for Neovim, along with |g:FerretNvim| setting.
"
" ## 1.5 "Cinco de Cuatro" (4 May 2017)
"
" - Improvements to the handling of very large result sets (due to wide lines or
"   many results).
" - Added |g:FerretLazyInit|.
" - Added missing documentation for |g:FerretJob|.
" - Added |g:FerretMaxResults|.
" - Added feature-detection for `rg` and `ag`, allowing Ferret to gracefully
"   work with older versions of those tools that do not support all desired
"   command-line switches.
"
" ## 1.4 (21 January 2017)
"
" - Drop broken support for `grep`, printing a prompt to install `rg`, `ag`, or
"   `ack`/`ack-grep` instead.
" - If an `ack` executable is not found, search for `ack-grep`, which is the
"   name used on Debian-derived distros.
"
" ## 1.3 (8 January 2017)
"
" - Reset |'errorformat'| before each search (fixes issue #31).
" - Added |:Back| and |:Black| commands, analogous to |:Ack| and |:Lack| but
"   scoped to search within currently open buffers only.
" - Change |:Acks| to use |:cfdo| when available rather than |:Qargs| and
"   |:argdo|, to avoid polluting the |arglist|.
" - Remove superfluous |QuickFixCmdPost| autocommands, resolving clash with
"   Neomake plug-in (patch from Tom Dooner, #36).
" - Add support for searching with ripgrep (`rg`).
"
" ## 1.2a (16 May 2016)
"
" - Add optional support for running searches asynchronously using Vim's |+job|
"   feature (enabled by default in sufficiently recent versions of Vim); see
"   |g:FerretJob|, |:FerretCancelAsync| and |:FerretPullAsync|.
"
" ## 1.1.1 (7 March 2016)
"
" - Fix another edge case when searching for patterns containing "#", only
"   manifesting under dispatch.vim.
"
" ## 1.1 (7 March 2016)
"
" - Fix edge case when searching for strings of the form "<foo>".
" - Fix edge case when searching for patterns containing "#" and "%".
" - Provide completion for `ag` and `ack` options when using |:Ack| and |:Lack|.
" - Fix display of error messages under dispatch.vim.
"
" ## 1.0 (28 December 2015)
"
" - Fix broken |:Qargs| command (patch from Daniel Silva).
" - Add |g:FerretQFHandler| and |g:FerretLLHandler| options (patch from Daniel
"   Silva).
" - Make |<Plug>| mappings accessible even |g:FerretMap| is set to 0.
" - Fix failure to report filename when using `ack` and explicitly scoping
"   search to a single file (patch from Daniel Silva).
" - When using `ag`, report multiple matches per line instead of just the first
"   (patch from Daniel Silva).
" - Improve content and display of error messages.
"
" ## 0.3 (24 July 2015)
"
" - Added highlighting of search pattern and related |g:FerretHlsearch| option
"   (patch from Nelo-Thara Wallus).
" - Add better error reporting for failed or incorrect searches.
"
" ## 0.2 (16 July 2015)
"
" - Added |FerretDidWrite| and |FerretWillWrite| autocommands (patch from Joe
"   Lencioni).
" - Add |<Plug>(FerretAcks)| mapping (patch from Nelo-Thara Wallus).
"
" ## 0.1 (8 July 2015)
"
" - Initial release, extracted from my dotfiles
"   (https://github.com/wincent/wincent).

""
" @option g:FerretLoaded any
"
" To prevent Ferret from being loaded, set |g:FerretLoaded| to any value in your
" |.vimrc|. For example:
"
" ```
" let g:FerretLoaded=1
" ```
if exists('g:FerretLoaded') || &compatible || v:version < 700
  finish
endif
let g:FerretLoaded = 1

" Temporarily set 'cpoptions' to Vim default as per `:h use-cpo-save`.
let s:cpoptions = &cpoptions
set cpoptions&vim

""
" @option g:FerretLazyInit boolean 1
"
" In order to minimize impact on Vim start-up time Ferret will initialize itself
" lazily on first use by default. If you wish to force immediate initialization
" (for example, to cause |'grepprg'| and |'grepformat'| to be set as soon as Vim
" launches), then set |g:FerretLazyInit| to 0 in your |.vimrc|:
"
" ```
" let g:FerretLazyInit=0
" ```
if !get(g:, 'FerretLazyInit', 1)
  call ferret#private#init()
endif

""
" @option g:FerretCommandNames dictionary {}
"
" Ferret's command names are mostly chosen because the plugin started as a
" simple `ack` wrapper. As related commands were added over time, a pattern
" involving common suffixes evolved, to make the commands easy to remember
" (even once Ferret started offering support for non-`ack` tools, such as
" `ag` and `rg`). As such, |:Ack|, |:Back|, |:Black|, |:Lack|, and |:Quack|
" are all commands, as are the variants |:Acks| and |:Lacks|, along with
" |:Qargs| and |:Largs|. Exceptions to the pattern are |:FerretCancelAsync| and
" |:FerretPullAsync|.
"
" Should you wish to override any or all of these names, you may define
" |g:FerretCommandNames| early on in your |.vimrc| (before Ferret is loaded),
" and it will use the specified names instead, falling back to the defaults for
" any undefined commands. For example, to use `:Rg` in place of the |:Ack|
" command, and `:Rgb` in place of |:Back|, but keep using the standard names for
" all other commands, you would write:
"
" ```
" let g:FerretCommandNames={'Ack': 'Rg', 'Back': 'Rgb'}
" ```
"
" Overriding may be useful to avoid conflicts with other plug-ins that compete
" to define commands with the same names, or simply to match personal
" preferences.
let s:FerretCommandNames={
      \   'Ack': 'Ack',
      \   'Acks': 'Acks',
      \   'Back': 'Back',
      \   'Black': 'Black',
      \   'FerretCancelAsync': 'FerretCancelAsync',
      \   'FerretPullAsync': 'FerretPullAsync',
      \   'Lack': 'Lack',
      \   'Lacks': 'Lacks',
      \   'Largs': 'Largs',
      \   'Qargs': 'Qargs',
      \   'Quack': 'Quack'
      \ }
let s:FerretCommandNameOverrides=get(g:, 'FerretCommandNames', {})
if type(s:FerretCommandNameOverrides) == v:t_dict
  for [command, alias] in items(s:FerretCommandNameOverrides)
    if has_key(s:FerretCommandNames, command)
      if type(alias) == v:t_string &&
            \ match(alias, '\v\C^[A-Z][A-Za-z]*$') == 0
        let s:FerretCommandNames[command]=alias
      else
        echoerr 'Skipping bad alias for command ' . command . ' in g:FerretCommandNames'
      end
    else
      echoerr 'Skipping bad command name ' . command . ' in g:FerretCommandNames'
    endif
  endfor
endif

""
" @command :Ack {pattern} {options}
"
" Searches for {pattern} in all the files under the current directory (see
" |:pwd|), unless otherwise overridden via {options}, and displays the results
" in the |quickfix| listing.
"
" `rg` (ripgrep) then `ag` (The Silver Searcher) will be used preferentially if
" present on the system, because they are faster, falling back to
" `ack`/`ack-grep` as needed.
"
" On newer versions of Vim (version 8 and above), the search process runs
" asynchronously in the background and does not block the UI.
"
" Asynchronous searches are preferred because they do not block, despite the
" fact that Vim itself is single threaded.
"
" The {pattern} is passed through as-is to the underlying search program, and no
" escaping is required other than preceding spaces by a single backslash. For
" example, to search for "\bfoo[0-9]{2} bar\b" (ie. using `ag`'s Perl-style
" regular expression syntax), you could do:
"
" ```
" :Ack \bfoo[0-9]{2}\ bar\b
" ```
"
" Likewise, {options} are passed through. In this example, we pass the `-w`
" option (to search on word boundaries), and scope the search to the "foo" and
" "bar" subdirectories:
"
" ```
" :Ack -w something foo bar
" ```
"
" As a convenience `<Leader>a` is set-up (|<Plug>(FerretAck)|) as a shortcut to
" enter |Cmdline-mode| with `:Ack` inserted on the |Cmdline|. Likewise `<Leader>s`
" (|<Plug>(FerretAckWord)|) is a shortcut for running |:Ack| with the word
" currently under the cursor.
"
" @command :Ack! {pattern} {options}
"
" Like |:Ack|, but returns all results irrespective of the value of
" |g:FerretMaxResults|.
"
execute 'command! -bang -nargs=1 -complete=customlist,ferret#private#ackcomplete ' .
      \ s:FerretCommandNames['Ack'] .
      \ ' call ferret#private#ack(<bang>0, <q-args>)'

""
" @command :Lack {pattern} {options}
"
" Just like |:Ack|, but instead of using the |quickfix| listing, which is global
" across an entire Vim instance, it uses the |location-list|, which is a
" per-window construct.
"
" Note that |:Lack| always runs synchronously via |:cexpr|.
"
" @command :Lack! {pattern} {options}
"
" Like |:Lack|, but returns all results irrespective of the value of
" |g:FerretMaxResults|.
"
execute 'command! -bang -nargs=1 -complete=customlist,ferret#private#lackcomplete ' .
      \ s:FerretCommandNames['Lack'] .
      \ ' call ferret#private#lack(<bang>0, <q-args>)'

""
" @command :Back {pattern} {options}
"
" Like |:Ack|, but searches only listed buffers. Note that the search is still
" delegated to the underlying |'grepprg'| (`rg`, `ag`, `ack` or `ack-grep`),
" which means that only buffers written to disk will be searched. If no buffers
" are written to disk, then |:Back| behaves exactly like |:Ack| and will search
" all files in the current directory.
"
" @command :Back! {pattern} {options}
"
" Like |:Back|, but returns all results irrespective of the value of
" |g:FerretMaxResults|.
"
execute 'command! -bang -nargs=1 -complete=customlist,ferret#private#backcomplete ' .
      \ s:FerretCommandNames['Back'] .
      \ ' call ferret#private#back(<bang>0, <q-args>)'

""
" @command :Black {pattern} {options}
"
" Like |:Lack|, but searches only listed buffers. As with |:Back|, the search is
" still delegated to the underlying |'grepprg'| (`rg`, `ag`, `ack` or
" `ack-grep`), which means that only buffers written to disk will be searched.
" Likewise, If no buffers are written to disk, then |:Black| behaves exactly
" like |:Lack| and will search all files in the current directory.
"
" @command :Black! {pattern} {options}
"
" Like |:Black|, but returns all results irrespective of the value of
" |g:FerretMaxResults|.
"
execute 'command! -bang -nargs=1 -complete=customlist,ferret#private#blackcomplete ' .
      \ s:FerretCommandNames['Black'] .
      \ ' call ferret#private#black(<bang>0, <q-args>)'

""
" @command :Quack {pattern} {options}
"
" Like |:Ack|, but searches only among files currently in the |quickfix|
" listing. Note that the search is still delegated to the underlying
" |'grepprg'| (`rg`, `ag`, `ack` or `ack-grep`), which means that only
" buffers written to disk will be searched. If no buffers are written
" to disk, then |:Quack| behaves exactly like |:Ack| and will search all
" files in the current directory.
"
" @command :Quack! {pattern} {options}
"
" Like |:Quack|, but returns all results irrespective of the value of
" |g:FerretMaxResults|.
"
execute 'command! -bang -nargs=1 -complete=customlist,ferret#private#quackcomplete ' .
      \ s:FerretCommandNames['Quack'] .
      \ ' call ferret#private#quack(<bang>0, <q-args>)'

""
" @command :Acks /{pattern}/{replacement}/
"
" Takes all of the files currently in the |quickfix| listing and performs a
" substitution of all instances of {pattern} (a standard Vim search |pattern|)
" by {replacement}.
"
" A typical sequence consists of an |:Ack| invocation to populate the |quickfix|
" listing and then |:Acks| (mnemonic: "Ack substitute") to perform replacements.
" For example, to replace "foo" with "bar" across all files in the current
" directory:
"
" ```
" :Ack foo
" :Acks /foo/bar/
" ```
"
" The pattern and replacement are passed through literally to Vim's
" |:substitute| command, preserving all characters and escapes,
" including references to matches in the pattern. For example, the
" following could be used to swap the order of "foo123" and "bar":
"
" ```
" :Acks /\v(foo\d+)(bar)/\2\1/
" ```
execute 'command! -nargs=1 ' .
      \ s:FerretCommandNames['Acks'] .
      \ ' call ferret#private#acks(<q-args>, "qf")'

""
" @command :Lacks /{pattern}/{replacement}/
"
" Takes all of the files in the current |location-list| and performs a
" substitution of all instances of {pattern} by {replacement}. This is an analog
" of the |:Acks| command, but operates on the |location-list| instead of the
" |quickfix| listing.
"
execute 'command! -nargs=1 ' .
      \ s:FerretCommandNames['Lacks'] .
      \ ' call ferret#private#acks(<q-args>, "location")'

""
" @command :FerretCancelAsync
"
" Cancels any asynchronous search that may be in progress in the background.
"
execute 'command! ' .
      \ s:FerretCommandNames['FerretCancelAsync'] .
      \ ' call ferret#private#async#cancel()'

""
" @command :FerretPullAsync
"
" Eagerly populates the |quickfix| (or |location-list|) window with any results
" that may have been produced by a long-running asynchronous search in progress
" in the background.
"
execute 'command! ' .
      \ s:FerretCommandNames['FerretPullAsync'] .
      \ ' call ferret#private#async#pull()'

nnoremap <Plug>(FerretAck) :Ack<space>
nnoremap <Plug>(FerretLack) :Lack<space>

""
" @mapping <Plug>(FerretBack)
"
" Ferret provides |<Plug>(FerretBack)| which can be used to trigger the |:Back|
" command. To configure a mapping for it, use |:nmap|:
"
" ```
" nmap <Leader>fb <Plug>(FerretBack)
" ```
nnoremap <Plug>(FerretBack) :Back<space>

""
" @mapping <Plug>(FerretBlack)
"
" Ferret provides |<Plug>(FerretBlack)| which can be used to trigger the |:Black|
" command. To configure a mapping for it, use |:nmap|:
"
" ```
" nmap <Leader>fl <Plug>(FerretBlack)
" ```
nnoremap <Plug>(FerretBlack) :Black<space>

""
" @mapping <Plug>(FerretQuack)
"
" Ferret provides |<Plug>(FerretBack)| which can be used to trigger the |:Quack|
" command. To configure a mapping for it, use |:nmap|:
"
" ```
" nmap <Leader>fq <Plug>(FerretQuack)
" ```
nnoremap <Plug>(FerretQuack) :Quack<space>

""
" @option g:FerretAckWordWord boolean 0
"
" When set to 1, passes the `-w` option to the underlying search tool whenever
" |<Plug>(FerretAckWord)| is pressed. This forces the tool to match only on word
" boundaries (ie. analagous to Vim's |star| mapping).
"
" The default is 0, which means the `-w` option is not passed and matches need
" not occur on word boundaries (ie. analagous to Vim's |gstar| mapping).
"
" To override the default:
"
" ```
" let g:FerretAckWordWord=1
" ```
let s:word=get(g:, 'FerretAckWordWord', 0)
if s:word
  nnoremap <Plug>(FerretAckWord) :Ack -w <C-r><C-w><CR>
else
  nnoremap <Plug>(FerretAckWord) :Ack <C-r><C-w><CR>
endif

nnoremap <Plug>(FerretAcks) :Acks <c-r>=(ferret#private#acks_prompt())<CR><Left><Left>

""
" @option g:FerretMap boolean 1
"
" Controls whether to set up the Ferret mappings, such as |<Plug>(FerretAck)|
" (see |ferret-mappings| for a full list). To prevent any mapping from being
" configured, set to 0:
"
" ```
" let g:FerretMap=0
" ```
let s:map=get(g:, 'FerretMap', 1)
if s:map
  if !hasmapto('<Plug>(FerretAck)') && maparg('<Leader>a', 'n') ==# ''
    ""
    " @mapping <Plug>(FerretAck)
    "
    " Ferret maps `<Leader>a` to |<Plug>(FerretAck)|, which triggers the |:Ack|
    " command. To use an alternative mapping instead, create a different one in
    " your |.vimrc| instead using |:nmap|:
    "
    " ```
    " " Instead of <Leader>a, use <Leader>x.
    " nmap <Leader>x <Plug>(FerretAck)
    " ```
    nmap <unique> <Leader>a <Plug>(FerretAck)
  endif

  if !hasmapto('<Plug>(FerretLack)') && maparg('<Leader>l', 'n') ==# ''
    ""
    " @mapping <Plug>(FerretLack)
    "
    " Ferret maps `<Leader>l` to |<Plug>(FerretLack)|, which triggers the |:Lack|
    " command. To use an alternative mapping instead, create a different one in
    " your |.vimrc| instead using |:nmap|:
    "
    " ```
    " " Instead of <Leader>l, use <Leader>y.
    " nmap <Leader>y <Plug>(FerretLack)
    " ```
    nmap <unique> <Leader>l <Plug>(FerretLack)
  endif

  if !hasmapto('<Plug>(FerretAckWord)') && maparg('<Leader>s', 'n') ==# ''
    ""
    " @mapping <Plug>(FerretAckWord)
    "
    " Ferret maps `<Leader>s` (mnemonic: "selection) to |<Plug>(FerretAckWord)|,
    " which uses |:Ack| to search for the word currently under the cursor. To
    " use an alternative mapping instead, create a different one in your
    " |.vimrc| instead using |:nmap|:
    "
    " ```
    " " Instead of <Leader>s, use <Leader>z.
    " nmap <Leader>z <Plug>(FerretAckWord)
    " ```
    nmap <unique> <Leader>s <Plug>(FerretAckWord)
  endif

  if !hasmapto('<Plug>(FerretAcks)') && maparg('<Leader>r', 'n') ==# ''
    ""
    " @mapping <Plug>(FerretAcks)
    "
    " Ferret maps `<Leader>r` (mnemonic: "replace") to |<Plug>(FerretAcks)|, which
    " triggers the |:Acks| command and fills the prompt with the last search
    " term from Ferret. to use an alternative mapping instead, create a
    " different one in your |.vimrc| instead using |:nmap|:
    "
    " ```
    " " Instead of <Leader>r, use <Leader>u.
    " nmap <Leader>u <Plug>(FerretAcks)
    " ```
    nmap <unique> <Leader>r <Plug>(FerretAcks)
  endif
endif

""
" @command :Qargs
"
" This is a utility function that is used internally when running on older
" versions of Vim (prior to version 8) but is also generally useful enough to
" warrant being exposed publicly.
"
" It takes the files currently in the |quickfix| listing and sets them as
" |:args| so that they can be operated on en masse via the |:argdo| command.
execute 'command! -bar ' .
      \ s:FerretCommandNames['Qargs'] .
      \ ' execute "args" ferret#private#args("qf")'

""
" @command :Largs
"
" Just like |:Qargs|, but applies to the current |location-list|.
"
" It takes the files in the current |location-list| and sets them as
" |:args| so that they can be operated on en masse via the |:argdo| command.
execute 'command! -bar ' .
      \ s:FerretCommandNames['Largs'] .
      \ ' execute "args" ferret#private#args("location")'

""
" @option g:FerretQFCommands boolean 1
"
" Controls whether to set up custom versions of the |quickfix| commands, |:cn|,
" |:cnf|, |:cp| an |:cpf|. These overrides vertically center the match within
" the viewport on each jump. To prevent the custom versions from being
" configured, set to 0:
"
" ```
" let g:FerretQFCommands=0
" ```
let s:commands=get(g:, 'FerretQFCommands', 1)
if s:commands
  " Keep quickfix result centered, if possible, when jumping from result to result.
  cabbrev <silent> <expr> cn ((getcmdtype() == ':' && getcmdpos() == 3) ? 'cn <bar> normal! zz' : 'cn')
  cabbrev <silent> <expr> cnf ((getcmdtype() == ':' && getcmdpos() == 4) ? 'cnf <bar> normal! zz' : 'cnf')
  cabbrev <silent> <expr> cp ((getcmdtype() == ':' && getcmdpos() == 3) ? 'cp <bar> normal! zz' : 'cp')
  cabbrev <silent> <expr> cpf ((getcmdtype() == ':' && getcmdpos() == 4) ? 'cpf <bar> normal! zz' : 'cpf')
endif

""
" @option g:FerretFormat string "%f:%l:%c:%m"
"
" Sets the '|grepformat|' used by Ferret.
let g:FerretFormat=get(g:, 'FerretFormat', '%f:%l:%c:%m')

" Restore 'cpoptions' to its former value.
let &cpoptions = s:cpoptions
unlet s:cpoptions
