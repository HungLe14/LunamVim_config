-- Personal setting dashboard
require "user.alpha"

-- general
lvim.log.level = "warn"
lvim.format_on_save = true
vim.opt.relativenumber = true
vim.opt.wrap = true
vim.lsp.buf.format({ timeout_ms = 2000 })
vim.o.guifont = "Hack Nerd Font"
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.visual_block_mode['J'] = ":move '>+1<CR>gv-gv"
lvim.keys.visual_block_mode['K'] = ":move '<-2<CR>gv-gv"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<C-q>"] = ":q<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<C-t>"] = ":ToggleTerm<CR>"

-- show diagnostic in a float window in menu <leader>lD
lvim.builtin.which_key.mappings["lD"] = {
  "<cmd>lua vim.diagnostic.open_float()<CR>", "Diagnostic float"
}

lvim.builtin.which_key.mappings["gS"] = { "<cmd>Telescope git_stash<CR>", "Stash List", }

lvim.builtin.which_key.mappings["F"] = { "<cmd>Telescope file_browser<CR>", "Find Folder", }

lvim.builtin.which_key.mappings["W"] = { "<cmd>:lua require('nvim-window').pick()<CR>", "Window", }

lvim.builtin.which_key.mappings["o"] = {
  name = "Others",
  a = { "<cmd>CopyAbsolutePath<CR>", "Copy Absolute Path" }, r = { "<cmd>CopyRelPath<CR>", "Copy Relative Path" },
  n = { "<cmd>NvimTreeRefresh<CR>", "Refresh NvimTree" },
  b = { "<cmd>e<CR>", "Refresh Buffer" },
  p = { "<cmd>:Telescope projects<CR>", "Open Project" }
}

lvim.builtin.which_key.mappings["ge"] = {
  name = "Git Conflict",
  l = { "<cmd>GitConflictListQf<cr>", "List all conflict" },
  c = { "<cmd>GitConflictChooseOurs<CR>", "Select current changes" },
  i = { "<cmd>GitConflictChooseTheirs<CR>", "Select incoming changes" },
  b = { "<cmd>GitConflictChooseBoth<CR>", "Select both changes" },
  n = { "<cmd>GitConflictChooseNone<CR>", "Select none changes" },
  N = { "<cmd>GitConflictNextConflict<CR>", "Move to next conflict" },
  P = { "<cmd>GitConflictPrevConflict<CR>", "Move to previous conflict" },
}

lvim.builtin.which_key.mappings["t"] = {
  name = "Toggle Terminal",
  v = { "<cmd>ToggleTerm direction=vertical<cr>", "Toggle Terminal Vertical" },
  h = { "<cmd>ToggleTerm direction=horizontal<cr>", "Toggle Terminal Horizontal" },
}

-- Function using to copy file path
vim.api.nvim_create_user_command("CopyAbsolutePath", function()
  local path = vim.fn.expand("%:p")
  require("notify")("Copy path:" .. path)
end, {})
vim.api.nvim_create_user_command("CopyRelPath",
  function()

    local path = vim.fn.expand("%")
    require("notify")("Copy path:" .. path)
  end, {})

-- colorscheme
-- lvim.colorscheme = "dracula"
-- lvim.colorscheme = "tokyonight"
-- lvim.colorscheme = "nightfox"
lvim.colorscheme = "catppuccin-macchiato"

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
  "html",
  "ruby",
  "dockerfile",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true
lvim.lsp.installer.setup.automatic_installation = false

-- linter and formatter for ruby
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "solargraph" })
-- require("lspconfig").solargraph.setup({})
-- local null_ls = require("null-ls")
-- local sources = {
--   null_ls.builtins.diagnostics.rubocop,
-- }
-- null_ls.register({ sources = sources })

-- linter and formatter for terraform
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "terraform-ls" })
-- require("lspconfig").terraformls.setup({})

-- require("lspconfig").tsserver.setup({})

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    command = "prettierd",
    ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "css", "scss", "html", "json", "yaml" },
  }
}

-- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  {
    command = "eslint_d",
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
  }
}

-- -- set additional code actions
local code_actions = require "lvim.lsp.null-ls.code_actions"
code_actions.setup {
  {
    command = "eslint_d",
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
  }
}

require 'lspconfig'.jdtls.setup {
  cmd = { 'jdtls' },
  root_dir = function(fname)
    return require 'lspconfig'.util.root_pattern('pom.xml', 'gradle.build', '.git')(fname) or vim.fn.getcwd()
  end
}

-- Additional Plugins
lvim.plugins = {
  { "EdenEast/nightfox.nvim" },
  { "dracula/vim" },
  { "catppuccin/nvim" },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup()
      vim.api.nvim_set_keymap("n", "s", ":HopChar2<cr>", { silent = true })
      vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
    end,
  },
  {
    "p00f/nvim-ts-rainbow",
  }, {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "css", "scss", "html", "javascript", "javascriptreact", "typescript",
        "typescriptreact" }, {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      })
    end,
  },
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require('neoscroll').setup({
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
          '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        hide_cursor = true, -- Hide cursor while scrolling
        stop_eof = true, -- Stop at <EOF> when scrolling downwards
        use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
        respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = nil, -- Default easing function
        pre_hook = nil, -- Function to run before the scrolling animation starts
        post_hook = nil, -- Function to run after the scrolling animation ends
      })
    end
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require "lsp_signature".on_attach() end,
  },
  {
    "sindrets/diffview.nvim",
    event = "BufRead",
  },
  { 'akinsho/git-conflict.nvim', tag = "*", config = function()
    require('git-conflict').setup({
      {
        default_mappings = false, -- disable buffer local mapping created by this plugin
        disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
        highlights = { -- They must have background color, otherwise the default color will be used
          incoming = 'DiffText',
          current = 'DiffAdd',
        }
      }
    })
  end
  },
  {
    "nvim-telescope/telescope-file-browser.nvim"
  },
  {
    "tpope/vim-surround",
    -- make sure to change the value of `timeoutlen` if it's not triggering correctly, see https://github.com/tpope/vim-surround/issues/117
    setup = function()
      vim.o.timeoutlen = 500
    end
  },
  {
    "https://gitlab.com/yorickpeterse/nvim-window.git"
  },
  {
    'rcarriga/nvim-notify'
  }
}

-- config window picker
require('nvim-window').setup({
  normal_hl = 'Normal',
  hint_hl = 'Bold',
  border = 'single'
})

-- override file_browser of telescope project
local file_browser = require('telescope').load_extension('file_browser')
require('telescope.builtin').file_browser = file_browser.file_browser

-- config lualine
local components = require("lvim.core.lualine.components")
lvim.builtin.lualine.options.globalstatus = false
lvim.builtin.lualine.options.theme = "palenight"
lvim.builtin.lualine.options.component_separators = { left = '', right = '' }
lvim.builtin.lualine.options.section_separators = { left = '', right = '' }
lvim.builtin.lualine.sections.lualine_a = { { "mode", padding = 2 } }
lvim.builtin.lualine.sections.lualine_b = { { "branch", 'diff', padding = 2 } }
lvim.builtin.lualine.sections.lualine_c = { { "filename", padding = 2 } }
lvim.builtin.lualine.sections.lualine_x = { 'diagnostics', components.lsp, 'filetype' }
lvim.builtin.lualine.sections.lualine_y = { { "progress", padding = 1 } }
lvim.builtin.lualine.sections.lualine_z = { { "location", padding = 1 } }
