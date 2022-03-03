{ pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;

    # Extra packages available to nvim.
    # Useful to install LSP servers.
    extraPackages = with pkgs; [ 
      gopls # go lsp
      elmPackages.elm-language-server # elm lsp
      nodePackages."@tailwindcss/language-server" # tailwind lsp
      nodePackages.intelephense # php lsp
      nodePackages.typescript-language-server # typescript lsp
      nodePackages.vscode-langservers-extracted # html, css, json, eslint lsp
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
            "eslint",
            "gopls",
            "html",
            "intelephense",
            "jsonls",
            "rust_analyzer",
            "tailwindcss",
            "tsserver",
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

      " Open quickfix upon search
      command! -nargs=+ -complete=file Grep execute 'silent grep!' <q-args> | cw | redraw!
      cnoreabbrev grep Grep

      " Command to quickly make a search
      nnoremap <C-f> :Grep<space>

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
      let g:netrw_banner = 0           " don’t show top banner
      let g:netrw_liststyle = 3        " show as tree (refresh has a bug https://github.com/vim/vim/issues/5964)
      let g:netrw_localrmdir = 'rm -r' " let delete a non-empty directory

      " Quickly toggle explorer
      nnoremap <expr> <C-n> "<cmd>" . (exists("w:netrw_rexlocal") ? "Rexplore" : "Explore") . "<cr>"

      " Trigger autoread when files changes on disk
      autocmd FocusGained,BufEnter * silent! checktime
      autocmd CursorHold,CursorHoldI * silent! checktime
      autocmd CursorMoved,CursorMovedI * silent! checktime " this one could be slow

      " Allow modifications to quickfix
      packadd cfilter
      autocmd BufReadPost quickfix set modifiable
      autocmd filetype qf setlocal errorformat+=%f\|%l\ col\ %c\|%m
      command! Cupdate cgetbuffer | cclose | copen

      " Simple git blame
      command! Blame execute '!git blame -c --date=short -L ' . line('.') . ',+1 %'

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

      " Interactive fuzzy finder using external fzf
      function! FZF()
          if has('nvim')
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

              keepalt enew
              call termopen('fzf --multi --preview "bat --color=always --style=plain {}" > ' . fnameescape(l:tmpfile), l:opts)
              keepalt file FZF
          else
              echo 'error: fzf only working in neovim'
          endif
      endfunction

      " Map fzf function
      command! Files call FZF()
      nnoremap <C-p> <cmd>Files<cr>
    '';
  };

  # Colorscheme
  xdg.configFile."nvim/colors/ansi.vim".source = ./ansi.vim;
}
