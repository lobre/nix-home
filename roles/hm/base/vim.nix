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
      set hidden            " No need to save a buffer before switching
      set scrollback=50000  " Lines to keep in terminal buffer
      set shortmess+=I      " Disable intro page
      set title             " Set terminal title

      " Sane grep arguments
      set grepprg=grep\ --exclude=tags\ -RIHn

      " Completion menu
      set wildmode=longest:full,full

      " Default tabs count parameters
      set expandtab
      set shiftwidth=4
      set tabstop=4

      " Language specific indentation settings
      autocmd FileType go   setlocal noexpandtab
      autocmd FileType html,json,nix setlocal shiftwidth=2 tabstop=2

      " Formatter on save for specific languages
      autocmd BufWritePost *.elm silent execute "!${pkgs.elmPackages.elm-format}/bin/elm-format --yes " . expand('%')
      autocmd BufWritePost *.go  silent execute "!${pkgs.gotools}/bin/goimports -w " . expand('%') . " && ${config.programs.go.package}/bin/gofmt -w " . expand('%')
      autocmd BufWritePost *.nix silent execute "!${pkgs.nixfmt}/bin/nixfmt " . expand('%')
      autocmd BufWritePost *.zig silent execute "!${pkgs.zig}/bin/zig fmt " . expand('%')

      " Save with sudo
      command! W w !sudo tee % > /dev/null

      " Check which commit last modified current line
      command! Blame execute 'split | terminal git blame % -L ' . line('.') . ',+1'

      " C-c does not trigger events like Esc
      inoremap <C-c> <Esc>

      " Alternate buffer (C-Space is also C-@)
      nnoremap <C-Space> <C-^>

      " Exit insert for terminal
      tnoremap <Esc> <C-\><C-n>
      tnoremap <C-c> <C-\><C-n>

      " Send SIGINT in terminal normal mode with C-c (as remapped to exit in insert mode)
      autocmd TermOpen * nnoremap <buffer> <C-c> i<C-c>

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

    plugins = with pkgs.vimPlugins; [
      vim-nix
      {
        plugin = zig-vim;
        config = "let g:zig_fmt_autosave = 0";
      }
    ];
  };
}
