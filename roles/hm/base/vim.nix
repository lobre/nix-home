{ pkgs, ... }:

{
  # Use an overlay to install nvim 0.5 until it is officially shipped with nix.
  # It brings pkgs.neovim-nightly in scope.
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;

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
      telescope-fzy-native-nvim # fastest sorter for telescope
      nvim-web-devicons # icons for telescope (needs nerd patched font)
      {
        plugin = telescope-nvim;
        config = ''
          lua require('telescope').load_extension('fzy_native')

          nnoremap <C-p> <cmd>Telescope find_files<cr>
          nnoremap <C-b> <cmd>Telescope buffers<cr>
          nnoremap <C-f> <cmd>Telescope live_grep<cr>

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
            map('n', 'gr', '<cmd>Telescope.lsp_references<cr>', opts)
            map('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
            map('n', 'gh', '<Cmd>lua vim.lsp.buf.hover()<cr>', opts)
            map('n', 'gs', '<cmd>Telescope lsp_document_symbols<cr>', opts)
            map('n', 'gN', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', opts)
            map('n', 'gP', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', opts)
            map('n', 'gca', '<cmd>Telescope lsp_code_actions<cr>', opts)

            -- Commands
            vim.cmd("command! LspFormat lua vim.lsp.buf.formatting()")
            vim.cmd("command! LspDiags Telescope lsp_document_diagnostics")

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
    '';
  };

  # Colorscheme
  xdg.configFile."nvim/colors/ansi.vim".source = ./ansi.vim;
}
