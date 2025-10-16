-- Add custom highlights for list in `:h tinted-vim`.
local function highlight_groups(patterns)
    local ns = vim.api.nvim_create_namespace('tinted-vim-help')

    local save_cursor = vim.fn.getcurpos()

    for _, pat in pairs(patterns) do
        local start_lnum = vim.fn.search(pat.start, 'c')
        local end_lnum = vim.fn.search(pat.stop)
        if start_lnum == 0 or end_lnum == 0 then
            break
        end

        for lnum = start_lnum, end_lnum do
            local word = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, true)[1]:match(pat.match)
            if vim.fn.hlexists(word) ~= 0 then
                vim.api.nvim_buf_set_extmark(0, ns, lnum - 1, 0, { end_col = #word, hl_group = word })
            end
        end
    end

    vim.fn.setpos('.', save_cursor)
end

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*/tinted-vim.txt",
    callback = function()
        vim.treesitter.start(0, 'vimdoc')
        highlight_groups({
            {
                start = [[INTRODUCTION]],
                stop = '^======',
                match = '^g:(%w+_%w+)'
            },
            { start = [[GUI HIGHLIGHTS]],                 stop = '^======', match = '^(%w+)\t' },
            { start = [[DEFAULT SYNTAX HIGHLIGHTS]],      stop = '^======', match = '^(%w+)\t' },
            { start = [[TREESITTER SYNTAX HIGHLIGHTS]],   stop = '^======', match = '^@[%w%p]+', },
            { start = [[LSP SEMANTIC SYNTAX HIGHLIGHTS]], stop = '^======', match = '^@[%w%p]+' },
            { start = [[LSP HIGHLIGHTS]],                 stop = '^======', match = '^(%w+)' },
            { start = [[DIAGNOSTIC HIGHLIGHTS]],          stop = '^======', match = '^(%w+)' },
        })
    end
})
