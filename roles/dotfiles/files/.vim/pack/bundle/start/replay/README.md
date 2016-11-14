# replay<a name="replay-replay" href="#user-content-replay-replay"></a>

## Intro<a name="replay-intro" href="#user-content-replay-intro"></a>

Replay sets up a mapping (<strong>`<CR>`</strong> by default) to execute the last recorded macro.

Without Replay, you can execute a macro in register "q" by hitting <strong>`@`</strong> followed by "q", but that is relatively uncomfortable to type. Once you've played the macro back once, you can play it again with <strong>`@@`</strong>, which is easier but still not as comfortable as just hitting <strong>`<CR>`</strong>.

<strong>`<CR>`</strong> is chosen because its standard behavior is not super useful (moves down a line, placing the cursor on the first non-blank character). You can still use <strong>`+`</strong> to the same effect, or an alternative like <strong>`j`</strong> which is similar but does not move to the first non-blank character.

Replay won't do anything in "special" buffers such as <strong>`quickfix`</strong> listings or [NERDTree](https://github.com/scrooloose/nerdtree) explorers, because in those the <strong>`<CR>`</strong> actually does have useful navigation behavior.

## Implementation<a name="replay-implementation" href="#user-content-replay-implementation"></a>

I originally had this idea implemented as a simple mapping of <strong>`<CR>`</strong> to <strong>`@@`</strong>, but that was problematic for a couple of reasons: <strong>`@@`</strong> would only replay the last executed macro, which meant that on the first run it would complain with error <strong>`E748`</strong> that there was "No previously used register"; this behavior was confusing because it would still work, sometimes, based on information recovered from the <strong>`viminfo`</strong> file. If you're one of those who mostly records into the "q" register, this meant that the mapping usually worked, but not always, which is a pretty annoying state of affairs.

As such, Replay tries to provide "last recorded" rather than "last executed" semantics. It does this by overriding the <strong>`q`</strong> mapping to take a snapshot of the current register state when recording a macro. When you hit <strong>`<CR>`</strong>, it figures out which register was updated and executes that one.

Note that this is an imprecise art because Vim doesn't provide any hooks that would allow you to know for sure which is the last-modified register (for example if you recorded to multiple registers); Replay will detect the first one with updated contents.

Once you've replayed a macro once with <strong>`<CR>`</strong>, you can mash it repeatedly at will. You can also make use of recursion (ie. hitting <strong>`<CR>`</strong> during a macro recording) like you would recording any other Vim macro (although note that <strong>`<CR>`</strong> won't do anything during recording, only during playback).

If you then execute a macro from a different register (say, "w"), then hitting <strong>`<CR>`</strong> will repeat that macro instead of the last recorded one. This behavior is based on the notion that you usually want to repeat the last thing you did, whether that be the last thing you recorded or the last thing you executed, whichever happened later.

Note that the heuristic here will do what you want most of the time, but it is not infallible. For example, you could record into register "q", then play back register "w", and when you hit <strong>`<CR>`</strong> Replay will execute register "q" rather than "w". This is due to the lack of hooks already mentioned above.

## Installation<a name="replay-installation" href="#user-content-replay-installation"></a>

To install Replay, use your plug-in management system of choice.

If you don't have a "plug-in management system of choice" and your version of Vim has `packages` support (ie. `+packages` appears in the output of `:version`) then you can simply place the plugin at a location under your `'packpath'` (eg. `~/.vim/pack/bundle/start/replay` or similar).

For older versions of Vim, I recommend [Pathogen](https://github.com/tpope/vim-pathogen) due to its simplicity and robustness. Assuming that you have Pathogen installed and configured, and that you want to install Replay into `~/.vim/bundle`, you can do so with:

```
git clone https://github.com/wincent/replay.git ~/.vim/bundle/replay
```

Alternatively, if you use a Git submodule for each Vim plug-in, you could do the following after `cd`-ing into the top-level of your Git superproject:

```
git submodule add https://github.com/wincent/replay.git ~/vim/bundle/replay
git submodule init
```

To generate help tags under Pathogen, you can do so from inside Vim with:

```
:call pathogen#helptags()
```

## Website<a name="replay-website" href="#user-content-replay-website"></a>

The official Replay source code repo is at:

http://git.wincent.com/replay.git

Mirrors exist at:

- https://github.com/wincent/replay
- https://gitlab.com/wincent/replay
- https://bitbucket.org/ghurrell/replay

Official releases are listed at:

http://www.vim.org/scripts/script.php?script_id=5483

## License<a name="replay-license" href="#user-content-replay-license"></a>

Copyright (c) 2016-present Greg Hurrell

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Development<a name="replay-development" href="#user-content-replay-development"></a>

### Contributing patches<a name="replay-contributing-patches" href="#user-content-replay-contributing-patches"></a>

Patches can be sent via mail to greg@hurrell.net, or as GitHub pull requests at: https://github.com/wincent/replay/pulls

### Cutting a new release<a name="replay-cutting-a-new-release" href="#user-content-replay-cutting-a-new-release"></a>

At the moment the release process is manual:

- Perform final sanity checks and manual testing.
- Update the [replay-history](#user-content-replay-history) section of the documentation.
- Regenerate the documentation:

```
docvim README.md doc/replay.txt
```

- Verify clean work tree:

```
git status
```

- Tag the release:

```
git tag -s -m "$VERSION release" $VERSION
```

- Publish the code:

```
git push origin master --follow-tags
git push github master --follow-tags
```

- Produce the release archive:

```
git archive -o replay-$VERSION.zip HEAD -- .
```

- Upload to http://www.vim.org/scripts/script.php?script_id=5483

## Authors<a name="replay-authors" href="#user-content-replay-authors"></a>

Replay is written and maintained by Greg Hurrell <greg@hurrell.net>.

## History<a name="replay-history" href="#user-content-replay-history"></a>

### 0.1 (14 November 2016)<a name="replay-01-14-november-2016" href="#user-content-replay-01-14-november-2016"></a>

- Initial release.
