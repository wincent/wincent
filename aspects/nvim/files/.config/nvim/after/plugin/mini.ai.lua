local has_mini, mini = pcall(require, 'mini.ai')
if has_mini then
  local has_extra, extra = pcall(require, 'mini.extra')
  if has_extra then
    mini.setup({
      custom_textobjects = {
        i = extra.gen_ai_spec.indent(),
      },
    })
  else
    mini.setup()
  end
end
