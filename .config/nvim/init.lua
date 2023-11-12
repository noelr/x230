local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "stevearc/conform.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          svelte = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          graphql = { "prettier" },
          lua = { "stylua" },
          python = { "isort", "black" },
          elm = { "elmformat" },
        },
        -- format_on_save = {
        --   lsp_fallback = true,
        --   async = false,
        --   timeout_ms = 1000,
        -- },
      })

      vim.keymap.set({ "n", "v" }, "<leader>F", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "Format range or file" })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  { "stevearc/dressing.nvim", event = "VeryLazy" },
  { "j-hui/fidget.nvim", tag = "legacy", config = true },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      { "folke/neodev.nvim", config = true },
      "hrsh7th/cmp-buffer", -- source for text in buffer
      "hrsh7th/cmp-path", -- source for file system paths
      "L3MON4D3/LuaSnip", -- snippet engine
      "saadparwaiz1/cmp_luasnip", -- for autocompletion
      "rafamadriz/friendly-snippets", -- useful snippets
      "onsails/lspkind.nvim", -- vs-code like pictograms
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        experimental = {
          ghost_text = true,
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<c-u>"] = cmp.mapping.scroll_docs(-4),
          ["<c-d>"] = cmp.mapping.scroll_docs(4),
          ["<c-f>"] = cmp.mapping.complete(),
          ["<c-l>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" }, -- text within current buffer
          { name = "path" }, -- file system paths
        },
      })

      vim.keymap.set("i", "<c-l>", "<Plug>luasnip-expand-or-jump", { silent = false })
      vim.keymap.set("i", "<c-k>", function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { silent = false })

      --vim.api.nvim_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
      vim.cmd("inoremap <C-x><C-o> <Cmd>lua require('cmp').complete()<CR>")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    run = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = true }))
    end,
    config = function()
      require("nvim-treesitter.configs").setup({
        modules = {},
        sync_install = false,
        auto_install = false,
        ignore_install = {},

        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = {
          "lua",
          "swift",
          "javascript",
          "typescript",
          "ruby",
          "json",
          "html",
          "css",
          "elm",
          "elixir",
          "vim",
        },
        highlight = { enable = true },
        indent = { enable = true, disable = { "python" } },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<c-n>",
            node_incremental = "<c-n>",
            scope_incremental = "<c-s>",
            node_decremental = "<c-p>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              -- ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
              -- ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
              -- ["h="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
              -- ["l="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
      })
    end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" },
  "tpope/vim-fugitive",
  "navarasu/onedark.nvim",
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>w",
        function()
          require("telescope.builtin").oldfiles()
        end,
        desc = "[ ] Find recently opened files",
      },
      {
        "<leader>b",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "[ ] Find existing buffers",
      },
      {
        "<leader>f",
        function()
          require("telescope.builtin").find_files()
        end,
        { desc = "[S]earch [F]iles" },
      },
      {
        "<leader>sh",
        function()
          require("telescope.builtin").help_tags()
        end,
        { desc = "[S]earch [H]elp" },
      },
      {
        "<leader>sw",
        function()
          require("telescope.builtin").grep_string()
        end,
        { desc = "[S]earch current [W]ord" },
      },
      {
        "<leader>sg",
        function()
          require("telescope.builtin").live_grep()
        end,
        { desc = "[S]earch by [G]rep" },
      },
      {
        "<leader>sd",
        function()
          require("telescope.builtin").diagnostics()
        end,
        { desc = "[S]earch [D]iagnostics" },
      },
    },
    opts = {
      defaults = {
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        mappings = {
          i = {
            ["<C-u>"] = false,
            ["<C-d>"] = false,
          },
        },
      },
    },
    config = true,
  },
  { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
})

-- [[ Setting options ]]
-- See `:help vim.o`

-- tabs: never
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2

-- Set highlight on search
vim.o.hlsearch = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

vim.o.statusline = "%<%f (%{&ft}) %-4(%m%)%=%-19(%3l,%02c%03V%)"

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd([[colorscheme onedark]])

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

vim.opt.scrolloff = 5
vim.opt.winwidth = 105
vim.opt.wrap = false
vim.cmd("set list listchars=tab:»·,trail:·") -- Display extra whitespace. Lua kann » irgendwie nicht

vim.api.nvim_create_autocmd("TermOpen", { command = "setlocal nonumber" })

vim.keymap.set("i", "<c-c>", "<esc>", { silent = true })
vim.keymap.set("n", "<c-c>", "<cmd>:nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "<c-w><space>", "14<c-w>+", { silent = false })
vim.api.nvim_set_keymap(
  "n",
  "<leader><leader>",
  "<cmd>e ~/.config/nvim/init.lua<CR>",
  { noremap = true, silent = true }
)

vim.g.maplocalleader = " "

pcall(require("telescope").load_extension, "fzf")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", "<cmd>Telescope diagnostics<CR>")
vim.keymap.set("n", "§", vim.diagnostic.hide)
vim.keymap.set("n", "±", vim.diagnostic.show)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
  nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  -- nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
  -- nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  -- nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  -- nmap("<leader>wl", function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, "[W]orkspace [L]ist Folders")

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  elixirls = {},
  elmls = {},
  tsserver = {},
  jsonls = {},
  csharp_ls = {},
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
--local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
  function(server_name)
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    })
  end,
})

require("lspconfig").sourcekit.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
require("lspconfig").fsautocomplete.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- nvim-cmp setup

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
