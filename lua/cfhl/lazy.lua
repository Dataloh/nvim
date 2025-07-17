return {
  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",           -- Completion plugin
      "hrsh7th/cmp-nvim-lsp",       -- LSP source for nvim-cmp
      "hrsh7th/cmp-buffer",         -- Buffer completions
      "hrsh7th/cmp-path",           -- Path completions
      "hrsh7th/cmp-cmdline",        -- Cmdline completions
      "L3MON4D3/LuaSnip",           -- Snippet engine
      "saadparwaiz1/cmp_luasnip",   -- Snippet completions
    },
    config = function()
      -- Setup mason
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "gopls",
          "jdtls",
          "ansiblels",
          "ts_ls",    -- JavaScript/TypeScript
          "pyright",  -- Python
        },
        automatic_installation = true,
      })

      local lspconfig = require("lspconfig")

      -- Setup nvim-cmp.
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
      })

      -- Setup LSP servers
      -- Lua
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
              path = vim.split(package.path, ";"),
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- Go
      lspconfig.gopls.setup({
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- Java / Gradle
      lspconfig.jdtls.setup({
        cmd = { "jdtls" },
        root_dir = lspconfig.util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle"),
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- Ansible
      lspconfig.ansiblels.setup({
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- JavaScript / TypeScript
      lspconfig.ts_ls.setup({
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- Python
      lspconfig.pyright.setup({
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })
    end,
  },

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
    },
  },

  -- Undotree
  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    keys = {
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

