-- Chip Hogg's neovim config
--
-- Adapted from `~/.vimrc`, starting November 2025.

-- vim: set foldmethod=marker foldlevel=0:

-- Plugins -----------------------------------------------------------------{{{1
--
-- Use neovim's native package manager, `vim.pack`, rather than `lazy.vim`.  I
-- want to stick with the simpler experience unless and until I find some
-- concrete reason (e.g., startup time) to change.

local function from_github(user, repo, opts)
    opts = opts or {}
    opts.src = string.format("https://github.com/%s/%s", user, repo)
    return opts
end

vim.pack.add({
    -- Vim enhancements ----------------------------------------------------{{{2
    from_github("google", "vim-syncopate"),
    from_github("jlanzarotta", "bufexplorer"),
    from_github("justinmk", "vim-dirvish"),
    from_github("justinmk", "vim-sneak"),
    from_github("klen", "nvim-config-local"),
    from_github("ntpeters", "vim-better-whitespace"),
    from_github("tpope", "vim-eunuch"),
    from_github("tpope", "vim-repeat"),
    from_github("tpope", "vim-rhubarb"),
    from_github("tpope", "vim-speeddating"),
    from_github("tpope", "vim-surround"),
    from_github("tpope", "vim-unimpaired"),

    -- Snippets ------------------------------------------------------------{{{2
    from_github("SirVer", "ultisnips"),
    from_github("honza", "vim-snippets"),

    -- Text objects --------------------------------------------------------{{{2

    -- Note that `("kana", "vim-textobj-user")` is required by all the rest.
    from_github("kana", "vim-textobj-user"),

    from_github("Julian", "vim-textobj-variable-segment"),
    from_github("kana", "vim-textobj-indent"),

    -- Git and general programming -----------------------------------------{{{2
    from_github("chiphogg", "vim-codefmt"),
    from_github("github", "copilot.vim"),
    from_github("neoclide", "coc.nvim", {version = "release"}),
    from_github("rking", "ag.vim"),
    from_github("tpope", "vim-endwise"),
    from_github("tpope", "vim-fugitive"),

    -- Markdown and markup -------------------------------------------------{{{2
    from_github("vim-pandoc", "vim-pandoc"),
    from_github("vim-pandoc", "vim-pandoc-syntax"),
    from_github("vim-pandoc", "vim-rmarkdown"),

    -- Python --------------------------------------------------------------{{{2
    from_github("fisadev", "vim-isort"),

    -- Currently timing out:
    -- from_github("psf", "black", {version = "stable"}),

    from_github("tmhedberg", "SimpylFold"),

    -- For maktaba-based plugins -------------------------------------------{{{2
    from_github("google", "maktaba"),
    from_github("google", "glaive"),
})

vim.cmd("call glaive#Install()")

-- Utilities ---------------------------------------------------------------{{{1

-- Make `augroup` easier to use.  Get automatic grouping, and avoid having to
-- make a local variable for the group that just hangs around.
--
-- Source: https://mskelton.dev/bytes/20240917222651
local function augroup(name, func)
    local group = vim.api.nvim_create_augroup(name, {clear = true})

    local function autocmd(event, opts)
        vim.api.nvim_create_autocmd(
            event,
            vim.tbl_extend("force", opts, {group = group})
        )
    end

    func(autocmd)
end

-- Basic settings ----------------------------------------------------------{{{1

-- ',' is easy to type, so use it for <Leader> to make compound commands easier:
vim.g.mapleader = ","
-- Unfortunately, this introduces a delay for the ',' command.  Let's compensate
-- by introducing a speedy alternative...
vim.api.nvim_set_keymap('', ',.', ',', {noremap=true})

-- Improving basic commands ------------------------------------------------{{{2

-- Easy quit-all, which is unlikely to be mistyped.
vim.api.nvim_set_keymap(
    'n', '<Leader>qwer', ':confirm qa<CR>', {noremap=true, silent=true})

-- Y should work like D and C.
vim.api.nvim_set_keymap('n', 'Y', 'y$', {noremap=true})

-- Jumping to marks: You pretty much always want to jump to the cursor position
-- (`), not the beginning of the line (').  But, the apostrophe is much more
-- conveniently located.  So, save your fingers and swap 'em!
vim.api.nvim_set_keymap('n', "'", "`", {noremap=true})
vim.api.nvim_set_keymap('n', "`", "'", {noremap=true})

-- Jump list navigation: Ctrl-O goes back, and Tab goes forward.  But Tab is
-- best reserved for other uses.
-- MY solution: Use Ctrl-P to go forward.  P is to the right of O, so the
-- mnemonic is (O, P) <-> (Left, Right) one jump
-- (Btw, the default normal-mode Ctrl-P appears fairly useless: looks like a
-- clone of 'k'.  So, we're not giving up much.)
vim.api.nvim_set_keymap('', '<C-P>', '<Tab>', {noremap=true})

-- Some filetypes work best with 'nowrap'.  Vim moves left and right using zL
-- and zH, but this is awkward.  ZL and ZH are easier alternatives.
vim.api.nvim_set_keymap('n', 'ZL', 'zL', {noremap=true})
vim.api.nvim_set_keymap('n', 'ZH', 'zH', {noremap=true})

-- This makes it easier to tell when I hit the last search result.  In practice,
-- I rarely want it to wrap around more than once, and 'gg' is easy enough.
vim.opt.wrapscan = false

-- Windows, tabs, and buffers ----------------------------------------------{{{2

-- Let vim hide unsaved buffers.
vim.opt.hidden = true

-- Text formatting ---------------------------------------------------------{{{2

-- 80 characters is a good default setting for readability.
vim.opt.textwidth = 80

-- Highlight the first three characters over the line length limit.  Clearing
-- the highlight group first makes the background the same colour, so we only
-- see this once we actually exceed the limit.
--
-- (Note: we have to use autocommands for the highlighting since :colorscheme
-- can overwrite this highlighting, and :colorscheme apparently gets applied
-- after `init.lua` is done sourcing.)
vim.opt.colorcolumn = '+1,+2,+3'
augroup("colorcolumn", function(autocmd)
    autocmd("ColorScheme", {
        pattern = "*",
        command = "highlight clear ColorColumn",
    })
    autocmd("ColorScheme", {
        pattern = "*",
        command = "highlight ColorColumn guifg=red ctermfg=red gui=bold",
    })
end)


-- Experience shows: tabs *occasionally* cause problems; spaces *never* do.
-- Besides, neovim is smart enough to make it "feel like" real tabs.
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
-- Make tabs visible!
vim.opt.list = true
vim.opt.listchars = "tab:»·,precedes:<,extends:>"

-- Soft-wrapping is more readable than scrolling...
vim.opt.wrap = true
-- ...but don't break in the middle of a word!
vim.opt.linebreak = true

-- Almost every filetype is better with autoindent.
-- (Let filetype-specific settings handle the rest.)
vim.opt.autoindent = true

-- Format options.  See ":help fo-table" and ":help 'fo'" for more details.
local fo = vim.opt.formatoptions
fo:append('t')  -- Auto-wrap text...
fo:append('c')  -- ...and comments.
fo:append('q')  -- Let me format comments manually.
fo:append('r')  -- Auto-continue comments if I'm still in insert mode,
fo:remove('o')  -- but not when coming from normal mode (that's annoying).
fo:append('n')  -- Handle numbered lists properly: good for writing emails!
fo:append('j')  -- Be smart about comment leaders when joining lines.

-- Removing 'o' must be done in an autocmd if we want it to take precedence
-- over all filetype plugins.  As usual, use augroup for re-entrant-ness.
local formatoptions = vim.api.nvim_create_augroup('formatoptions', {})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    group = formatoptions,
    command = "setlocal formatoptions-=o",
})

-- Folding -----------------------------------------------------------------{{{2

-- Here are some "fold focusing" commands.

-- Close all folds, and open only enough to view the current line
vim.api.nvim_set_keymap('n', '<Leader>z', 'zMzv', {noremap=true})

-- Go up (ZK) and down (ZJ) a fold, closing all other folds
vim.api.nvim_set_keymap('n', 'ZJ', 'zjzMzv', {noremap=true})
vim.api.nvim_set_keymap('n', 'ZK', 'zkzMzv', {noremap=true})

-- Miscellaneous settings --------------------------------------------------{{{2

vim.opt.number = true

-- Occasionally useful, but mainly too annoying.
vim.opt.hlsearch = false

vim.cmd.colorscheme("desert")

-- I am much more often annoyed by swap files than helped by them.
vim.opt.swapfile = false

-- Always prefer vertical diffs (it's easier to understand when side-by-side).
-- Note that newer versions of fugitive will sometimes use horizontal diffs
-- (e.g., for thinner windows) unless this is explicitly set.
vim.opt.diffopt:append("vertical")

-- Plugin settings ---------------------------------------------------------{{{1

-- ag ----------------------------------------------------------------------{{{2

-- Use ripgrep (it's much faster), but keep the blank lines between files.
-- (See chiphogg/binfiles on github for this script's definition.)
vim.g.ag_prg = "rg_vimgrep_spaced"

-- Search for the word under the cursor, along with suitable prefix/suffix.
local function AgSearchWordUnderCursor(prefix, suffix)
    local word = vim.fn.escape(vim.fn.expand('<cword>'), '#')
    vim.cmd("Ag '" .. prefix .. word .. suffix .. "'")
end

-- :Ag the word under the cursor (populates quickfix list).
vim.api.nvim_create_user_command(
    'AgWordUnderCursor',
    function() AgSearchWordUnderCursor("\\b", "\\b") end,
    {nargs = 0}
)
vim.api.nvim_set_keymap(
    'n',
    '<LocalLeader>ag',
    ":AgWordUnderCursor<CR>",
    {noremap=true, silent=true})

-- dirvish -----------------------------------------------------------------{{{2

vim.g.dirvish_mode = ':sort! | :sort! r /[/]$/'

-- fugitive ----------------------------------------------------------------{{{2

vim.api.nvim_set_keymap(
    'n', '<LocalLeader>gs', ':Git<CR>', {noremap=true, silent=true})

-- nvim-config-local -------------------------------------------------------{{{2

require("config-local").setup()

-- pandoc ------------------------------------------------------------------{{{2

-- I find conceal harms my understanding of markdown documents.
vim.g.pandoc_use_conceal = 0

-- This plugin egregiously enables all its modules by default, even the ones
-- with surprising and unwelcome effects.  See:
-- https://github.com/vim-pandoc/vim-pandoc/issues/272
vim.cmd("let g:pandoc#modules#disabled = ['chdir']")

-- syncopate ---------------------------------------------------------------{{{2

-- Enable keymapping for HTML output.
vim.cmd("Glaive syncopate plugin[mappings]")

-- Don't copy the fold column (f), line numbers (n), or diff filler (d) in HTML
-- output.
vim.g.html_prevent_copy = "fnd"
-- But that only works for middle-click paste, and Ctrl-V is more useful for me.
-- So just disable line numbers and folding altogether.
vim.g.html_number_lines = 0
vim.g.html_ignore_folding = 1

-- UltiSnips ---------------------------------------------------------------{{{2
vim.g.UltiSnipsExpandTrigger = "<c-j>"
vim.g.UltiSnipsJumpForwardTrigger = "<c-j>"
vim.g.UltiSnipsJumpBackwardTrigger = "<c-k>"

-- GUI settings ------------------------------------------------------------{{{1

vim.o.guifont = "JetBrains Mono:h10"
