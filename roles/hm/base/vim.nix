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
      set cmdheight=0                " Hide command line
      set inccommand=split           " Show effect of substitute in split
      set laststatus=3               " Only show status line at the bottom
      set noruler                    " Disable ruler
      set noshowcmd                  " Hide pending keys messages
      set scrollback=50000           " Lines to keep in terminal buffer
      set shortmess+=I               " Disable intro page
      set title                      " Set terminal title
      set wildcharm=<c-z>            " Allow completion with <c-z> in macros
      set wildignore=ctags,.git/     " Ignore files and dirs in searches
      set wildmode=longest:full,full " Completion menu

      " Faster grep
      set grepprg=${pkgs.ripgrep}/bin/rg\ --vimgrep\ --no-heading
      set grepformat+=%f:%l:%c:%m

      " Don’t show shell output of grep and lgrep
      cabbrev <expr> grep (getcmdtype() == ':' && getcmdpos() == 5) ? "sil grep" : "grep"
      cabbrev <expr> lgrep (getcmdtype() == ':' && getcmdpos() == 6) ? "sil lgrep" : "lgrep"

      " Until https://github.com/neovim/neovim/issues/19193 is fixed
      autocmd RecordingEnter * set cmdheight=1
      autocmd RecordingLeave * set cmdheight=0

      " Language specific indentation settings
      set shiftwidth=4 tabstop=4 expandtab
      autocmd FileType go setlocal shiftwidth=8 tabstop=8 noexpandtab
      autocmd FileType html,json,nix,xml setlocal shiftwidth=2 tabstop=2

      " Make programs
      autocmd Filetype go set makeprg=go\ build
      autocmd Filetype zig set makeprg=zig\ build

      " Save with sudo
      command! W w !sudo tee % > /dev/null

      " Git blame current line
      command! Blame execute '2split | terminal git --no-pager blame % -L ' . line('.') . ',+1'

      " Quickly edit file with completion
      command! -nargs=1 -bang -complete=custom,s:files Edit edit<bang> <args>
      function! s:files(A, L, P)
        return system("${pkgs.ripgrep}/bin/rg --files")
      endfunction

      " Mapping to open file
      nnoremap <c-p> :Edit<space><c-z>

      " Alternate buffer
      nnoremap ga <c-^>

      " Exit insert for terminal
      tnoremap <esc> <c-\><c-n>

      " Filter quicklist with the included cfilter plugin
      packadd cfilter

      " Explorer settings
      let g:netrw_banner = 0           " Don’t show top banner
      let g:netrw_localrmdir = 'rm -r' " Let delete a non-empty directory

      " Trigger autoread when files changes on disk
      autocmd FocusGained,BufEnter * silent! checktime
      autocmd CursorHold,CursorHoldI * silent! checktime
      autocmd CursorMoved,CursorMovedI * silent! checktime " this one could be slow

      " Define simple statusline and keep it for quickfix
      set statusline=%=%.36t:%l
      let g:qf_disable_statusline = 1

      " Push the statusline to tmux
      if has_key(environ(), 'TMUX')
        set laststatus=0
        " see https://github.com/neovim/neovim/issues/18965#issuecomment-1155808469
        set statusline=%{repeat('─',winwidth('.'))}
        hi! link StatusLineNC StatusLine

        let Statusline = { -> trim(nvim_eval_statusline("%=%.36t:%l", {'fillchar': ' '}).str) }
        autocmd BufEnter,FocusGained,CursorMoved * call system('tmux set status-right "' . Statusline() . '"')
        autocmd VimLeave,VimSuspend,FocusLost * call system('tmux set status-right ""')
      endif

      " Try to include local config
      if filereadable(expand("~/.vimrc.local"))
        source ~/.vimrc.local
      endif

      lua <<EOF
      servers = {
        go = {'${pkgs.gopls}/bin/gopls'},
        nix = {'${pkgs.rnix-lsp}/bin/rnix-lsp'},
        php = {'${pkgs.nodePackages.intelephense}/bin/intelephense', '--stdio'},
        zig = {'${pkgs.zls}/bin/zls'},
      }

      for pat, cmd in pairs(servers) do
        vim.api.nvim_create_autocmd('FileType', {
          pattern = pat,
          callback = function()
            vim.lsp.start({
              cmd = cmd,
              root_dir = vim.fn.getcwd(),
            })
          end
        })
      end

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local bufopts = { noremap = true, silent = true, buffer = args.buf }
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
          vim.keymap.set('n', 'gR', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', 'gca', vim.lsp.buf.code_action, bufopts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
          vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)

          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
              callback = function()
                vim.lsp.buf.format()
              end,
            })
          end
        end
      })
      EOF
    '';

    plugins = with pkgs.vimPlugins; [
      # Syntax for zig and nix were added recently in vim and neovim
      # https://github.com/neovim/neovim/commit/35767769036671d5ce562f53cae574f9c66e4bb2
      # Waiting for the next version of neovim to have it in nixpkgs because only in master so far.
      vim-nix
      {
        plugin = zig-vim;
        config = "let g:zig_fmt_autosave = 0";
      }
    ];
  };
}
