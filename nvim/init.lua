-- تكبير الشاشة لفوق (زيادة الارتفاع)
vim.keymap.set('n', '<C-k>', ':resize +2<CR>', { silent = true })

-- تصغير الشاشة لتحت (تقليل الارتفاع)
vim.keymap.set('n', '<C-j>', ':resize -2<CR>', { silent = true })

-- تكبير الشاشة بالعرض (ناحية اليمين)
vim.keymap.set('n', '<C-l>', ':vertical resize +2<CR>', { silent = true })

-- تصغير الشاشة بالعرض (ناحية الشمال)
vim.keymap.set('n', '<C-h>', ':vertical resize -2<CR>', { silent = true })
--Set tab width to 2 spaces
--vim.opt.number = true          -- Show absolute line number
vim.opt.relativenumber = true -- Show relative line numbers for fast navigation

-- Force full transparency across all tabs, inactive windows, and bufferlines
local function apply_transparency()
  local highlight_groups = {
    "Normal",
    "NormalNC",                 -- Inactive / non-current windows
    "SignColumn",               -- Line number / Git gutter
    "EndOfBuffer",              -- The ~ lines at the end of a file
    "NormalFloat",              -- Floating windows
    "FloatBorder",              -- Borders on floats
    "BufferLineFill",           -- Empty space in the bufferline bar
    "BufferLineBackground",     -- Inactive tabs in bufferline
    "BufferLineBufferSelected", -- Active tab in bufferline
    "BufferLineBufferVisible",  -- Visible inactive tabs
    "TabLine",
    "TabLineFill",
    "TabLineSel",
  }

  for _, group in ipairs(highlight_groups) do
    vim.cmd(string.format("hi %s guibg=NONE ctermbg=NONE", group))
  end
end

-- Run transparency on Startup, Theme change, AND when switching buffers/tabs
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter", "BufEnter" }, {
  pattern = "*",
  callback = apply_transparency,
})
-- Visuals & UX
vim.opt.signcolumn = "yes" -- Prevents UI jitter when git signs or LSP errors appear
vim.opt.scrolloff = 8      -- Keep 8 lines above/below cursor when scrolling
vim.opt.wrap = false       -- Disable line wrapping

-- Search settings
vim.opt.ignorecase = true -- Case-insensitive search
vim.opt.smartcase = true  -- Case-sensitive if capital letter typed

-- Clipboard & Files
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard
vim.opt.undofile = true           -- Save undo history to disk across sessions
vim.opt.updatetime = 250          -- Faster UI updates (git signs, diagnostics)

vim.opt.tabstop = 2               -- Number of spaces a <Tab> counts for
vim.opt.shiftwidth = 2            -- Size of an indent
vim.opt.softtabstop = 2           -- Number of spaces inserted for a tab
vim.opt.expandtab = true          -- Convert tabs to spaces
vim.o.termguicolors = true        -- Enable true colors
vim.g.term_transparency = 1       -- Some themes support this
vim.o.background = "dark"
-- Set Space as your Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- Bootstrap lazy.nvim automatically
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)



require("lazy").setup("plugins")

-- White transparent visual selection across all themes and GIFs
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  pattern = "*",
  callback = function()
    -- 1. Visual selection highlight
    vim.api.nvim_set_hl(0, "Visual", {
      bg = "#3a3d4a",
      blend = 70,    -- Translucency (0 = fully opaque white, 100 = fully invisible)
      fg = "#3a3d4a" -- Preserves original syntax text colors
    })

    -- 2. (Optional) Soft white tint for currenjk line highlight
    vim.api.nvim_set_hl(0, "CursorLine", {
      bg = "#3a3d4a",
      blend = 90
    })
  end,
})

vim.keymap.set('n', '<C-p>', function()
  require('telescope.builtin').find_files()
end, { desc = 'Find files' })

vim.opt.cmdheight = 0

-- 2. Create an augroup to manage dynamic height transitions
local dynamic_cmdheight = vim.api.nvim_create_augroup("DynamicCmdHeight", { clear = true })

-- Expand command line to height 1 when entering Command mode (:, /, ?)
vim.api.nvim_create_autocmd("CmdlineEnter", {
  group = dynamic_cmdheight,
  callback = function()
    vim.opt.cmdheight = 1
  end,
})

-- Collapse command line back to height 0 when leaving Command mode
vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = dynamic_cmdheight,
  callback = function()
    vim.opt.cmdheight = 0
  end,
})

-- Theme switcher with instant live preview
vim.keymap.set("n", "<leader>th", function()
  require("telescope.builtin").colorscheme({
    enable_preview = true
  })
end, { desc = "Switch Theme (Live Preview)" })

vim.diagnostic.config({
  -- 1. Show the error text inline at the end of the line
  virtual_text = {
    prefix = "x ", -- Symbol shown before the error message
    spacing = 4,
  },
  -- 2. Underline the broken code in red
  underline = true,

  -- 3. Keep signs in the gutter column
  signs = true,

  -- 4. Highlight the line background for errors (Neovim 0.10+)
  linehl = {
    [vim.diagnostic.severity.ERROR] = "ErrorMsg",
  },

  -- 5. Don't yell at you while you're actively typing inside Insert mode
  pdate_in_insert = false,

  severity_sort = true,
})

-- Keymap to hover over an error and open a floating window with full details
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show Line Diagnostics" })
