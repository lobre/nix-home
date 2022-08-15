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
      zls # zig lsp
    ];

    plugins = with pkgs.vimPlugins; [
      emmet-vim
      vim-nix
      fzfWrapper # https://github.com/junegunn/fzf/blob/master/README-VIM.md

      {
        plugin = zig-vim;
        config = ''
          let g:zig_fmt_autosave = 0
        '';
      }

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

            -- if no go to definition, preserve go to tag
            if client.resolved_capabilities.goto_definition then
              map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
            end

            map('n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
            map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
            map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
            map('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
            map('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
            map('n', 'gs', '<cmd>lua vim.lsp.buf.document_symbol()<cr>', opts)
            map('n', 'gca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
            map('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)

            -- Commands
            vim.cmd("command! LspFormat lua vim.lsp.buf.formatting()")
            vim.cmd("command! LspDiag lua vim.diagnostic.setloclist()")
            vim.cmd("command! Dnext lua vim.diagnostic.goto_next()")
            vim.cmd("command! Dprev lua vim.diagnostic.goto_prev()")

            -- Format files on save
            vim.api.nvim_exec([[
              autocmd BufWritePre *.elm,*.go,*.zig lua vim.lsp.buf.formatting_sync(nil, 1000)
            ]], false)
          end

          -- Configure servers
          local servers = { "elmls", "gopls", "intelephense", "tailwindcss", "zls" }

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

      " Check which commit last modified current line
      command! Blame execute 'terminal git --no-pager show $(git blame % -L ' . line('.') . ',+1 |' . "awk '{print $1}')" . ' -- $(git blame % -L ' . line('.') . ',+1 |' . "awk '{print $2}')"

      " Command for fzf window
      command! -bang -complete=dir -nargs=? Files call fzf#run(fzf#wrap({
        \   'source': 'fd --type file',
        \   'options': [
        \     '--multi', '--preview', 'cat {}',
        \     '--bind', 'ctrl-h:reload(fd --type file --no-ignore-vcs --hidden)'
        \    ],
        \   'dir': <q-args>
        \ }, <bang>0))

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
      tnoremap <C-c> <C-\><C-n>

      " Send SIGINT in terminal normal mode with C-c (as remapped to exit in insert mode)
      autocmd TermOpen * nnoremap <buffer> <C-c> i<C-c>

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
    '';
  };
}
