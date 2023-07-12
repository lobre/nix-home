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

    plugins = with pkgs.vimPlugins; [ vim-noctu ];

    extraConfig = ''
      colorscheme noctu

      " General options
      set completeopt=menu,menuone,noselect  " Don't select first entry in autocomplete and disable preview
      set inccommand=split                   " Show effect of substitute in split
      set noruler                            " Disable ruler
      set noshowcmd                          " Hide pending keys messages
      set scrollback=50000                   " Lines to keep in terminal buffer
      set shortmess+=I                       " Disable intro page
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

      " Move and indent line in visual mode
      vnoremap J :m '>+1<cr>gv=gv
      vnoremap K :m '<-2<cr>gv=gv
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

      " Autocompletion on dot
      inoremap <expr> . empty(&omnifunc) ? '.' : '.<c-x><c-o>'

      " Quickly switch to file at mark
      nnoremap <expr> <space> "<cmd>call JumpToFile('" . toupper(getcharstr()) . "')<cr>"

      " Jump to mark at last known position
      function! JumpToFile(mark)
        let l:file = nvim_get_mark(a:mark, {})[3]
        if expand(l:file) != expand('%:p')
          execute "normal! `" . a:mark . "`\"zz"
        endif
      endfunction

      " Filter quicklist with the included cfilter plugin
      packadd cfilter

      " Explorer settings
      let g:netrw_banner = 0           " Don’t show top banner
      let g:netrw_localrmdir = 'rm -r' " Let delete a non-empty directory

      " Trigger autoread when files changes on disk
      autocmd FocusGained,BufEnter * silent! checktime
      autocmd CursorHold,CursorHoldI * silent! checktime
      autocmd CursorMoved,CursorMovedI * silent! checktime " this one could be slow

      " html skeleton
      autocmd BufNewFile index.html 0read ${htmlSkeleton}

      " Quickly edit git file with completion
      command! -nargs=1 -bang -complete=custom,s:git_files E edit<bang> <args>
      function! s:git_files(A, L, P)
        return system("git ls-files --recurse-submodules 2>/dev/null")
      endfunction

      " Blame current line and show info inline in virtual text
      command! -nargs=0 Blame call Blame()
      function! Blame()
        let l:ns = nvim_create_namespace("blame")
        let l:line_marks = nvim_buf_get_extmarks(0, l:ns, [line('.')-1, 0], [line('.')-1, 0], {})
        call nvim_buf_clear_namespace(0, l:ns, 0, -1)
        if empty(l:line_marks)
          let l:format = " --pretty='%h %an, %ad • %s' --date=human"
          let l:msg = trim(system("git --no-pager log -s -1 -L " . line('.') . ",+1:" . expand('%') . l:format))
          call nvim_buf_set_extmark(0, l:ns, line('.')-1, 0, {'virt_text': [[ '   ' . l:msg, 'Comment' ]]})
        endif
      endfunction

      " Go back to prev position when opening file. See :h restore-cursor
      autocmd BufRead * autocmd FileType <buffer> ++once
        \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif

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
          local bufnr = args.buf
          local bufopts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
          vim.keymap.set('n', 'gR', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', 'gca', vim.lsp.buf.code_action, bufopts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
          vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)

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
  };
}
