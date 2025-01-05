; Override unwanted conceal highlighting (default priority: 100) from:
;
;     ~/.config/nvim/pack/bundle/opt/nvim-treesitter/queries/markdown_inline/highlights.scm
;
; with equivalent queries that omit the undesired `(#set! conceal "")`.
;
; See also related fixes for the `markdown` queries.

((code_span_delimiter) @markup.raw (#set! priority 105))
((emphasis_delimiter) @markup.italic (#set! priority 105))

(inline_link
  [
    "["
    "]"
    "("
    (link_destination)
    ")"
  ] @markup.link
  (#set! priority 105))

(image
  [
    "!"
    "["
    "]"
    "("
    (link_destination)
    ")"
  ] @markup.link
  (#set! priority 105))

(full_reference_link
  [
    "["
    "]"
    (link_label)
  ] @markup.link
  (#set! priority 105))

(collapsed_reference_link
  [
    "["
    "]"
  ] @markup.link
  (#set! priority 105))

(shortcut_link
  [
    "["
    "]"
  ] @markup.link
  (#set! priority 105))

((entity_reference) @character.special
  (#eq? @character.special "&nbsp;")
  (#set! priority 105))

((entity_reference) @character.special
  (#eq? @character.special "&lt;")
  (#set! priority 105))

((entity_reference) @character.special
  (#eq? @character.special "&gt;")
  (#set! priority 105))

((entity_reference) @character.special
  (#eq? @character.special "&amp;")
  (#set! priority 105))

((entity_reference) @character.special
  (#eq? @character.special "&quot;")
  (#set! priority 105))

((entity_reference) @character.special
  (#any-of? @character.special "&ensp;" "&emsp;")
  (#set! priority 105))
