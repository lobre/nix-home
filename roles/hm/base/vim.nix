{ config, pkgs, ... }:

let
  htmlSkeleton = pkgs.writeText "html-skeleton" ''
    <!DOCTYPE html>
    <html lang="en">

    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>Page Title</title>
    </head>

    <body>
      Page Content
    </body>

    </html>
  '';
in

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;

    extraConfig = ''
      " General options
      set completeopt=menu,menuone,noselect  " Don't select first entry in autocomplete and disable preview
      set inccommand=split                   " Show effect of substitute in split
      set noruler                            " Disable ruler
      set noshowcmd                          " Hide pending keys messages
      set number relativenumber              " Show relative line numbers
      set scrollback=50000                   " Lines to keep in terminal buffer
      set shortmess+=I                       " Disable intro page
      set undofile                           " Preserve undo history across sessions
      set wildignore=ctags,.git/             " Ignore files and dirs in searches
      set wildoptions+=fuzzy                 " Use fuzzy matching in completion
      set wildmode=longest:full,full         " Completion menu
      set diffopt+=linematch:50              " Better diff mode (https://github.com/neovim/neovim/pull/14537)

      " Don’t set terminal title until issue fixed 
      " https://github.com/neovim/neovim/issues/18573
      set notitle

      " Grep with git grep
      set grepprg=git\ -c\ grep.fallbackToNoIndex\ --no-pager\ grep\ --no-color\ -nI
      set grepformat=%f:%l:%c:%m,%f:%l:%m,%f

      " Don’t show shell output of grep and lgrep
      cabbrev <expr> grep (getcmdtype() == ':' && getcmdpos() == 5) ? "sil grep" : "grep"
      cabbrev <expr> lgrep (getcmdtype() == ':' && getcmdpos() == 6) ? "sil lgrep" : "lgrep"

      " Language specific indentation settings
      set shiftwidth=4 tabstop=4 expandtab
      autocmd FileType go setlocal shiftwidth=8 tabstop=8 noexpandtab
      autocmd FileType html,css,json,nix,xml setlocal shiftwidth=2 tabstop=2

      " Make programs
      autocmd Filetype go set makeprg=go\ build
      autocmd Filetype zig set makeprg=zig\ build

      " Save with sudo
      command! W w !sudo tee % > /dev/null

      " Indent line in visual mode
      vnoremap < <gv
      vnoremap > >gv

      " Center cursor upon half page moves and search
      nnoremap <c-d> <c-d>zz
      nnoremap <c-u> <c-u>zz
      nnoremap n nzzzv
      nnoremap N Nzzzv

      " Quickfix mappings
      nnoremap <c-j> <cmd>cnext<cr>zz
      nnoremap <c-k> <cmd>cprev<cr>zz

      " Alternate file
      nnoremap ga <c-^>

      " Escape from visual line and terminal modes
      tnoremap <esc> <c-\><c-n>
      inoremap <c-c> <esc>

      " Make C-n/C-p act as Up/Down by completing command
      cnoremap <expr> <c-p> wildmenumode() ? "<c-p>" : "<up>"
      cnoremap <expr> <c-n> wildmenumode() ? "<c-n>" : "<down>"

      " Promote omnicompletion directly to ctrl-n/p
      inoremap <expr> <c-n> &omnifunc ==# 'v:lua.vim.lsp.omnifunc' ? "\<c-x>\<c-o>" : "\<c-n>"
      inoremap <expr> <c-p> &omnifunc ==# 'v:lua.vim.lsp.omnifunc' ? "\<c-x>\<c-o>" : "\<c-p>"

      " Trigger autoread when files changes on disk
      autocmd FocusGained,BufEnter * silent! checktime
      autocmd CursorHold,CursorHoldI * silent! checktime
      autocmd CursorMoved,CursorMovedI * silent! checktime " this one could be slow

      " html skeleton
      autocmd BufNewFile index.html 0read ${htmlSkeleton}

      " Filter quicklist with the included cfilter plugin
      packadd cfilter

      " Explorer settings
      let g:netrw_banner = 0           " Don’t show top banner
      let g:netrw_localrmdir = 'rm -r' " Let delete a non-empty directory

      " Blame current line
      command! Blame echomsg trim(system(
        \ "git --no-pager log -s -1 --pretty='%h %an, %ad • %s' --date=human -L " . line('.') . ",+1:"
        \ . expand('%')))

      " Go back to prev position when opening file. See :h restore-cursor
      autocmd BufRead * autocmd FileType <buffer> ++once
        \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif

      " Try to include local config
      if filereadable(expand("~/.vimrc.local"))
        source ~/.vimrc.local
      endif
    '';

    # lsp servers
    extraPackages = with pkgs; [ gopls nil phpactor zls ];

    plugins = with pkgs.vimPlugins; [
      {
        plugin = vim-noctu;
        config = ''
          colorscheme noctu
          highlight StatusLine cterm=NONE
          highlight StatusLineNC cterm=NONE
        '';
      }

      {
        plugin = harpoon;
        config = ''
          lua <<EOF
          vim.g.mapleader = " "
          local mark = require("harpoon.mark")
          local ui = require("harpoon.ui")
          local term = require("harpoon.term")

          vim.keymap.set("n", "<leader>m", mark.add_file)
          vim.keymap.set("n", "<leader>e", ui.toggle_quick_menu)

          vim.keymap.set("n", "<leader>a", function() ui.nav_file(1) end)
          vim.keymap.set("n", "<leader>s", function() ui.nav_file(2) end)
          vim.keymap.set("n", "<leader>d", function() ui.nav_file(3) end)
          vim.keymap.set("n", "<leader>f", function() ui.nav_file(4) end)

          vim.keymap.set("n", "<leader>t", function() term.gotoTerminal(1) end)
          vim.keymap.set("n", "<leader>g", function() term.gotoTerminal(2) end)
          EOF
        '';
      }

      {
        plugin = nvim-lspconfig;
        config = ''
          lua <<EOF
          local lspconfig = require('lspconfig')
          lspconfig.gopls.setup {}
          lspconfig.nil_ls.setup {
            settings = {
              ['nil'] = {
                formatting = {
                  command = { "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" },
                },
              },
            },
          }
          lspconfig.phpactor.setup {}
          lspconfig.zls.setup {}

          vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
              vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

              local opts = { buffer = args.buf }
              vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
              vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
              vim.keymap.set('n', 'gR', vim.lsp.buf.rename, opts)
              vim.keymap.set('n', 'gca', vim.lsp.buf.code_action, opts)
              vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
              vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)

              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client.server_capabilities.documentFormattingProvider then
                vim.api.nvim_create_autocmd("BufWritePre", {
                  buffer = bufnr,
                  callback = function()
                    vim.lsp.buf.format()
                  end,
                })
              end
            end
          })
          EOF
        '';
      }
    ];
  };
}
