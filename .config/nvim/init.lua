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
    from_github("tpope", "vim-abolish"),
    from_github("tpope", "vim-eunuch"),
    from_github("tpope", "vim-repeat"),
    from_github("tpope", "vim-rhubarb"),
    from_github("tpope", "vim-speeddating"),
    from_github("tpope", "vim-surround"),
    from_github("tpope", "vim-unimpaired"),

    -- Colorschemes --------------------------------------------------------{{{2
    from_github("jnurmine", "Zenburn"),
    from_github("Mofiqul", "vscode.nvim"),

    -- Tree-sitter ---------------------------------------------------------{{{2
    from_github("nvim-treesitter", "nvim-treesitter", {version = "main"}),
    from_github(
        "nvim-treesitter", "nvim-treesitter-textobjects", {version = "main"}),

    -- Snippets ------------------------------------------------------------{{{2
    from_github("SirVer", "ultisnips"),
    from_github("honza", "vim-snippets"),

    -- Text objects --------------------------------------------------------{{{2

    -- Note that `("kana", "vim-textobj-user")` is required by all the rest.
    from_github("kana", "vim-textobj-user"),

    from_github("Julian", "vim-textobj-variable-segment"),
    from_github("kana", "vim-textobj-entire"),
    from_github("kana", "vim-textobj-indent"),

    -- Git and general programming -----------------------------------------{{{2
    from_github("chiphogg", "vim-codefmt"),
    from_github("neoclide", "coc.nvim", {version = "release"}),
    from_github("rking", "ag.vim"),
    from_github("sindrets", "diffview.nvim"),
    from_github("tpope", "vim-endwise"),
    from_github("tpope", "vim-fugitive"),

    -- AI ------------------------------------------------------------------{{{2
    from_github("github", "copilot.vim"),
    from_github("nvim-lua", "plenary.nvim"),
    from_github("olimorris", "codecompanion.nvim"),

    -- Terminals -----------------------------------------------------------{{{2
    from_github("akinsho", "toggleterm.nvim"),
    from_github("samjwill", "nvim-unception"),

    -- Markdown and markup -------------------------------------------------{{{2
    from_github("vim-pandoc", "vim-pandoc"),
    from_github("vim-pandoc", "vim-pandoc-syntax"),
    from_github("vim-pandoc", "vim-rmarkdown"),

    -- Python --------------------------------------------------------------{{{2
    from_github("fisadev", "vim-isort"),
    from_github("psf", "black", {version = "stable"}),
    from_github("tmhedberg", "SimpylFold"),

    -- For maktaba-based plugins -------------------------------------------{{{2
    from_github("google", "maktaba"),
    from_github("google", "glaive"),
})

-- Check for a `~/.local_plugins.lua` file, and source it if it exists.
if vim.fn.filereadable(vim.fn.expand("~/.local_plugins.lua")) == 1 then
    vim.cmd("source ~/.local_plugins.lua")
end

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

-- Make it easier to set a `highlight` command.
--
-- Specify only the options you want; others will be undisturbed.
--
-- Set `allbg` or `allfg` to set both cterm and gui colors at once.  (Note that
-- this will not be a good idea unless your color is valid for cterm, not just
-- gui.  See `:help cterm-colors` for more details.)
local function highlight(group, args)
    if args["allbg"] then
        args["ctermbg"] = args["allbg"]
        args["guibg"] = args["allbg"]
    end
    if args["allfg"] then
        args["ctermfg"] = args["allfg"]
        args["guifg"] = args["allfg"]
    end
    local function setting(key)
        if args[key] then
            return string.format("%s=%s", key, args[key])
        else
            return ""
        end
    end
    highlight_cmd = string.format(
        "highlight %s %s %s %s %s %s",
        group,
        setting("ctermfg"),
        setting("ctermbg"),
        setting("guifg"),
        setting("guibg"),
        setting("gui")
    )
    vim.cmd(highlight_cmd)
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
        -- NOTE: this does not appear to actually work.  The characters are
        -- bold, but not red.  This always worked on vim, so I hope I can figure
        -- this out later.
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

-- Text highlighting -------------------------------------------------------{{{2

-- Always enable true color support wherever possible.
vim.opt.termguicolors = true

-- The default colours in diff mode have poor readability.  This change seems to
-- work well for a wide variety of colorschemes.  See
-- <https://www.reddit.com/r/neovim/comments/1k3ugsd> for more details.
local function set_diff_highlights()
    if vim.o.background == "dark" then
        highlight("DiffAdd",    {gui="bold", guibg="#2e4b2e", guifg="none"})
        highlight("DiffDelete", {gui="bold", guibg="#4c1e15", guifg="none"})
        highlight("DiffChange", {gui="bold", guibg="#45565c", guifg="none"})
        highlight("DiffText",   {gui="bold", guibg="#996d74", guifg="none"})
    else
        highlight("DiffAdd",    {gui="bold", guibg="palegreen", guifg="none"})
        highlight("DiffDelete", {gui="bold", guibg="tomato", guifg="none"})
        highlight("DiffChange", {gui="bold", guibg="lightblue", guifg="none"})
        highlight("DiffText",   {gui="bold", guibg="lightpink", guifg="none"})
    end
end
augroup("diff_highlight", function(autocmd)
    autocmd("ColorScheme", {pattern = "*", callback = set_diff_highlights})
end)

-- A nice, balanced, readable choice.
vim.cmd.colorscheme("zenburn")

-- The `MatchParen` in some colorschemes, such as `desert`, is awful: it looks
-- just like the cursor, so you can't tell where you are when the cursor is on a
-- parenthesis. (Interestingly, I never had this problem in vim, only nvim.)
-- Anyway, the fix is to stop changing the background color, while still keeping
-- the match easy to spot.
highlight("MatchParen", {allfg = "magenta", gui = "bold"})

-- Show highlighting information for what's under the cursor.
vim.cmd([[
    nnoremap <Leader>h :echo "hi<"
    \ . synIDattr(synID(line("."), col("."), 1), "name") . '> trans<'
    \ . synIDattr(synID(line("."), col("."), 0), "name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name") . ">"<CR>
]])

-- Folding -----------------------------------------------------------------{{{2

-- Here are some "fold focusing" commands.

-- Close all folds, and open only enough to view the current line
vim.api.nvim_set_keymap('n', '<Leader>z', 'zMzv', {noremap=true})

-- Go up (ZK) and down (ZJ) a fold, closing all other folds
vim.api.nvim_set_keymap('n', 'ZJ', 'zjzMzv', {noremap=true})
vim.api.nvim_set_keymap('n', 'ZK', 'zkzMzv', {noremap=true})

-- Terminals ---------------------------------------------------------------{{{2

-- Exit insert mode in terminals using the familiar `<Esc>` key.
--
-- Note that we shouldn't really need to explicitly map `<C-[>` too, in
-- principle, since it's typically equivalent to `<Esc>`.  But in practice, some
-- GUIs (such as neovide) don't treat these as equivalent.
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]])
vim.keymap.set('t', '<C-[>', [[<C-\><C-n>]])

-- <C-x> goes into "terminal mode" (i.e., "insert mode for terminal"), whether
-- or not you're already there.
--
-- Why do this?  Because often I go into normal mode after running a command (so
-- that I can elegantly control scrolling), but not always.  If I hit `a` when I
-- think I'm in normal mode but I'm actually in insert mode, and then complete
-- the previous command, it'll grab _the previous command with an `a` prefix_.
-- Much better to train a keystroke that doesn't depend on the mode.
--
-- Here's the terminal-mode version (maps to no-op since we're already good)...
vim.keymap.set('t', '<C-x>', [[]])
-- ...and here's the normal-mode version (where we use an autocmd so that it
-- only applies to terminal buffers).
augroup("terminal_insert_mode", function(autocmd)
    autocmd("TermOpen", {
        pattern = "term://*",
        callback = function()
            vim.keymap.set('n', '<C-x>', [[i]], {buffer = true})
        end,
    })
end)

-- Keep _lots_ of history.  (Default is 10,000, and I often feel I need more.)
vim.opt.scrollback = 100000

-- Miscellaneous settings --------------------------------------------------{{{2

vim.opt.number = true

-- Occasionally useful, but mainly too annoying.
vim.opt.hlsearch = false

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

-- CodeCompanion -----------------------------------------------------------{{{2

require("codecompanion").setup()

-- dirvish -----------------------------------------------------------------{{{2

vim.g.dirvish_mode = ':sort! | :sort! r /[/]$/'

-- fugitive ----------------------------------------------------------------{{{2

vim.api.nvim_set_keymap(
    'n', '<LocalLeader>gs', ':Git<CR>', {noremap=true, silent=true})

-- nvim-config-local -------------------------------------------------------{{{2

require("config-local").setup()

-- nvim-treesitter ---------------------------------------------------------{{{2

require("nvim-treesitter").install({
    "bash",
    "c",
    "cpp",
    "json",
    "lua",
    "markdown",
    "python",
    "vim",
    "yaml",
})

require("nvim-treesitter-textobjects").setup({
    select = {
        -- If we're not in a matching textobject, jump forward to the next one.
        -- Super convenient!
        lookahead = true,
        selection_modes = {
            -- Select by individual characters:
            ['@parameter.outer'] = 'v',
            -- Select entire lines:
            ['@function.outer'] = 'V',
            ['@loop.outer'] = 'V',
            ['@statement.outer'] = 'V',
        },
    },
})

-- Add keymaps for text objects provided by nvim-treesitter-textobjects.
-- Recall that "x" indicates visual mode, and "o" indicates operator-pending
-- mode.  See `:help map-modes` for more details.
local function ts_textobj(abbrev, textobj)
    vim.keymap.set({"x", "o"}, abbrev, function()
        require("nvim-treesitter-textobjects.select").select_textobject(
            textobj, "textobjects")
    end)
end
ts_textobj("atb", "@block.outer")
ts_textobj("itb", "@block.inner")
ts_textobj("atc", "@class.outer")
ts_textobj("itc", "@class.inner")
ts_textobj("at?", "@conditional.outer")
ts_textobj("it?", "@conditional.inner")
ts_textobj("at/", "@comment.outer")
ts_textobj("it/", "@comment.inner")
ts_textobj("atf", "@function.outer")
ts_textobj("itf", "@function.inner")
ts_textobj("atl", "@loop.outer")
ts_textobj("itl", "@loop.inner")
ts_textobj("at,", "@parameter.outer")
ts_textobj("it,", "@parameter.inner")
ts_textobj("atr", "@return.outer")
ts_textobj("itr", "@return.inner")
ts_textobj("at;", "@statement.outer")

-- Parameter swaps with `,th` and `,tl`
vim.keymap.set('n', '<Leader>th', function()
    require("nvim-treesitter-textobjects.swap").swap_previous(
        "@parameter.inner")
end)
vim.keymap.set('n', '<Leader>tl', function()
    require("nvim-treesitter-textobjects.swap").swap_next(
        "@parameter.inner")
end)

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

-- toggleterm.nvim ---------------------------------------------------------{{{2

require("toggleterm").setup{
    size = 100,
    open_mapping = [[<c-\>]],
    direction = 'vertical',

    -- I strongly prefer to be able to go into normal mode, and have the cursor
    -- stay put when I do.  If I want to hop to the end, I can press `G` or `a`.
    auto_scroll = false,
}

-- UltiSnips ---------------------------------------------------------------{{{2
vim.g.UltiSnipsExpandTrigger = "<c-j>"
vim.g.UltiSnipsJumpForwardTrigger = "<c-j>"
vim.g.UltiSnipsJumpBackwardTrigger = "<c-k>"

-- GUI settings ------------------------------------------------------------{{{1

vim.o.guifont = "JetBrains Mono:h10"
