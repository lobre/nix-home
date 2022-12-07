{ config, pkgs, ... }:

{
  # Colorscheme
  xdg.configFile."nvim/colors/ansi.vim".source = ./ansi.vim;

  programs.neovim = {
    enable = true;
    vimAlias = true;

    extraConfig = ''
      " Use custom minimal ansi scheme
      colorscheme ansi

      " General options
      set hidden                     " No need to save a buffer before switching
      set path=**                    " Recursive search for files with find
      set scrollback=50000           " Lines to keep in terminal buffer
      set shortmess+=I               " Disable intro page
      set title                      " Set terminal title
      set wildmode=longest:full,full " Completion menu
      set completeopt-=preview       " Don’t show preview on completion

      " Recursive search with grep
      set grepprg=grep\ --exclude=tags\ --exclude-dir=.git\ -RIHn

      " Language specific indentation settings
      set shiftwidth=4 tabstop=4 expandtab
      autocmd FileType go   setlocal noexpandtab
      autocmd FileType html,json,nix,xml setlocal shiftwidth=2 tabstop=2

      " Formatter on save for specific languages
      autocmd BufWritePost *.elm silent execute "!${pkgs.elmPackages.elm-format}/bin/elm-format --yes " . expand('%')
      autocmd BufWritePost *.go  silent execute "!${pkgs.gotools}/bin/goimports -w " . expand('%') . " && ${config.programs.go.package}/bin/gofmt -w " . expand('%')
      autocmd BufWritePost *.nix silent execute "!${pkgs.nixfmt}/bin/nixfmt " . expand('%')
      autocmd BufWritePost *.zig silent execute "!${pkgs.zig}/bin/zig fmt " . expand('%')

      " Save with sudo
      command! W w !sudo tee % > /dev/null

      " Check which commit last modified current line
      command! Blame execute 'split | terminal git blame % -L ' . line('.') . ',+1'

      " Alternate buffer (C-Space is also C-@)
      nnoremap ga <C-^>

      " Exit insert for terminal
      tnoremap <Esc> <C-\><C-n>

      " Explorer settings
      let g:netrw_banner = 0           " Don’t show top banner
      let g:netrw_localrmdir = 'rm -r' " Let delete a non-empty directory

      " Trigger autoread when files changes on disk
      autocmd FocusGained,BufEnter * silent! checktime
      autocmd CursorHold,CursorHoldI * silent! checktime
      autocmd CursorMoved,CursorMovedI * silent! checktime " this one could be slow

      " Filter quicklist with the included cfilter plugin
      packadd cfilter

      " Disable default omnicompletion with C-c from sql
      let g:omni_sql_no_default_maps = 1
    '';

    extraPackages = with pkgs; [ gopls zls ];

    plugins = with pkgs.vimPlugins; [
      vim-nix
      {
        plugin = zig-vim;
        config = "let g:zig_fmt_autosave = 0";
      }

      {
        plugin = nvim-lspconfig;
        config = ''
          lua <<EOF
          local on_attach = function(client, bufnr)
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

            local bufopts = { noremap=true, silent=true, buffer=bufnr }
            if client.server_capabilities.definitionProvider then
              vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
            end
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
            vim.keymap.set('n', 'gR', vim.lsp.buf.rename, bufopts)
            vim.keymap.set('n', 'gh', vim.lsp.buf.hover, bufopts)
            vim.keymap.set('n', 'gs', vim.lsp.buf.document_symbol, bufopts)
            vim.keymap.set('n', 'gca', vim.lsp.buf.code_action, bufopts)
            vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)
          end

          for _, server in ipairs({ "gopls", "zls" }) do
            require('lspconfig')[server].setup { on_attach = on_attach }
          end
          EOF
        '';
      }
    ];
  };
}
