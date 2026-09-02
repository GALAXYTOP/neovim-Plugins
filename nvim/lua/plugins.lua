return {
  -- 1. TERMINAL
  {
    "akinsho/toggleterm.nvim",

    config = function()
      require("toggleterm").setup({
        size = 15,
        open_mapping = [[<C-t>]],
        direction = "horizontal",
        shell = "powershell.exe",
      })
    end,
  },
  {
    "eandrju/cellular-automaton.nvim",
    keys = {
      { "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>", desc = "Make it Rain Animation" },
    },
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- Loads right before reading a buffer
    opts = {
      -- Minimum number of buffers that must be open to save a session
      need = 1,
      -- Session options to save
      options = { "buffers", "curdir", "folds", "tabpages", "winsize", "skiprtp", "help" },
    },
    keys = {
      -- 1. Restore the saved session for the current directory
      {
        "<leader>qs",
        function() require("persistence").load() end,
        desc = "Restore Session for Current Dir",
      },
      -- 2. Restore the last session (even if you're in a different folder)
      {
        "<leader>ql",
        function() require("persistence").load({ last = true }) end,
        desc = "Restore Last Session",
      },
      -- 3. Stop session saving on exit for this session
      {
        "<leader>qd",
        function() require("persistence").stop() end,
        desc = "Don't Save Current Session",
      },
    },
  },
  -- {
  --   "folke/noice.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     cmdline = {
  --       enabled = true,
  --       view = "cmdline_popup", -- Set to "cmdline" if you prefer it floating at the bottom instead of center
  --     },
  --     messages = {
  --       enabled = true, -- Handles messages like "file written" silently via notifications
  --     },
  --     popupmenu = {
  --       enabled = true, -- Auto-complete suggestions for commands inside the popup
  --     },
  --     presets = {
  --       bottom_search = true,       -- Classic bottom line for search (/ and ?)
  --       command_palette = true,     -- Floating command palette in the center
  --       long_message_to_split = true, -- Sends long error/lsp messages to a split window
  --     },
  --   },
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "rcarriga/nvim-notify",
  --   },
  -- },
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle",                         -- Toggle auto-save with :ASToggle
    event = { "InsertLeave", "TextChanged" }, -- Save on leaving insert mode or changing text
    opts = {
      enabled = true,
      execution_message = {
        enabled = true,
        message = function()
          return "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S")
        end,
        dim = 0.18,
        cleaning_interval = 1250,
      },
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost" },  -- Save when switching buffers or windows
        defer_save = { "InsertLeave", "TextChanged" }, -- Save after typing stops
      },
      condition = function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")

        -- Don't auto-save special buffers (like Neo-tree or Toggleterm)
        if fn.getbufvar(buf, "&modifiable") == 1 and
            utils.not_in(fn.getbufvar(buf, "&filetype"), { "neo-tree", "toggleterm" }) then
          return true
        end
        return false
      end,
    },
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        cpp = { "clang-format" },
        c = { "clang-format" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    keys = {
      -- 1. Fast Cycling using Tab and Shift-Tab
      { "<Tab>",      "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "<S-Tab>",    "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },

      -- Alternative: Fast cycling with Shift+H and Shift+L
      { "H",          "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "L",          "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },

      -- 2. Pick Mode (Magic jump to any open tab instantly)
      { "<leader>bp", "<cmd>BufferLinePick<cr>",      desc = "Pick Buffer" },

      -- 3. Close current buffer
      { "<leader>bd", "<cmd>bdelete!<cr>",            desc = "Close Buffer" },
      { "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "Pick Buffer to Close" },

      -- 4. Move buffer order left or right
      { "<leader>bl", "<cmd>BufferLineMoveNext<cr>",  desc = "Move Tab Right" },
      { "<leader>bh", "<cmd>BufferLineMovePrev<cr>",  desc = "Move Tab Left" },
    },
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,

        -- Prevents tabs from rendering on top of Neo-tree
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    },
  }, {
  "folke/trouble.nvim",
  opts = {},
  cmd = "Trouble",
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
  },
},
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      vim.cmd("colorscheme tokyonight-storm")
      vim.o.termguicolors = true
      vim.o.background = "dark"
      vim.cmd("hi Normal cterm=none ctermfg=NONE ctermbg=NONE")
    end,
  },

  -- 4. TELESCOPE & EXTENSIONS
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
  },

  -- 5. FILE EXPLORER
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", { silent = true })
    end,
  },

  -- 6. DASHBOARD
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        [[                                     ]],
        [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗]],
        [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║]],
        [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║]],
        [[ ██║╚██╗██║██╔══╝  ██║   ██║██║   ██║]],
        [[ ██║ ╚████║███████╗╚██████╔╝╚██████╔╝]],
        [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝  ╚═════╝ ]],
        [[                                     ]],
      }
      dashboard.section.header.opts.hl = "DashboardHeader"

      dashboard.section.buttons.val = {
        dashboard.button("e", "  New file", ":enew<CR>"),
        dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("g", "  Live grep", ":Telescope live_grep<CR>"),
        dashboard.button("l", "  Lazy", ":Lazy<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }

      alpha.setup(dashboard.opts)
    end,
  },

  -- 7. UI DECORATIONS (Modes & Statusline)
  {
    "mvllow/modes.nvim",
    event = "VeryLazy",
    config = function()
      require("modes").setup({
        colors = {
          copy = "#e0af68",
          delete = "#f7768e",
          insert = "#9ece6a",
          visual = "#bb9af7",
        },
        line_opacity = 0.15,
        set_cursor = true,
        focus_only = false,
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.cursorline = true
      vim.opt.signcolumn = "yes"
      vim.opt.showmode = false
      vim.opt.cmdheight = 1
      vim.opt.laststatus = 3

      require("lualine").setup({
        options = {
          theme = "tokyonight",
          globalstatus = true,
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
      })

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "CmdLine", { bg = "NONE" })
        end,
      })
    end,
  },

  -- 8. MASON & LSP (Fixed Handler setup & capabilities)
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("mason").setup()

      -- Connect LSP capabilities to nvim-cmp autocompletion
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "clangd", "ts_ls" },
        handlers = {
          -- المعالج الافتراضي لجميع السيرفرات
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
            })
          end,

          -- تخصيص clangd لإيجاد g++ تلقائياً
          ["clangd"] = function()
            require("lspconfig").clangd.setup({
              capabilities = capabilities,
              cmd = {
                "clangd",
                "--background-index",
                "--query-driver=C:/msys64/ucrt64/bin/g++.exe",
              },
            })
          end,
        },
      }) -- Keymaps on LSP attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local opts = { buffer = args.buf }
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        end,
      })
    end,
  },

  -- 9. AUTOCOMPLETION & SNIPPETS
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

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
          { name = "path" },
        }),
      })
    end,
  },

  -- 10. QUALITY-OF-LIFE ADDITIONS (Which-Key, GitSigns, AutoPairs, Comments)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      npairs.setup({})

      -- Remove quote rules so you type ", ', and ` manually
      npairs.remove_rule('"')
      npairs.remove_rule("'")
      npairs.remove_rule("`")
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
