{ pkgs, ... }:

{
  # Colorscheme
  xdg.configFile."nvim/colors/ansi.vim".source = ./ansi.vim;

  # Zig ctags support
  xdg.configFile."ctags/zig.ctags".text = ''
    --langdef=Zig
    --langmap=Zig:.zig
    --regex-Zig=/fn +([a-zA-Z0-9_]+) *\(/\1/f,functions,function definitions/
    --regex-Zig=/(var|const) *([a-zA-Z0-9_]+) *= *(extern|packed)? *struct/\2/s,structs,struct definitions/
    --regex-Zig=/(var|const) *([a-zA-Z0-9_]+) *= *(extern|packed)? *enum/\2/e,enums,enum definitions/
    --regex-Zig=/(var|const) *([a-zA-Z0-9_]+) *= *(extern|packed)? *union/\2/u,unions,union definitions/
    --regex-Zig=/(var|const) *([a-zA-Z0-9_]+) *= *error/\2/E,errors,error definitions/
  '';

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

      " Formatter on save for specific languages
      autocmd BufWritePost *.elm silent execute "!elm-format --yes " . expand('%')
      autocmd BufWritePost *.go  silent execute "!gofmt -w " . expand('%')
      autocmd BufWritePost *.zig silent execute "!zig fmt " . expand('%')

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

    plugins = with pkgs.vimPlugins; [ vim-nix { plugin = zig-vim; config = "let g:zig_fmt_autosave = 0"; } ];
  };
}
