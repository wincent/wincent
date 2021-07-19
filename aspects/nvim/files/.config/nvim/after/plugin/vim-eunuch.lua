-- vim-eunuch defines a ":W" command that I consider a little dangerous
-- (too easy to type, with possibly wide-reaching side-effects); overwrite
-- it with something useful (ie. for writing files with root privileges).
--
--    :W        writes the current file with root privileges, prompting for a
--              password if one isn't already cached; passwords are cached for
--              5 minutes
--
--    :W!       as above, but always prompts for a password
--
-- Note that we can't do the naive thing that worked in Vim:
--
--     vim.cmd('command! W w !sudo tee % > /dev/null')
--
-- Due to: https://github.com/neovim/neovim/issues/1716

wincent.vim.command('W', 'call v:lua.wincent.sudo.write("<bang>")', {bang = true})
