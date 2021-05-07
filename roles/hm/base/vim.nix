{ pkgs, ... }:

{
  # Use an overlay to install nvim 0.5 until it is officially shipped with nix.
  # It brings pkgs.neovim-nightly in scope.
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;

    viAlias = true;
    vimAlias = true;

    # Extra packages available to nvim.
    # Useful to install LSP servers.
    extraPackages = with pkgs; [ 
      gopls # go language server
      nodePackages.bash-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.vim-language-server
      nodePackages.vscode-css-languageserver-bin
      nodePackages.vscode-html-languageserver-bin
      nodePackages.vscode-json-languageserver
      nodePackages.yaml-language-server
      rnix-lsp # nix language server
      zls # zig language server
    ];

    plugins = with pkgs.vimPlugins; [
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

            -- Mappings.
            local opts = { noremap=true, silent=true }
            map('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
            map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
            map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
            map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
            map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
            map('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
            map('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
            map('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
            map('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
            map('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
            map('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
            map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
            map('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
            map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
            map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
            map('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

            -- Set some keybinds conditional on server capabilities
            if client.resolved_capabilities.document_formatting then
              map("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
            end
            if client.resolved_capabilities.document_range_formatting then
              map("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
            end

            -- Set autocommands conditional on server_capabilities
            if client.resolved_capabilities.document_highlight then
              vim.api.nvim_exec([[
                hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
                hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
                hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
                augroup lsp_document_highlight
                  autocmd! * <buffer>
                  autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                  autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                augroup END
              ]], false)
            end
          end

          -- Configure servers
          local servers = { "gopls", "bashls", "dockerls", "vimls", "cssls", "html", "jsonls", "yamlls", "rnix", "zls" }
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
          require'nvim-treesitter.configs'.setup {
            highlight = {
              enable = true
            }
          }
          EOF
        '';
      }
    ];

    extraConfig = ''
      set showbreak=↪\
      set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨

      set ignorecase     " Case insensitive
      set wildignorecase " Autocomplete case insensitive
      set smartcase      " Enable case sensitivity if search contains upper letter
      set hidden         " No need to save a buffer before switching
      set smartindent    " Smart autoindenting when starting new line
      set title          " Update the title of the window 
      set mouse=a        " Enable mouse mode

      " Don’t automatically select first item in completion
      set completeopt=menuone,noinsert,noselect

      " Split as expected
      set splitright
      set splitbelow

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

      " Exit terminal with Esc
      tnoremap <Esc> <C-\><C-n>

      " Explorer settings
      let g:netrw_liststyle=3
      let g:netrw_winsize = 25
      let g:netrw_localrmdir='rm -r'

      " Trigger autoread when files changes on disk
      autocmd FocusGained * checktime

      " Simpler colors for some parts of the interface
      highlight SignColumn ctermbg=none
      highlight Error ctermbg=none ctermfg=red
      highlight Todo ctermbg=none ctermfg=red
      highlight Pmenu ctermbg=white
      highlight PmenuSel ctermbg=gray ctermfg=black
      highlight TabLineFill cterm=bold
      highlight TabLineSel cterm=bold
      highlight TabLine ctermbg=none ctermfg=none cterm=none
    '';
  };
}
