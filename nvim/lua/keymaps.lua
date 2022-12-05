local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

local keymap = vim.api.nvim_set_keymap

keymap("", ";", "<Nop>", opts)
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "ZZ", ":wqa<CR>", opts)
keymap("n", "<C-e>", ":NvimTreeToggle<CR>", opts)

keymap('i', "<C-h>", "<C-w>", opts)
keymap('i', "jk", "<Esc>", opts)

keymap('n', '<leader>ff', ":Telescope find_files<CR>", opts)
keymap('n', '<leader>fg', ":Telescope live_grep<CR>", opts)
keymap('n', '<leader>fb', ":Telescope buffers<CR>", opts)
keymap('n', '<leader>fh', ":Telescope help_tags<CR>", opts)
keymap('n', '<leader>fr', ":Telescope oldfiles<CR>", opts)
keymap("n", "<leader>fs", ":SessionManager load_session<CR>", opts)
keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)

keymap("n", "E", ":BufferLineCycleNext<CR>", opts)
keymap("n", "W", ":BufferLineCyclePrev<CR>", opts)

keymap("n", "<F4>", "<cmd>lua require'dap'.terminate()<cr>", opts)
keymap("n", "<F5>", "<cmd>lua require'dap'.continue()<cr>", opts)
keymap("n", "<F6>", "<cmd>lua require'dap'.step_over()<cr>", opts)
keymap("n", "<F7>", "<cmd>lua require'dap'.step_into()<cr>", opts)
keymap("n", "<F8>", "<cmd>lua require'dap'.step_out()<cr>", opts)
keymap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
