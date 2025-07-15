return {
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>pf", function() require("telescope.builtin").find_files() end, desc = "Find Files" },
      { "<C-p>", function() require("telescope.builtin").git_files() end, desc = "Git Files" },
      {
        "<leader>ps",
        function()
          require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
        end,
        desc = "Grep Input"
      },
    },
  },

  -- Color scheme
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      vim.cmd("colorscheme rose-pine")
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "c", "lua", "vim", "vimdoc", "query",
          "markdown", "markdown_inline", "javascript", "rust"
        },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true, additional_vim_regex_highlighting = false },
      }
    end,
  },
  { "nvim-treesitter/playground" },

  -- Harpoon
  {
    "theprimeagen/harpoon",
    keys = {
      { "<leader>a", function() require("harpoon.mark").add_file() end, desc = "Harpoon Add File" },
      { "<C-e>", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon Menu" },
      { "<C-h>", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon File 1" },
      { "<C-t>", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon File 2" },
      { "<C-n>", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon File 3" },
      { "<C-s>", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon File 4" },
    },
  },

  -- Undotree
  {
	  "jiaoshijie/undotree",
	  dependencies = "nvim-lua/plenary.nvim",
	  config = true,
	  keys = { -- load the plugin only when using it's keybinding:
		  { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
	  },
  },
  -- Fugitive
  {
	  "tpope/vim-fugitive",
	  keys = {
		  { "<leader>gs", function() vim.cmd.Git() end, desc = "Git Status" },
	  },
  },

  -- Lazy itself (optional to list)
  { "folke/lazy.nvim" },
}

