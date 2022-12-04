require("nvim-tree").setup({
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true
  },
  view = {
    mappings = {
      list = {
        { key = "<C-e>", action = "close" },
        { key = { "l", "<CR>", "o" }, action = "edit" },
        { key = "h", action = "close_node" },
        { key = "v", action = "vsplit" },
        { key = "O", action = "cd" },
        { key = "H", action = "toggle_git_ignored" },
        { key = "D", action = "toggle_dotfiles" },
      },
    }
  }
})
