-- Pin nvim-treesitter to master: the main-branch rewrite removed parsers.ft_to_lang,
-- which Telescope 0.1.x previewers call (ft_to_lang nil crash on file previews).
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
}
