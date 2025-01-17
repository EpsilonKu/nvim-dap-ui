local async = require("dapui.async")
local dap = require("dap")

return function()
  local dapui = { elements = {} }

  ---@class dapui.elements.repl
  ---@toc_entry REPL
  ---@text
  --- The REPL provided by nvim-dap.
  dapui.elements.repl = {}

  -- TODO: All of this is a hack because of an error with indentline when buffer
  -- is opened in a window so have to manually find the window that was opened.
  local all_wins = async.api.nvim_list_wins()
  local open_wins = {}
  for _, win in pairs(all_wins) do
    open_wins[win] = true
  end

  pcall(dap.repl.open, {})

  local buf = async.fn.bufnr("dap-repl")

  for _, win in ipairs(async.api.nvim_list_wins()) do
    if not open_wins[win] then
      pcall(async.api.nvim_win_close, win, true)
      break
    end
  end

  ---@nodoc
  function dapui.elements.repl.render() end

  ---@nodoc
  function dapui.elements.repl.buffer()
    return buf
  end

  ---@nodoc
  function dapui.elements.repl.float_defaults()
    return { width = 80, height = 20, enter = true }
  end

  return dapui.elements.repl
end
