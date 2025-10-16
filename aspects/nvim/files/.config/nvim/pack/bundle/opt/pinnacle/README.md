# Pinnacle<a name="pinnacle-pinnacle" href="#user-content-pinnacle-pinnacle"></a>

## Intro<a name="pinnacle-intro" href="#user-content-pinnacle-intro"></a>

Pinnacle provides functions for manipulating <strong>`:highlight`</strong> groups in Vimscript (eg. <strong>`pinnacle#italicize`</strong>) and Lua (eg. `require'wincent.pinnacle'.italicize()`).

## Installation<a name="pinnacle-installation" href="#user-content-pinnacle-installation"></a>

To install Pinnacle, use your plug-in management system of choice.

If you don't have a &quot;plug-in management system of choice&quot;, I recommend Pathogen (https://github.com/tpope/vim-pathogen) due to its simplicity and robustness. Assuming that you have Pathogen installed and configured, and that you want to install Pinnacle into `~/.vim/bundle`, you can do so with:

```
git clone https://github.com/wincent/pinnacle.git ~/.vim/bundle/pinnacle
```

Alternatively, if you use a Git submodule for each Vim plug-in, you could do the following after `cd`-ing into the top-level of your Git superproject:

```
git submodule add https://github.com/wincent/pinnacle.git ~/vim/bundle/pinnacle
git submodule init
```

To generate help tags under Pathogen, you can do so from inside Vim with:

```
:call pathogen#helptags()
```

## Functions<a name="pinnacle-functions" href="#user-content-pinnacle-functions"></a>

<p align="right"><a name="pinnaclesubnewlines" href="#user-content-pinnaclesubnewlines"><code>pinnacle#sub_newlines()</code></a></p>

### `pinnacle#sub_newlines()`<a name="pinnacle-pinnaclesubnewlines" href="#user-content-pinnacle-pinnaclesubnewlines"></a>

Replaces newlines with spaces.

Note that this function is not implemented in the Lua API, because it is required only for support on legacy Vim versions.

<p align="right"><a name="pinnaclecaptureline" href="#user-content-pinnaclecaptureline"><code>pinnacle#capture_line()</code></a></p>

### `pinnacle#capture_line()`<a name="pinnacle-pinnaclecaptureline" href="#user-content-pinnacle-pinnaclecaptureline"></a>

Runs a command and returns the captured output as a single line.

Useful when we don't want to let long lines on narrow windows produce unwanted embedded newlines.

Note that this function is not implemented in the Lua API, because it is required only for support on legacy Vim versions.

<p align="right"><a name="pinnaclecapturehighlight" href="#user-content-pinnaclecapturehighlight"><code>pinnacle#capture_highlight()</code></a></p>

### `pinnacle#capture_highlight()`<a name="pinnacle-pinnaclecapturehighlight" href="#user-content-pinnacle-pinnaclecapturehighlight"></a>

Gets the current value of a highlight group.

<p align="right"><a name="pinnacleextracthighlight" href="#user-content-pinnacleextracthighlight"><code>pinnacle#extract_highlight()</code></a></p>

### `pinnacle#extract_highlight()`<a name="pinnacle-pinnacleextracthighlight" href="#user-content-pinnacle-pinnacleextracthighlight"></a>

Extracts a highlight string from a group, recursively traversing linked groups, and returns a string suitable for passing to `:highlight`.

<p align="right"><a name="pinnacleextractbg" href="#user-content-pinnacleextractbg"><code>pinnacle#extract_bg()</code></a></p>

### `pinnacle#extract_bg()`<a name="pinnacle-pinnacleextractbg" href="#user-content-pinnacle-pinnacleextractbg"></a>

Extracts just the bg portion of the specified highlight group.

<p align="right"><a name="pinnacleextractfg" href="#user-content-pinnacleextractfg"><code>pinnacle#extract_fg()</code></a></p>

### `pinnacle#extract_fg()`<a name="pinnacle-pinnacleextractfg" href="#user-content-pinnacle-pinnacleextractfg"></a>

Extracts just the bg portion of the specified highlight group.

<p align="right"><a name="pinnacleextractcomponent" href="#user-content-pinnacleextractcomponent"><code>pinnacle#extract_component()</code></a></p>

### `pinnacle#extract_component()`<a name="pinnacle-pinnacleextractcomponent" href="#user-content-pinnacle-pinnacleextractcomponent"></a>

Extracts a single component (eg. &quot;bg&quot;, &quot;fg&quot;, &quot;italic&quot; etc) from the specified highlight group.

<p align="right"><a name="pinnacledump" href="#user-content-pinnacledump"><code>pinnacle#dump()</code></a></p>

### `pinnacle#dump()`<a name="pinnacle-pinnacledump" href="#user-content-pinnacle-pinnacledump"></a>

Returns a dictionary representation of the specified highlight group.

<p align="right"><a name="pinnaclehighlight" href="#user-content-pinnaclehighlight"><code>pinnacle#highlight()</code></a></p>

### `pinnacle#highlight()`<a name="pinnacle-pinnaclehighlight" href="#user-content-pinnacle-pinnaclehighlight"></a>

Returns a string representation of a dictionary containing bg, fg, term, cterm and guiterm entries.

<p align="right"><a name="pinnacleitalicize" href="#user-content-pinnacleitalicize"><code>pinnacle#italicize()</code></a></p>

### `pinnacle#italicize()`<a name="pinnacle-pinnacleitalicize" href="#user-content-pinnacle-pinnacleitalicize"></a>

Returns an italicized copy of `group` suitable for passing to `:highlight`.

<p align="right"><a name="pinnacleembolden" href="#user-content-pinnacleembolden"><code>pinnacle#embolden()</code></a></p>

### `pinnacle#embolden()`<a name="pinnacle-pinnacleembolden" href="#user-content-pinnacle-pinnacleembolden"></a>

Returns a bold copy of `group` suitable for passing to `:highlight`.

<p align="right"><a name="pinnacleunderline" href="#user-content-pinnacleunderline"><code>pinnacle#underline()</code></a></p>

### `pinnacle#underline()`<a name="pinnacle-pinnacleunderline" href="#user-content-pinnacle-pinnacleunderline"></a>

Returns an underlined copy of `group` suitable for passing to `:highlight`.

<p align="right"><a name="pinnacledecorate" href="#user-content-pinnacledecorate"><code>pinnacle#decorate()</code></a></p>

### `pinnacle#decorate()`<a name="pinnacle-pinnacledecorate" href="#user-content-pinnacle-pinnacledecorate"></a>

Returns a copy of `group` decorated with `style` (eg. &quot;bold&quot;, &quot;italic&quot; etc) suitable for passing to `:highlight`.

To decorate with multiple styles, `style` should be a comma-separated list.

## Website<a name="pinnacle-website" href="#user-content-pinnacle-website"></a>

Source code:

- https://github.com/wincent/pinnacle
- https://gitlab.com/wincent/pinnacle
- https://bitbucket.org/ghurrell/pinnacle

Official releases are listed at:

http://www.vim.org/scripts/script.php?script_id=5360

## License<a name="pinnacle-license" href="#user-content-pinnacle-license"></a>

Copyright (c) 2016-present Greg Hurrell

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the &quot;Software&quot;), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Development<a name="pinnacle-development" href="#user-content-pinnacle-development"></a>

### Contributing patches<a name="pinnacle-contributing-patches" href="#user-content-pinnacle-contributing-patches"></a>

Patches can be sent via mail to greg@hurrell.net, or as GitHub pull requests at: https://github.com/wincent/pinnacle/pulls

### Cutting a new release<a name="pinnacle-cutting-a-new-release" href="#user-content-pinnacle-cutting-a-new-release"></a>

At the moment the release process is manual:

- Perform final sanity checks and manual testing
- Update the <strong>[`pinnacle-history`](#user-content-pinnacle-history)</strong> section of the documentation
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
git push origin main --follow-tags
git push github main --follow-tags
```

- Produce the release archive:

```
git archive -o pinnacle-$VERSION.zip HEAD -- .
```

- Upload to http://www.vim.org/scripts/script.php?script_id=5360

## Authors<a name="pinnacle-authors" href="#user-content-pinnacle-authors"></a>

Pinnacle is written and maintained by Greg Hurrell &lt;greg@hurrell.net&gt;.

Other contributors that have submitted patches include (in alphabetical order):

- Cody Buell
- Khue Nguyen
- Kyle Poole

## History<a name="pinnacle-history" href="#user-content-pinnacle-history"></a>

### main (not yet released)<a name="pinnacle-main-not-yet-released" href="#user-content-pinnacle-main-not-yet-released"></a>

- Taught `pinnacle#decorate()` to accept a comma-separated list of styles.
- Added alternative Lua-based API (eg. `require'wincent.pinnacle'.italicize()` is equivalent to `pinnacle#italicize()` etc); but note:
- Removed functions that aren't needed in the Lua API: `pinnacle.extract_bg()`, `pinnacle.capture_highlight()`, `pinnacle.extract_component()`, `pinnacle.extract_fg()`, `pinnacle.extract_highlight()`, and `pinnacle.highlight()`. Equivalent functionality can be obtained by using the convenience functions listed below, along with `pinnacle.decorate()` and `pinnacle.dump()`.
- Added convenience functions for common operations to the Lua API: `pinnacle.bg()`, `pinnacle.clear()`, `pinnacle.fg()`, `pinnacle.link()`, `pinnacle.merge()`, and `pinnacle.set()`.
- Added utility functions to the Lua API: `pinnacle.adjust_lightness()`, `pinnacle.brighten()` and `pinnacle.darken()`.

### 1.0 (6 March 2019)<a name="pinnacle-10-6-march-2019" href="#user-content-pinnacle-10-6-march-2019"></a>

- Added `pinnacle#dump()`.

### 0.3.1 (7 June 2017)<a name="pinnacle-031-7-june-2017" href="#user-content-pinnacle-031-7-june-2017"></a>

- Fix another bug with augmentation of existing highlights.

### 0.3 (6 June 2017)<a name="pinnacle-03-6-june-2017" href="#user-content-pinnacle-03-6-june-2017"></a>

- Added `pinnacle#extract_bg` and `pinnacle#extract_fg`.
- Fixed bug that could cause existing highlights to be incorrectly augmented.

### 0.2 (9 January 2017)<a name="pinnacle-02-9-january-2017" href="#user-content-pinnacle-02-9-january-2017"></a>

- Added `pinnacle#underline`.

### 0.1 (30 March 2016)<a name="pinnacle-01-30-march-2016" href="#user-content-pinnacle-01-30-march-2016"></a>

- Initial release.
