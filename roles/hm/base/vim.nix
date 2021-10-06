{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;

    # Extra packages available to nvim.
    # Useful to install LSP servers.
    extraPackages = with pkgs; [ 
      gopls # go language server
      nodePackages.bash-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.vim-language-server
      nodePackages.vscode-json-languageserver
      nodePackages.yaml-language-server
      rnix-lsp # nix language server
      zls # zig language server
    ];

    plugins = with pkgs.vimPlugins; [
      vim-nix
      zig-vim
      vim-commentary
      emmet-vim
      completion-nvim # autocompletion popup

      plenary-nvim # dep of telescope
      popup-nvim   # dep of telescope
      telescope-fzf-native-nvim # fastest sorter for telescope
      nvim-web-devicons # icons for telescope (needs nerd patched font)
      {
        plugin = telescope-nvim;
        config = ''
          lua <<EOF
          local actions = require('telescope.actions')
          require('telescope').setup {
            defaults = {
              mappings = {
                i = {
                  ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                },
                n = {
                  ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                },
              }
            }
          }

          require('telescope').load_extension('fzf')
          EOF

          command! -nargs=? Find lua require'telescope.builtin'.find_files{
            \ default_text = vim.fn.expand("<args>")
          \ }<cr>

          command! -nargs=? FindAll lua require'telescope.builtin'.find_files{
            \ default_text = vim.fn.expand("<args>"),
            \ find_command = {
              \ "rg",
              \ "--files",
              \ "--no-ignore-vcs",
              \ "--hidden",
              \ "--glob", "!.git"
            \}
          \ }<cr>

          command! -nargs=? Grep lua require'telescope.builtin'.live_grep{
            \ default_text = vim.fn.expand("<args>")
          \ }<cr>

          command! -nargs=? GrepAll lua require'telescope.builtin'.live_grep{
            \ default_text = vim.fn.expand("<args>"),
            \ vimgrep_arguments = {
              \ "rg",
              \ "--color=never",
              \ "--no-heading",
              \ "--with-filename",
              \ "--line-number",
              \ "--column",
              \ "--smart-case",
              \ "--no-ignore-vcs",
              \ "--hidden",
              \ "--glob", "!.git"
            \}
          \}<cr>

          command! -nargs=? Tags lua require'telescope.builtin'.tags{ default_text = vim.fn.expand("<args>") }<cr>
          command! -nargs=? Help lua require'telescope.builtin'.help_tags{ default_text = vim.fn.expand("<args>") }<cr>

          command! GitHistory Telescope git_bcommits

          " Keybindings
          nnoremap <C-p> <cmd>Find<cr>
          nnoremap <C-b> <cmd>Telescope buffers<cr>
          nnoremap <C-f> <cmd>Grep<cr>
          nnoremap g<C-p> <cmd>FindAll<cr>
          nnoremap g<C-f> <cmd>GrepAll<cr>
          nnoremap g<C-t> <cmd>Tags<cr>
        '';
      }

      { 
        plugin = nvim-lspconfig;
        config = ''
          lua <<EOF
          local lspconfig = require('lspconfig')

          local on_attach = function(client, bufnr)
            require('completion').on_attach()

            local function map(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
            local function opt(...) vim.api.nvim_buf_set_option(bufnr, ...) end

            -- Mappings
            local opts = { noremap=true, silent=true }
            map('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', opts)
            map('n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
            map('n', 'gi', '<cmd>Telescope lsp_implementations<cr>', opts)
            map('n', 'gr', '<cmd>Telescope lsp_references<cr>', opts)
            map('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
            map('n', 'gh', '<Cmd>lua vim.lsp.buf.hover()<cr>', opts)
            map('n', 'gs', '<cmd>Telescope lsp_document_symbols<cr>', opts)
            map('n', 'gS', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', opts)
            map('n', 'ga', '<cmd>Telescope lsp_code_actions<cr>', opts)

            -- Commands
            vim.cmd("command! LspFormat lua vim.lsp.buf.formatting()")
            vim.cmd("command! Dnext lua vim.lsp.diagnostic.goto_next()")
            vim.cmd("command! Dprev lua vim.lsp.diagnostic.goto_prev()")

            -- Format go files on save
            vim.api.nvim_exec([[
              autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)
            ]], false)
          end

          -- Configure servers
          local servers = { "gopls", "bashls", "dockerls", "vimls", "jsonls", "yamlls", "rnix", "zls" }
          for _, server in ipairs(servers) do
            lspconfig[server].setup { on_attach = on_attach }
          end
          EOF
        '';
      }

      { 
        plugin = nvim-treesitter;
        config = ''
          lua <<EOF
          require'nvim-treesitter.configs'.setup {
            highlight = {
              enable = true
            },
            indent = {
              enable = true
            }
          }
          EOF
        '';
      }
    ];

    extraConfig = ''
      set showbreak=↪\
      set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨

      " wildmode that works well with nvim popup menu
      set wildmode=longest:full,full

      set ignorecase     " Case insensitive
      set wildignorecase " Autocomplete case insensitive
      set smartcase      " Enable case sensitivity if search contains upper letter
      set hidden         " No need to save a buffer before switching
      set smartindent    " Smart autoindenting when starting new line
      set title          " Update the title of the window 
      set mouse=a        " Enable mouse mode

      " Number of lines to keep behond visible screen in terminal buffer 
      set scrollback=50000

      " use custom ansi scheme
      colorscheme ansi

      " Don’t automatically select first item in completion
      set completeopt=menuone,noinsert,noselect

      " Avoid showing message extra message when using completion
      set shortmess+=c

      " Split as expected
      set splitright
      set splitbelow

      " Default tabs count parameters
      set tabstop=2
      set shiftwidth=2
      set expandtab

      " Language specific indentation settings
      autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4
      autocmd FileType sh setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

      " Search with rg if available
      if executable('rg')
          set grepprg=rg\ --vimgrep\ --no-heading
          set grepformat=%f:%l:%c:%m,%f:%l:%m
      endif

      " Save with sudo
      command! W w !sudo tee % > /dev/null

      " Clear current highlighted search
      nnoremap <C-l> :nohlsearch<cr>

      " Terminal navigation
      tnoremap <C-w>h <C-\><C-N><C-w>h
      tnoremap <C-w>j <C-\><C-N><C-w>j
      tnoremap <C-w>k <C-\><C-N><C-w>k
      tnoremap <C-w>l <C-\><C-N><C-w>l
      tnoremap <C-w><C-w> <C-\><C-N><C-w><C-w>

      " Terminal stays in insert mode
      " See https://github.com/neovim/neovim/issues/9483
      autocmd TermOpen,BufWinEnter,WinEnter term://* startinsert
      autocmd TermOpen * nnoremap <buffer><LeftRelease> <LeftRelease>i

      " Exit terminal with Esc
      tnoremap <Esc> <C-\><C-n>

      " Jump to tag
      nnoremap gd <C-]>

      " Explorer settings
      let g:netrw_liststyle=3
      let g:netrw_winsize = 25
      let g:netrw_localrmdir='rm -r'

      " Trigger autoread when files changes on disk
      autocmd FocusGained * checktime

      " Emacs like keys for command line (:h emacs-keys)
      cnoremap <C-a> <Home>
      cnoremap <C-e> <End>
      cnoremap <M-b> <S-Left>
      cnoremap <M-f> <S-Right>

      " Load cfilter to filter quickfix (bundled with nvim)
      packadd cfilter

      " Alternate buffer
      nnoremap <C-a> <C-^>
    '';
  };

  # Colorscheme
  xdg.configFile."nvim/colors/ansi.vim".source = ./ansi.vim;
}
