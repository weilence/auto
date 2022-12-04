local config_dir = vim.fn.stdpath('config') .. '/lua/conf'

local ends_with = require("utils").ends_with

for _, fname in pairs(vim.fn.readdir(config_dir)) do
  if fname ~= "init.lua" then
    if ends_with(fname, ".lua") then
      local cut_suffix_fname = fname:sub(1, #fname - #'.lua')
      local file = "conf." .. cut_suffix_fname
      local status_ok, _ = pcall(require, file)
      if not status_ok then
        vim.notify('Failed loading ' .. fname, vim.log.levels.ERROR)
      end
    end
  end
end
