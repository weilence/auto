return function(use)
  -- ui
  use { 'nvim-tree/nvim-tree.lua', requires = { 'nvim-tree/nvim-web-devicons' }, }
  use { 'akinsho/bufferline.nvim', requires = 'nvim-tree/nvim-web-devicons' }
  use 'rcarriga/nvim-notify'
  use "goolord/alpha-nvim" -- welcome page
  use { "akinsho/toggleterm.nvim" }
  use "nvim-lualine/lualine.nvim" -- status line

  use { 'nvim-treesitter/nvim-treesitter', run = ":TSUpdate" }

  -- code completion
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-copilot'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/nvim-cmp'
  use 'github/copilot.vim'

  -- theme
  use 'folke/tokyonight.nvim'
  use { "nvim-lua/plenary.nvim" }
  -- editor
  use "Pocco81/auto-save.nvim"
  use { "Shatur/neovim-session-manager" }
  use "ahmedkhalf/project.nvim"
  use "windwp/nvim-autopairs"
  use "terrortylor/nvim-comment"
  -- lsp
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }
  -- dap
  use 'mfussenegger/nvim-dap'
  use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
  -- telescope
  use { 'nvim-telescope/telescope.nvim' }
  use { 'nvim-telescope/telescope-ui-select.nvim' }
end
