{ pkgs, lib, ... }:

{
  # Colorscheme
  xdg.configFile."nvim/colors/ansi.vim".source = ./ansi.vim;

  programs.neovim = {
    enable = true;
    vimAlias = true;

    # LSP servers to make available to nvim
    extraPackages = with pkgs; [ 
      gopls # go lsp
      elmPackages.elm-language-server # elm lsp
      nodePackages."@tailwindcss/language-server" # tailwind lsp
      nodePackages.intelephense # php lsp
      nodePackages.vscode-langservers-extracted # html, css, json lsp
      nodePackages.yaml-language-server
      rust-analyzer # rust lsp (better than rls)
      zls # zig lsp
    ];

    plugins = with pkgs.vimPlugins; [
      emmet-vim
      vim-nix
      zig-vim

      { 
        plugin = nvim-lspconfig;
        config = ''
          lua <<EOF
          local lspconfig = require('lspconfig')

          local on_attach = function(client, bufnr)
            local function map(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
            local function opt(...) vim.api.nvim_buf_set_option(bufnr, ...) end

            opt('omnifunc', 'v:lua.vim.lsp.omnifunc')

            -- Mappings
            local opts = { noremap=true, silent=true }
            map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
            map('n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
            map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
            map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
            map('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
            map('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
            map('n', 'gs', '<cmd>lua vim.lsp.buf.document_symbol()<cr>', opts)
            map('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
            map('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)

            -- Commands
            vim.cmd("command! LspFormat lua vim.lsp.buf.formatting()")
            vim.cmd("command! LspDiag lua vim.diagnostic.setloclist()")
            vim.cmd("command! Dnext lua vim.diagnostic.goto_next()")
            vim.cmd("command! Dprev lua vim.diagnostic.goto_prev()")

            -- Format files on save
            vim.api.nvim_exec([[
              autocmd BufWritePre *.elm,*.go,*.rs,*.zig lua vim.lsp.buf.formatting_sync(nil, 1000)
            ]], false)
          end

          -- Configure servers
          local servers = {
            "cssls",
            "elmls",
            "gopls",
            "html",
            "intelephense",
            "jsonls",
            "rust_analyzer",
            "tailwindcss",
            "yamlls",
            "zls"
          }

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
          require('nvim-treesitter.configs').setup {
            highlight = { enable = true },
            indent = { enable = true }
          }
          EOF
        '';
      }

      {
        plugin = copilot-vim;
        config = ''
          let g:copilot_enabled = 0
          let g:copilot_no_tab_map = 1
          imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
        '';
      }
    ];

    extraConfig = ''
      " Use custom minimal ansi scheme
      colorscheme ansi

      " General options
      set hidden            " No need to save a buffer before switching
      set ignorecase        " Case insensitive
      set mouse=a           " Enable mouse mode
      set scrollback=50000  " Lines to keep in terminal buffer
      set smartcase         " Enable case sensitivity if search contains upper letter
      set title             " Update the title of the window 
      set wildignorecase    " Autocomplete case insensitive
      set showmatch         " Highlight matching parenthesis or bracket

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

      " Search with rg if available
      if executable('rg')
          set grepprg=rg\ --vimgrep\ --no-heading
          set grepformat=%f:%l:%c:%m,%f:%l:%m
      endif

      " Open quickfix upon search
      command! -nargs=+ -complete=file Grep execute 'silent grep!' <q-args> | cwindow | redraw!
      cnoreabbrev grep Grep

      " Open location list upon search
      command! -nargs=+ -complete=file LGrep execute 'silent lgrep!' <q-args> | lwindow | redraw!
      cnoreabbrev lgrep LGrep

      " Save with sudo
      command! W w !sudo tee % > /dev/null

      " Simple git blame for current line
      command! Blame execute '!git blame -c --date=short -L ' . line('.') . ',+1 %'

      " Command for fzf window
      command! Files call FZF()

      " Open fzf window
      nnoremap <C-p> <cmd>Files<cr>

      " C-c does not trigger events like Esc
      inoremap <C-c> <Esc>

      " Clear current highlighted search
      nnoremap <C-l> <cmd>nohlsearch<cr>

      " Alternate buffer (C-Space is also C-@)
      nnoremap <C-Space> <C-^>

      " Jump to tag
      nnoremap gd <C-]>

      " Exit insert for terminal
      tnoremap <Esc> <C-\><C-n>
      tnoremap <expr> <C-c> stridx(bufname('%'), "term://") == 0 ? "<C-\><C-n>" : "<C-c>"

      " Send SIGINT in terminal normal mode with C-c (as remapped to exit in insert mode)
      autocmd TermOpen * nnoremap <buffer> <C-c> i<C-c>

      " Make C-n/C-p act as Up/Down by completing command
      cnoremap <expr> <C-p> wildmenumode() ? "<C-p>" : "<Up>"
      cnoremap <expr> <C-n> wildmenumode() ? "<C-n>" : "<Down>"

      " Explorer settings
      let g:netrw_banner = 0           " Don’t show top banner
      let g:netrw_liststyle = 3        " Show as tree (refresh has a bug https://github.com/vim/vim/issues/5964)
      let g:netrw_localrmdir = 'rm -r' " Let delete a non-empty directory

      " Trigger autoread when files changes on disk
      autocmd FocusGained,BufEnter * silent! checktime
      autocmd CursorHold,CursorHoldI * silent! checktime
      autocmd CursorMoved,CursorMovedI * silent! checktime " this one could be slow

      " Filter quicklist with the included cfilter plugin
      packadd cfilter

      " Interactive fuzzy finder using external fzf
      function! FZF()
          if !has('nvim')
              echo 'error: fzf only working in neovim'
              return
          endif

          let l:tmpfile = tempname()
          let l:opts = { 'tmpfile': l:tmpfile, 'prevbuf': bufnr('%') }

          function! l:opts.on_exit(id, code, event)
              let l:termbuf = bufnr('%')

              if l:termbuf == self.prevbuf
                  keepalt enew
              else
                  execute 'keepalt buffer ' . self.prevbuf
              endif

              execute 'keepalt bdelete! ' . l:termbuf

              let l:nblines = system('cat ' . self.tmpfile . ' | wc -l')
              if l:nblines == 1
                  let l:file = system('head -n1 ' . self.tmpfile)
                  execute 'edit ' . l:file
              elseif l:nblines > 1
                  call system('sed -i "s/$/:1:0/" ' . self.tmpfile)
                  execute 'silent cfile ' . self.tmpfile
              endif

              call delete(self.tmpfile)
              redraw!
          endfunction

          let l:cmd = 'fzf --multi
              \ --preview "bat --color=always --style=plain {}"
              \ --bind "ctrl-h:reload($FZF_DEFAULT_COMMAND --no-ignore-vcs --hidden)"
              \ > ' . fnameescape(l:tmpfile)

          keepalt enew
          call termopen(l:cmd, l:opts) | startinsert
          execute 'keepalt file FZF ' . bufnr('%')
      endfunction
    '';
  };
}
