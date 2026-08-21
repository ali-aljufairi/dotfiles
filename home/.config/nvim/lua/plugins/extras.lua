-- Extra editor features (added 2026-08-21): file tree, LazyGit, sessions,
-- multi-file search/replace, buffer tabs, flash jumping, formatting, linting.
return {
  -- File tree (LazyVim-style <leader>e toggle)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", function() require("nvim-tree.api").tree.toggle({ focus = true }) end, desc = "File [E]xplorer" },
      { "<leader>E", function() require("nvim-tree.api").tree.toggle({ focus = false }) end, desc = "Explorer (no focus)" },
    },
    opts = {
      view = { width = 32 },
      filters = { dotfiles = false },
      renderer = { group_empty = true },
      actions = { open_file = { resize_window = true } },
    },
  },

  -- Floating LazyGit (<leader>gg), like Omarchy/LazyVim
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitConfig" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Lazy[G]it (floating)" },
      { "<leader>gf", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit current file" },
    },
    config = function()
      vim.g.lazygit_floating_window_winblend = 0
      vim.g.lazygit_floating_window_scaling_factor = 0.9
      vim.g.lazygit_use_neovim_in_terminals = true
    end,
  },

  -- Session restore: reopen where you left off
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "[S]ession restore" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore [L]ast session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "[D]on't save session" },
    },
  },

  -- Buffer tabs in the tabline (Shift+H / Shift+L to cycle)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    keys = {
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<leader>bd", "<cmd>bdelete<cr>", desc = "[B]uffer [D]elete" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Delete [O]ther buffers" },
    },
    opts = {
      options = {
        mode = "buffers",
        always_show_bufferline = false,
        separator_style = "thin",
      },
    },
  },

  -- Flash-style motion jumping (s key + treesitter select with S)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter select" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    },
  },

  -- Formatting on save via conform.nvim (+ <leader>cf)
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
        lua = { "stylua" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        python = { "ruff_format", "ruff_organize_imports" },
        sh = { "shfmt" },
      })
      opts.format_on_save = opts.format_on_save or { timeout_ms = 1500, lsp_format = "fallback" }
      return opts
    end,
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, mode = { "n", "v" }, desc = "[C]ode [F]ormat" },
    },
  },

  -- Linting on save (nvim-lint)
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("lint").linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        python = { "ruff" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        yaml = { "yamllint" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function() require("lint").try_lint() end,
      })
    end,
  },
}
