vim.treesitter.start()

-- Use syntax-based folding from treesitter.
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- Folding is nice, but start with all folds open.
vim.opt_local.foldlevel = 99
