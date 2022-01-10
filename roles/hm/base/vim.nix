{ pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;

    # Extra packages available to nvim.
    # Useful to install LSP servers.
    extraPackages = with pkgs; [ 
      gopls # go language server
      nodePackages.vscode-langservers-extracted
      nodePackages.yaml-language-server
      zls # zig language server
    ];

    plugins = with pkgs.vimPlugins; [
      emmet-vim
      vim-commentary
      vim-nix
      zig-vim

      {
        plugin = fzf-vim;
        config = ''
          " Floating panel at the bottom
          let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.4, 'yoffset': 1, 'border': 'top' } }

          " Remove shellescape to allow passing flags to rg
          command! -bang -nargs=* Rg
            \ call fzf#vim#grep(
            \   "rg --column --line-number --no-heading --color=always --smart-case ".<q-args>,
            \   1,
            \   fzf#vim#with_preview(),
            \   <bang>0
            \ )

          " Mappings
          nnoremap <C-p> <cmd>Files<cr>
          nnoremap <C-b> <cmd>Buffers<cr>
          nnoremap <C-f> <cmd>Rg ""<cr>
        '';
      }

      cmp-nvim-lsp
      cmp-buffer
      {
        plugin = nvim-cmp;
        config = ''
          lua <<EOF
          local cmp = require('cmp')

          cmp.setup({
            preselect = cmp.PreselectMode.None,
            sources = {
              { name = 'nvim_lsp' },
              { name = 'buffer' }
            },
            mapping = {
              ['<C-y>'] = cmp.config.disable,
            }
          })
          EOF
        '';
      }

      {
        plugin = lsp_signature-nvim;
        config = ''
          lua <<EOF
            require('lsp_signature').setup({
              doc_lines = 0,
              hint_enable = false
            })
          EOF
        '';
      }

      { 
        plugin = nvim-lspconfig;
        config = ''
          lua <<EOF
          local lspconfig = require('lspconfig')

          local on_attach = function(client, bufnr)
            require('lsp_signature').on_attach()

            local function map(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
            local function opt(...) vim.api.nvim_buf_set_option(bufnr, ...) end

            -- Mappings
            local opts = { noremap=true, silent=true }
            map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
            map('n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
            map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
            map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
            map('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
            map('n', 'gh', '<Cmd>lua vim.lsp.buf.hover()<cr>', opts)
            map('n', 'gs', '<Cmd>lua vim.lsp.buf.document_symbol()<cr>', opts)
            map('n', 'ga', '<Cmd>lua vim.lsp.buf.code_action()<cr>', opts)

            -- Commands
            vim.cmd("command! LspFormat lua vim.lsp.buf.formatting()")
            vim.cmd("command! LspDiag lua vim.diagnostic.setloclist()")
            vim.cmd("command! Dnext lua vim.diagnostic.goto_next()")
            vim.cmd("command! Dprev lua vim.diagnostic.goto_prev()")

            -- Format go files on save
            vim.api.nvim_exec([[
              autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)
            ]], false)
          end

          -- Configure servers
          local servers = { "cssls", "eslint", "gopls", "html", "jsonls", "yamlls", "zls" }
          for _, server in ipairs(servers) do
            lspconfig[server].setup { 
              on_attach = on_attach,
              capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
            }
          end
          EOF
        '';
      }

      { 
        plugin = nvim-treesitter;
        config = ''
          lua <<EOF
          require('nvim-treesitter.configs').setup {
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

      {
        plugin = copilot-vim;
        config = ''
          let g:copilot_enabled = 0
        '';
      }
    ];

    extraConfig = ''
      " Disable vim intro page
      set shortmess+=I

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

      " Hide statusline
      set noshowmode
      set noruler
      set laststatus=1
      set noshowcmd

      " Number of lines to keep behond visible screen in terminal buffer 
      set scrollback=50000

      " use custom ansi scheme
      colorscheme ansi

      " Don’t automatically select first item in completion
      set completeopt=menuone,noinsert,noselect

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
      nnoremap <C-l> <cmd>nohlsearch<cr>

      " Jump to tag
      nnoremap gd <C-]>

      " Alternate buffer (C-Space is also C-@)
      nnoremap <C-Space> <C-^>

      " C-c is not exactly equal to Esc as it does not trigger events
      inoremap <C-c> <Esc>

      " Explorer settings
      let g:netrw_liststyle = 3        " show as tree (refresh has a bug https://github.com/vim/vim/issues/5964)
      let g:netrw_winsize = 20         " size of window
      let g:netrw_localrmdir = 'rm -r' " let delete a non-empty directory
      let g:netrw_banner = 0           " don’t show top banner

      " Trigger autoread when files changes on disk
      autocmd FocusGained,BufEnter * silent! checktime
      autocmd CursorHold,CursorHoldI * silent! checktime
      autocmd CursorMoved,CursorMovedI * silent! checktime " this one could be slow

      " Load cfilter to filter quickfix (bundled with nvim)
      packadd cfilter

      " Simple git blame
      command! Blame execute "!git blame -c --date=short -L " . line(".") . ",+1 %"

      " Terminal navigation
      tnoremap <C-w>o <cmd>only<cr>
      tnoremap <C-w>h <C-\><C-N><C-w>h
      tnoremap <C-w>j <C-\><C-N><C-w>j
      tnoremap <C-w>k <C-\><C-N><C-w>k
      tnoremap <C-w>l <C-\><C-N><C-w>l
      tnoremap <C-w>H <C-\><C-N><C-w>H
      tnoremap <C-w>J <C-\><C-N><C-w>J
      tnoremap <C-w>K <C-\><C-N><C-w>K
      tnoremap <C-w>L <C-\><C-N><C-w>L
      tnoremap <C-w><C-w> <C-\><C-N><C-w><C-w>

      " Terminal stays in insert mode
      autocmd TermOpen,BufWinEnter,WinEnter term://* startinsert

      " Exit terminal with Esc
      tnoremap <Esc> <C-\><C-n>
    '';
  };

  # Colorscheme
  xdg.configFile."nvim/colors/ansi.vim".source = ./ansi.vim;
}
