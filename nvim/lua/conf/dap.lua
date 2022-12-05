require("dapui").setup()
require("dap-go").setup()
require('dap.ext.vscode').load_launchjs()

local dap_breakpoint = {
  error = {
    text = "🛑",
    texthl = "LspDiagnosticsSignError",
    linehl = "",
    numhl = "",
  },
  rejected = {
    text = "",
    texthl = "LspDiagnosticsSignHint",
    linehl = "",
    numhl = "",
  },
  stopped = {
    text = "⭐️",
    texthl = "LspDiagnosticsSignInformation",
    linehl = "DiagnosticUnderlineInfo",
    numhl = "LspDiagnosticsSignInformation",
  },
}

vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)

local dap, dapui = require "dap", require "dapui"
dap.defaults.fallback.terminal_win_cmd = '30vsplit new' -- this will be overrided by dapui
dap.set_log_level("DEBUG")

local debug_open = function()
  dapui.open({})
  -- vim.api.nvim_command("DapVirtualTextEnable")
end
local debug_close = function()
  dap.repl.close()
  dapui.close({})
  -- vim.api.nvim_command("DapVirtualTextDisable")
  -- vim.api.nvim_command("bdelete! term:")   -- close debug temrinal
end

dap.listeners.after.event_initialized["dapui_config"] = function()
  debug_open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  debug_close()
end
dap.listeners.before.event_exited["dapui_config"]     = function()
  debug_close()
end
dap.listeners.before.disconnect["dapui_config"]       = function()
  debug_close()
end
