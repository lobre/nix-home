{ pkgs, lib, ... }:

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
      set mouse=a           " Enable mouse mode
      set scrollback=50000  " Lines to keep in terminal buffer

      " Completion menu
      set completeopt=menuone,noinsert,noselect  " don’t select first in completion
      set wildmode=longest:full,full

      " Mininal clutter on the interface
      set laststatus=1  " Status line only if there are two windows
      set noruler
      set noshowcmd
      set noshowmode
      set shortmess+=I  " Disable intro page

      " Default tabs count parameters
      set expandtab
      set shiftwidth=4
      set tabstop=4

      " Language specific indentation settings
      autocmd FileType go   setlocal noexpandtab
      autocmd FileType html setlocal shiftwidth=2 tabstop=2
      autocmd FileType json setlocal shiftwidth=2 tabstop=2

      " Use git grep
      set grepprg=git\ -c\ grep.fallbackToNoIndex\ --no-pager\ grep\ --no-color\ -nI
      set grepformat=%f:%l:%c:%m,%f:%l:%m,%f

      " Save with sudo
      command! W w !sudo tee % > /dev/null

      " Check which commit last modified current line
      command! Blame execute 'split | terminal git blame % -L ' . line('.') . ',+1'

      " C-c does not trigger events like Esc
      inoremap <C-c> <Esc>

      " Alternate buffer (C-Space is also C-@)
      nnoremap <C-Space> <C-^>

      " Jump to tag
      nnoremap gd <C-]>

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
    '';
  };
}
