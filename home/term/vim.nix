{ config, pkgs, lib, ... }:

{
  programs.vim = {
    enable = true;

    plugins = [ pkgs.vimPlugins.vim-go ];

    extraConfig = ''
      set nowritebackup
      set noswapfile

      " Explorer settings
      let g:netrw_liststyle=3
      let g:netrw_winsize = 25
      let g:netrw_localrmdir='rm -r'

      " Search with rg if available
      if executable('rg')
          set grepprg=rg\ --vimgrep\ --no-heading
          set grepformat=%f:%l:%c:%m,%f:%l:%m
      endif

      set dir=/tmp
      set backupdir=/tmp

      set scrolloff=3    " 3 lines displayed around cursor for scroll

      " No delay when exiting visual mode
      set timeoutlen=1000 ttimeoutlen=0

      set showbreak=↪\
      set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨

      set ignorecase     " Case insensitive
      set wildignorecase " Autocomplete case insensitive
      set smartcase      " Enable case sensitivity if search contains upper letter
      set hidden         " Enable caching on buffer switch

      " Autocompletion
      set wildmenu
      set wildmode=list:longest,full

      set background=dark

      set novisualbell   " Prevent bell
      set noerrorbells   " Prevent bell

      " Default tabs count parameters
      set tabstop=2
      set shiftwidth=2
      set expandtab

      " Split on the right
      set splitright
      set splitbelow

      " Enable file types and indents
      filetype on
      filetype plugin on
      filetype indent on
      set autoindent
      set smartindent

      " Improve completion
      set completeopt=longest,menuone

      " Enable syntax color
      syntax on

      " Common behavior for backspace
      set backspace=indent,eol,start

      " Disable modifyOtherKeys because xfce-terminal
      " sets TERM to xterm and that causes problems
      set t_TI= t_TE=

      " Save with sudo
      command! W w !sudo tee % > /dev/null

      " Reset some colors
      highlight SignColumn ctermbg=none
      highlight Error ctermbg=none ctermfg=red
      highlight Todo ctermbg=none ctermfg=red
      highlight Pmenu ctermbg=white
      highlight PmenuSel ctermbg=gray ctermfg=black
      highlight TabLineFill cterm=bold,reverse
      highlight TabLineSel cterm=bold,reverse
      highlight TabLine ctermbg=none ctermfg=none cterm=reverse

      " Autoread file if changes
      set autoread
      set updatetime=500

      " Vim-go settings
      let g:go_fmt_command = "goimports"

      if has("autocmd")
          " Trigger autoread when files changes on disk
          autocmd FocusGained, BufEnter, CursorHold, CursorHoldI * if mode() != 'c' | checktime | endif
          autocmd FileChangedShellPost *
            \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

          " Language specific indentation settings
          autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4
          autocmd FileType sh setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
      endif
    '';
  };
}
