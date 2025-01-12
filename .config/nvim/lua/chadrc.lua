---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "monekai",

  hl_override = {
    DiffAdd = {
      bg = { "black", "blue", 10 },
    },
    DiffDelete = {
      bg = { "black", "red" , 10 },
    },
    DiffChange = {
      bg = "grey",
    },
    DiffText = {
      bg = "grey",
      bold = true,
      italic = true,
    },
  }
}

return M
