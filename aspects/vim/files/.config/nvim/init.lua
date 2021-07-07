if vim.v.progname == 'vi' then
  vim.opt.loadplugins = false
end

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Extension -> filetype mappings.
vim.g.filetype_m = 'objc'
vim.g.filetype_pl = 'prolog'

CorpusDirectories = {
  ['~/Documents/Corpus'] = {
    autocommit = true,
    autoreference = 1,
    autotitle = 1,
    base = './',
    transform = 'local',
  },
  ['~/code/masochist/content/content/wiki'] = {
    autocommit = false,
    autoreference = 1,
    autotitle = 1,
    base = '/wiki/',
    tags = {'wiki'},
    transform = 'web',
  },
}

-- Stark highlighting is enough to see the current match; don't need the
-- centering, which can be annoying.
vim.g.LoupeCenterResults = 0

-- And it turns out that if we're going to turn off the centering, we don't even
-- need the mappings; see: https://github.com/wincent/loupe/pull/15
vim.cmd('nmap <Nop><F1> <Plug>(LoupeN)')
vim.cmd('nmap <Nop><F2> <Plug>(Loupen)')

-- Stop Ferret from binding <Leader>l, which we want to keep for interactions
-- with the language server client (the rare-ish times I want :Lack, I can just
-- type it out).
vim.cmd('map <Nop><F3> <Plug>(FerretLack)')

-- Prevent tcomment from making a zillion mappings (we just want the operator).
vim.g.tcomment_mapleader1 = ''
vim.g.tcomment_mapleader2 = ''
vim.g.tcomment_mapleader_comment_anyway = ''
vim.g.tcomment_textobject_inlinecomment = ''

-- The default (g<) is a bit awkward to type.
vim.g.tcomment_mapleader_uncomment_anyway = 'gu'

-- Turn off most of the features of this plug-in; I really just want the folding.
vim.g.vim_markdown_override_foldtext = 0
vim.g.vim_markdown_no_default_key_mappings = 1
vim.g.vim_markdown_emphasis_multiline = 0
vim.g.vim_markdown_conceal = 0
vim.g.vim_markdown_conceal_code_blocks  =  0
vim.g.vim_markdown_frontmatter = 1
vim.g.vim_markdown_new_list_item_indent = 0

if vim.fn.filereadable('/usr/local/bin/python3') == 1 then
  -- Avoid search, speeding up start-up.
  vim.g.python3_host_prog = '/usr/local/bin/python3'
end

-- Normally <leader>s (mnemonic: "[s]earch");
-- use <leader>f instead (mnemonic: "[f]ind")
vim.cmd('nmap <leader>f <Plug>(FerretAckWord)')

-- Normally <leader>r (mnemonic: "[r]eplace");
-- use <leader>s (mnemonic: "[s]ubstitute") instead.
vim.cmd('nmap <leader>s <Plug>(FerretAcks)')

-- Allow for per-machine overrides in ~/.config/nvim/host/$HOSTNAME.vim.
local hostfile =
      os.getenv("HOME") ..
      '/.config/nvim/host/' ..
      vim.fn.substitute(vim.fn.hostname(), '\\..*', '', '') ..
      '.vim'
if vim.fn.filereadable(hostfile) then
  vim.cmd('source ' .. hostfile)
end

local nvim_config_local = os.getenv('HOME') .. '/.config/nvim/init-local.vim'
if vim.fn.filereadable(nvim_config_local) == 1 then
  vim.cmd('source ' .. nvim_config_local)
end

if vim.opt.loadplugins:get() then
  vim.cmd('packadd! applescript.vim')
  vim.cmd('packadd! base16-vim')
  vim.cmd('packadd! command-t')
  vim.cmd('packadd! corpus')
  --vim.cmd('packadd! fern.vim')
  vim.cmd('packadd! ferret')
  vim.cmd('packadd! loupe')
  vim.cmd('packadd! lspsaga.nvim')
  vim.cmd('packadd! neco-ghc')
  vim.cmd('packadd! nvim-compe')
  vim.cmd('packadd! nvim-lspconfig')
  vim.cmd('packadd! pinnacle')
  vim.cmd('packadd! replay')
  vim.cmd('packadd! scalpel')
  vim.cmd('packadd! tcomment_vim')
  vim.cmd('packadd! terminus')
  vim.cmd('packadd! typescript-vim')
  vim.cmd('packadd! ultisnips')
  vim.cmd('packadd! vcs-jump')
  vim.cmd('packadd! vim-ansible-yaml')
  vim.cmd('packadd! vim-clipper')
  vim.cmd('packadd! vim-dirvish')
  vim.cmd('packadd! vim-dispatch')
  vim.cmd('packadd! vim-docvim')
  vim.cmd('packadd! vim-easydir')
  vim.cmd('packadd! vim-eunuch')
  vim.cmd('packadd! vim-fugitive')
  vim.cmd('packadd! vim-git')
  vim.cmd('packadd! vim-javascript')
  vim.cmd('packadd! vim-json')
  vim.cmd('packadd! vim-jsx')
  vim.cmd('packadd! vim-ledger')
  vim.cmd('packadd! vim-lion')
  vim.cmd('packadd! vim-markdown')
  vim.cmd('packadd! vim-operator-user')
  vim.cmd('packadd! vim-projectionist')
  vim.cmd('packadd! vim-reason-plus')
  vim.cmd('packadd! vim-repeat')
  vim.cmd('packadd! vim-signature')
  vim.cmd('packadd! vim-slime')
  vim.cmd('packadd! vim-soy')
  vim.cmd('packadd! vim-speeddating')
  vim.cmd('packadd! vim-surround')
  vim.cmd('packadd! vim-textobj-comment')
  vim.cmd('packadd! vim-textobj-rubyblock')
  vim.cmd('packadd! vim-textobj-user')
  vim.cmd('packadd! vim-zsh')
end

-- Automatic, language-dependent indentation, syntax coloring and other
-- functionality.
--
-- Must come *after* the `:packadd!` calls above otherwise the contents of
-- package "ftdetect" directories won't be evaluated.
vim.cmd('filetype indent plugin on')
vim.cmd('syntax on')

-- nvim-compe.
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = 'single', -- see `:h nvim_open_win`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    buffer = true;
    calc = true;
    emoji = true;
    nvim_lsp = true;
    nvim_lua = true;
    path = true;
    ultisnips = true;
    vsnip = true;
  };
}

-- After this file is sourced, plugin code will be evaluated.
-- See ~/.config/nvim/after for files evaluated after that.
-- See `:scriptnames` for a list of all scripts, in evaluation order.
-- Launch Vim with `vim --startuptime vim.log` for profiling info.
--
-- To see all leader mappings, including those from plugins:
--
--   vim -c 'set t_te=' -c 'set t_ti=' -c 'map <space>' -c q | sort
