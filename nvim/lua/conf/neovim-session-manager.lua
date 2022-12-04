require('session_manager').setup({})

vim.cmd([[
  augroup _open_nvim_tree
    autocmd! * <buffer>
    autocmd SessionLoadPost * silent! lua require("nvim-tree").toggle(false, true)
  augroup end
]])
