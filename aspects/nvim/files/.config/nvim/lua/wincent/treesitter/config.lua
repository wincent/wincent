local config = {
  parsers = {},
}

return {
  get = function()
    return config
  end,

  set = function(new_config)
    config = vim.tbl_deep_extend('force', {}, config, new_config)
  end,
}
