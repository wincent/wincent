# Contributing

## Update procedure

In order to always be testing the latest and greatest version of these color schemes, I add this repo as a submodule to [my dotfiles repository](https://github.com/wincent/wincent), and work out of there. [The script for actually rebuilding schemes](https://github.com/wincent/wincent/blob/main/bin/update-themes) is stored in the superproject.

### Tracking upstream template updates

Examples of "backports" of changes made in [base16-vim](https://github.com/chriskempson/base16-vim):

- [d2b7bbadebf666c2](https://github.com/wincent/base16-nvim/commit/d2b7bbadebf666c2a2e9e9410c009774554f5249).
- [e17c89c913d5ef91](https://github.com/wincent/base16-nvim/commit/e17c89c913d5ef9177452636e0b81311a8481a99).
- [3e732be2af2b6282](https://github.com/wincent/base16-nvim/commit/3e732be2af2b62822826aa95a9e2d77a735356be).

The basic pattern is:

1.  Make the changes to [the `templates/default.mustache` template](templates/default.mustache) in this repo (ie. in the submodule). This requires a decision for how to port the Vimscript of each upstream change into Lua.

2.  Run `bin/update-themes` in the superproject.

3.  Commit the changes in the base16-nvim submodule:

    ```
    cd aspects/nvim/files/.config/nvim/pack/bundle/opt/base16-nvim
    git commit -p
    git push
    cd -
    ```

4.  Produce a dotfiles commit (example: [d0da206692f96e19](https://github.com/wincent/wincent/commit/d0da206692f96e19552343a938f1686b37b1f36d)):

    ```
    git add aspects/nvim/files/.config/nvim/pack/bundle/opt/base16-nvim
    git commit
    ```
