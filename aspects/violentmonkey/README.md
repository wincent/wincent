# Violentmonkey

Provides a mechanism for managing Violentmonkey "userscripts" on macOS that is:

- Versioned (ie. in this Git repo); and:
- Isolated from the broader network (ie. instead of auto-updating userscripts downloaded from the internet, or trusting the extension with access to the local filesystem, scripts are served over the built-in Apache webserver).

For a discussion of the trade-offs, see these related commit messages:

- [e8f40653a05451ce5161eba0650725fc3dd58e18](https://github.com/wincent/wincent/commit/e8f40653a05451ce5161eba0650725fc3dd58e18)
- [90f6b05a1b9c677c012c0105a6feb3eaf39fe80b](https://github.com/wincent/wincent/commit/90f6b05a1b9c677c012c0105a6feb3eaf39fe80b)
- [e60b521123f141c97e1da63a1e3cc7c8ffb0aefb](https://github.com/wincent/wincent/commit/e60b521123f141c97e1da63a1e3cc7c8ffb0aefb)

Once the Violentmonkey extension is installed, installing the scripts is a matter of visiting the corresponding URLs and clicking the "Install" button.

**NOTE:** For these URLs to work the `USERNAME` string should be substituted with your macOS account's username:

## Fastmail

| Script                                                                                                                                           | Description                                          |
| ------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------- |
| [http://localhost/~USERNAME/UserScripts/fastmail/suppressEscape.user.js](http://localhost/~USERNAME/UserScripts/fastmail/suppressEscape.user.js) | Stop the Escape key from discarding changes in notes |

## Github

| Script                                                                                                                                                     | Description                                  |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------- |
| [http://localhost/~USERNAME/UserScripts/github/makeTextAreasBigger.user.js](http://localhost/~USERNAME/UserScripts/github/makeTextAreasBigger.user.js)     | Make GitHub PR textareas bigger              |
| [http://localhost/~USERNAME/UserScripts/github/enhanceReviewComments.user.js](http://localhost/~USERNAME/UserScripts/github/enhanceReviewComments.user.js) | Turns comment inputs into just saying inputs |

## Gmail

| Script                                                                                                                                             | Description                                         |
| -------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------- |
| [http://localhost/~USERNAME/UserScripts/gmail/removeHighlighting.user.js](http://localhost/~USERNAME/UserScripts/gmail/removeHighlighting.user.js) | Remove annoying purple color added to text by Gmail |

## Twitter/X

| Script                                                                                                                                                   | Description                   |
| -------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------- |
| [http://localhost/~USERNAME/UserScripts/twitter/bypassClickTracking.user.js](http://localhost/~USERNAME/UserScripts/twitter/bypassClickTracking.user.js) | Bypass Twitter click tracking |
| [http://localhost/~USERNAME/UserScripts/twitter/hideLikeButtons.user.js](http://localhost/~USERNAME/UserScripts/twitter/hideLikeButtons.user.js)         | Hide Twitter Like buttons     |

## YouTube

| Script                                                                                                                                               | Description                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| [http://localhost/~USERNAME/UserScripts/youtube/unhideYouTubeInfo.user.js](http://localhost/~USERNAME/UserScripts/youtube/unhideYouTubeInfo.user.js) | Unhide view count and date |
