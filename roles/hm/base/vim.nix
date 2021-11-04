{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;

    # Extra packages available to nvim.
    # Useful to install LSP servers.
    extraPackages = with pkgs; [ 
      gopls # go language server
      nodePackages.vscode-json-languageserver
      nodePackages.yaml-language-server
      zls # zig language server
    ];

    plugins = with pkgs.vimPlugins; [
      vim-nix
      zig-vim
      vim-commentary
      emmet-vim

      plenary-nvim # dep of telescope
      popup-nvim   # dep of telescope
      telescope-fzf-native-nvim # fastest sorter for telescope
      nvim-web-devicons # icons for telescope (needs nerd patched font)
      {
        plugin = telescope-nvim;
        config = ''
          lua <<EOF
          local actions = require('telescope.actions')
          require('telescope').setup {
            defaults = require('telescope.themes').get_ivy {
              mappings = {
                i = {
                  ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                  ["<esc>"] = actions.close,
                },
                n = {
                  ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                },
              }
            }
          }

          require('telescope').load_extension('fzf')
          EOF

          command! -nargs=? Find lua require'telescope.builtin'.find_files{
            \ default_text = vim.fn.expand("<args>")
          \ }<cr>

          command! -nargs=? FindAll lua require'telescope.builtin'.find_files{
            \ default_text = vim.fn.expand("<args>"),
            \ find_command = {
              \ "rg",
              \ "--files",
              \ "--no-ignore-vcs",
              \ "--hidden",
              \ "--glob", "!.git"
            \}
          \ }<cr>

          command! -nargs=? Grep lua require'telescope.builtin'.live_grep{
            \ default_text = vim.fn.expand("<args>")
          \ }<cr>

          command! -nargs=? GrepAll lua require'telescope.builtin'.live_grep{
            \ default_text = vim.fn.expand("<args>"),
            \ vimgrep_arguments = {
              \ "rg",
              \ "--color=never",
              \ "--no-heading",
              \ "--with-filename",
              \ "--line-number",
              \ "--column",
              \ "--smart-case",
              \ "--no-ignore-vcs",
              \ "--hidden",
              \ "--glob", "!.git"
            \}
          \}<cr>

          command! -nargs=? Tags lua require'telescope.builtin'.tags{ default_text = vim.fn.expand("<args>") }<cr>
          command! -nargs=? Quickfix lua require'telescope.builtin'.quickfix{ default_text = vim.fn.expand("<args>") }<cr>
          command! -nargs=? Help lua require'telescope.builtin'.help_tags{ default_text = vim.fn.expand("<args>") }<cr>
          command! -nargs=? History lua require'telescope.builtin'.command_history{ default_text = vim.fn.expand("<args>") }<cr>

          command! GitHistory Telescope git_bcommits

          " Keybindings
          nnoremap <C-p> <cmd>Find<cr>
          nnoremap <C-b> <cmd>Telescope buffers<cr>
          nnoremap <C-f> <cmd>Grep<cr>
          nnoremap g<C-p> <cmd>FindAll<cr>
          nnoremap g<C-f> <cmd>GrepAll<cr>
          nnoremap g<C-r> <cmd>History<cr>
          nnoremap g<C-q> <cmd>Quickfix<cr>
        '';
      }

      cmp-nvim-lsp
      cmp-buffer
      {
        plugin = nvim-cmp;
        config = ''
          lua <<EOF
          local cmp = require('cmp')

          cmp.setup({
            sources = {
              { name = 'nvim_lsp' },
              { name = 'buffer' }
            },
            preselect = cmp.PreselectMode.None;
          })
          EOF
        '';
      }

      {
        plugin = lsp_signature-nvim;
        config = ''
          lua <<EOF
            require('lsp_signature').setup({
              doc_lines = 0,
              hint_enable = false
            })
          EOF
        '';
      }

      { 
        plugin = nvim-lspconfig;
        config = ''
          lua <<EOF
          local lspconfig = require('lspconfig')

          local on_attach = function(client, bufnr)
            require('lsp_signature').on_attach()

            local function map(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
            local function opt(...) vim.api.nvim_buf_set_option(bufnr, ...) end

            -- Mappings
            local opts = { noremap=true, silent=true }
            map('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', opts)
            map('n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
            map('n', 'gi', '<cmd>Telescope lsp_implementations<cr>', opts)
            map('n', 'gr', '<cmd>Telescope lsp_references<cr>', opts)
            map('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
            map('n', 'gh', '<Cmd>lua vim.lsp.buf.hover()<cr>', opts)
            map('n', 'gs', '<cmd>Telescope lsp_document_symbols<cr>', opts)
            map('n', 'gS', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', opts)
            map('n', 'ga', '<cmd>Telescope lsp_code_actions<cr>', opts)

            -- Commands
            vim.cmd("command! LspFormat lua vim.lsp.buf.formatting()")
            vim.cmd("command! Dnext lua vim.lsp.diagnostic.goto_next()")
            vim.cmd("command! Dprev lua vim.lsp.diagnostic.goto_prev()")

            -- Format go files on save
            vim.api.nvim_exec([[
              autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)
            ]], false)
          end

          -- Configure servers
          local servers = { "gopls", "jsonls", "yamlls", "zls" }
          for _, server in ipairs(servers) do
            lspconfig[server].setup { 
              on_attach = on_attach,
              capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
            }
          end
          EOF
        '';
      }

      { 
        plugin = nvim-treesitter;
        config = ''
          lua <<EOF
          require'nvim-treesitter.configs'.setup {
            highlight = {
              enable = true
            },
            indent = {
              enable = true
            }
          }
          EOF
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

      " Save with sudo
      command! W w !sudo tee % > /dev/null

      " Clear current highlighted search
      nnoremap <C-l> <cmd>nohlsearch<cr>

      " Jump to tag
      nnoremap gd <C-]>

      " Split as expected
      set splitright
      set splitbelow

      " Explorer settings
      let g:netrw_liststyle = 3        " show as tree (refresh has a bug https://github.com/vim/vim/issues/5964)
      let g:netrw_winsize = 20         " size of window
      let g:netrw_localrmdir = 'rm -r' " let delete a non-empty directory
      let g:netrw_banner = 0           " don’t show top banner
      let g:netrw_browse_split = 4     " always open files in previous window
      let g:netrw_preview = 1          " enable vertical preview with p
      let g:netrw_alto = 0             " split preview on the right

      " Trigger autoread when files changes on disk
      autocmd FocusGained,BufEnter * silent! checktime
      autocmd CursorHold,CursorHoldI * silent! checktime
      autocmd CursorMoved,CursorMovedI * silent! checktime " this one could be slow

      " Load cfilter to filter quickfix (bundled with nvim)
      packadd cfilter

      " Alternate buffer
      nnoremap <C-a> <C-^>

      " Simple git blame
      command! Blame execute "!git blame -c --date=short -L " . line(".") . ",+1 %"

      " Toggle terminal
      nnoremap g<C-t> <cmd>call ToggleTerm()<cr>
      tnoremap g<C-t> <cmd>call ToggleTerm()<cr>
       
      function! ToggleTerm()
        let name = "term://default"
        let win = bufwinnr(name)
        let lastwin = winnr('$')
        let buf = bufexists(name)
        if win > 0
          if lastwin == 1 && lastwin == win
            let s:termheight = -1
            buffer #
          else
            let s:termheight = winheight(win)
            execute win . "wincmd c"
          endif
        elseif buf > 0
          if s:termheight == -1
            execute "buffer " . name
          else
            execute s:termheight . "split | buffer " . name
          endif
        else
          let s:termheight = 5
          execute s:termheight . "split | terminal"
          execute "keepalt file " . name
          set nobuflisted
        endif
      endfunction

      " Terminal navigation
      tnoremap <C-w>o <cmd>only<cr>
      tnoremap <C-w>h <C-\><C-N><C-w>h
      tnoremap <C-w>j <C-\><C-N><C-w>j
      tnoremap <C-w>k <C-\><C-N><C-w>k
      tnoremap <C-w>l <C-\><C-N><C-w>l
      tnoremap <C-w><C-w> <C-\><C-N><C-w><C-w>

      " Terminal stays in insert mode
      " See https://github.com/neovim/neovim/issues/9483
      autocmd TermOpen,BufWinEnter,WinEnter term://* startinsert
      autocmd TermOpen * nnoremap <buffer><LeftRelease> <LeftRelease>i

      " Exit terminal with Esc
      tnoremap <Esc> <C-\><C-n>
    '';
  };

  # Colorscheme
  xdg.configFile."nvim/colors/ansi.vim".source = ./ansi.vim;
}
