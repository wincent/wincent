> [!WARNING]
> The plugin system is still in its early stages, and most of the plugins below only guarantee compatibility with the latest code of Yazi!
>
> Please make sure that both your Yazi and plugins are on the `HEAD` to ensure proper functionality!

# Plugins

The following plugins can be installed using the [`ya pkg` package manager](https://yazi-rs.github.io/docs/cli#pm) introduced in Yazi v25.5.31.

For specific installation commands and configuration instructions, check the individual `README.md` of each plugin by clicking the link below:

- [smart-enter.yazi](smart-enter.yazi) - `Open` files or `enter` directories all in one key!
- [full-border.yazi](full-border.yazi) - Add a full border to Yazi to make it look fancier.
- [toggle-pane.yazi](toggle-pane.yazi) - Toggle the show, hide, and maximize states for different panes: parent, current, and preview.
- [jump-to-char.yazi](jump-to-char.yazi) - Vim-like `f<char>`, jump to the next file whose name starts with `<char>`.
- [git.yazi](git.yazi) - Show the status of Git file changes as linemode in the file list.
- [mount.yazi](mount.yazi) - A mount manager for Yazi, providing disk mount, unmount, and eject functionality.
- [vcs-files.yazi](vcs-files.yazi) - Show Git file changes in Yazi.
- [piper.yazi](piper.yazi) - Pipe any shell command as a previewer.
- [types.yazi](types.yazi) - Type definitions for Yazi's Lua API, empowering an efficient plugin development experience.
- [zoom.yazi](zoom.yazi) - Zoom in or out of the preview image.
- [smart-filter.yazi](smart-filter.yazi) - Makes filters smarter: continuous filtering, automatically enter unique directory, open file on submitting.
- [chmod.yazi](chmod.yazi) - Execute `chmod` on the selected files to change their mode.
- [mime-ext.yazi](mime-ext.yazi) - A mime-type provider based on a file extension database, replacing the builtin `file(1)` to speed up mime-type retrieval at the expense of accuracy.
- [smart-paste.yazi](smart-paste.yazi) - Paste files into the hovered directory or to the CWD if hovering over a file.
- [diff.yazi](diff.yazi) - Diff the selected file with the hovered file, create a living patch, and copy it to the clipboard.
- [no-status.yazi](no-status.yazi) - Remove the status bar.
- [mactag.yazi](mactag.yazi) - Bring macOS's awesome tagging feature to Yazi! The plugin is only available for macOS just like the name says.
