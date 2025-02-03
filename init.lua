vim.g.coq_settings = {

  auto_start = true,
}

vim.wo.number = true
vim.wo.relativenumber = true

require "config.lazy"

local lsp = require "lspconfig"
local coq = require "coq" -- add this

require("autoclose").setup()

vim.keymap.set("i", "<C-Tab>", 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
})
vim.g.copilot_no_tab_map = true

require("mason").setup()
require("lazy").setup {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require "nvim-treesitter.configs"

      configs.setup {
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
  },
}
local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts "Up")
  vim.keymap.set("n", "?", api.tree.toggle_help, opts "Help")
  --- i want control n to toggle nvim tree
end

vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- themery
-- Minimal config
require("themery").setup {
  themes = {
    "NeoSolarized",
    "catppuccin",
    "catppuccin-frappe",
    "catppuccin-mocha",
    "tokyonight",
    "tokyonight-storm",
    "tokyonight-night",
    "tokyonight-moon",
    "elford",
    "habamax",
    "solarized",
    "retrobox",
  }, -- Your list of installed colorschemes.
  livePreview = true, -- Apply theme while picking. Default to true.
}

-- pass to setup along with your other options
require("nvim-tree").setup {
  ---
  on_attach = my_on_attach,
  ---
}
require("nvim-tree").setup {
  view = {
    side = "right",
    width = 40,
  },
  on_attach = my_on_attach,
}

--- Language servers

require("lspconfig").lua_ls.setup {}
require("lspconfig").svelte.setup {}
require("lspconfig").clangd.setup {}
require("lspconfig").tailwindcss.setup {}
require("lspconfig").cssls.setup {}
require("lspconfig").jedi_language_server.setup {}
require("lspconfig").emmet_language_server.setup {}
require("lspconfig").vtsls.setup {}
-- require'lspconfig'.tailwindcss_language_server.setup{}

lsp.lua_ls.setup(coq.lsp_ensure_capabilities())
lsp.vtsls.setup(coq.lsp_ensure_capabilities())
require("mason-lspconfig").setup {
  ensure_installed = { "lua_ls", "rust_analyzer" },
}
require("telescope").setup {
  defaults = {},
}

local builtin = require "telescope.builtin"
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

--Telescope buffer drop
-- require("telescope").setup {
--   pickers = {
--     buffers = {
--       mappings = {
--         i = { ["<CR>"] = actions.select_tab_drop },
--       },
--       find_files = {
--         mappings = {
--           i = { ["<CR>"] = actions.select_tab_drop },
--         },
--       },
--       git_files = {
--         mappings = {
--           i = { ["<CR>"] = actions.select_tab_drop },
--         },
--       },
--       old_files = {
--         mappings = {
--           i = { ["<CR>"] = actions.select_tab_drop },
--         },
--       },
--     },
--   },
-- }

local harpoon = require "harpoon"

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>a", function()
  harpoon:list():add()
end)
vim.keymap.set("n", "<A-e>", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<A-1>", function()
  harpoon:list():select(1)
end)
vim.keymap.set("n", "<A-2>", function()
  harpoon:list():select(2)
end)
vim.keymap.set("n", "<A-3>", function()
  harpoon:list():select(3)
end)
vim.keymap.set("n", "<A-4>", function()
  harpoon:list():select(4)
end)
vim.keymap.set("n", "<A-5>", function()
  harpoon:list():select(5)
end)
vim.keymap.set("n", "<A-6>", function()
  harpoon:list():select(6)
end)
vim.keymap.set("n", "<A-7>", function()
  harpoon:list():select(7)
end)
vim.keymap.set("n", "<A-8>", function()
  harpoon:list():select(8)
end)
-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function()
  harpoon:list():prev()
end)
vim.keymap.set("n", "<C-S-N>", function()
  harpoon:list():next()
end)

require("nvim-surround").setup()

-- Colorscheme
-- vim.cmd [[colorscheme tokyonight]]

-- Clipboard
vim.api.nvim_set_option("clipboard", "unnamedplus")

-- NeoSolarized
local ok_status, NeoSolarized = pcall(require, "NeoSolarized")

if not ok_status then
  return
end

-- Default Setting for NeoSolarized

NeoSolarized.setup {
  style = "dark", -- "dark" or "light"
  transparent = false, -- true/false; Enable this to disable setting the background color
  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
  enable_italics = true, -- Italics for different hightlight groups (eg. Statement, Condition, Comment, Include, etc.)
  styles = {
    -- Style to be applied to different syntax groups
    comments = { italic = true },
    keywords = { italic = true },
    functions = { bold = true },
    variables = {},
    string = { italic = true },
    underline = true, -- true/false; for global underline
    undercurl = true, -- true/false; for global undercurl
  },
  -- Add specific hightlight groups
  on_highlights = function(highlights, colors)
    -- highlights.Include.fg = colors.red -- Using `red` foreground for Includes
  end,
}
-- Set colorscheme to NeoSolarized
vim.cmd [[
   try
	colorscheme tokyonight 
	set background=dark
    endtry
]]

-- Lualine
--
require("lualine").setup {
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename" },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  extensions = {},
  inactive_winbar = {},
}

-- Spaces
vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

-- neckpain
--
