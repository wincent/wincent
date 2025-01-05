; Override unwanted conceal highlighting (default priority: 100) from:
;
;     ~/.config/nvim/pack/bundle/opt/nvim-treesitter/queries/markdown/highlights.scm
;
; with equivalent queries that omit the undesired `(#set! conceal "")`.
;
; See also related fixes for the `markdown_inline` queries.

(fenced_code_block
  (fenced_code_block_delimiter) @markup.raw.block
  (#set! priority 105))

(fenced_code_block
  (info_string
    (language) @label
    (#set! priority 105)))
