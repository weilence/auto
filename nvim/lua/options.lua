vim.opt.number = true
vim.opt.tabstop = 2 -- number of spaces in tab when editing
vim.opt.shiftwidth = 2 -- number of spaces to use for autoindent
vim.opt.expandtab = true
vim.opt.undofile = true
vim.opt.clipboard:append { 'unnamedplus' }
vim.opt.pumheight = 10
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"
vim.cmd.colorscheme('tokyonight')
vim.cmd [[
  augroup _general_settings
    autocmd!
    autocmd FileType help wincmd L
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR> 
  augroup end
]]
vim.g.copilot_node_command = "~/.nvm/versions/node/v16.15.0/bin/node"
vim.opt.termguicolors = true

