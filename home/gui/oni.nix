{ config, pkgs, ... }:

{
  xdg.configFile."oni2/configuration.json".text = ''
    {
      "workbench.colorTheme": "One Dark Pro",
      "editor.detectIndentation": true,
      "editor.fontFamily": "FiraCode-Regular.ttf",
      "editor.fontSize": 14,
      "editor.largeFileOptimizations": true,
      "editor.highlightActiveIndentGuide": true,
      "editor.indentSize": 4,
      "editor.insertSpaces": false,
      "editor.lineNumbers": "on",
      "editor.matchBrackets": true,
      "editor.minimap.enabled": true,
      "editor.minimap.maxColumn": 120,
      "editor.minimap.showSlider": true,
      "editor.renderIndentGuides": true,
      "editor.renderWhitespace": "all",
      "editor.rulers": [],
      "editor.tabSize": 4,
      "editor.zenMode.hideTabs": true,
      "editor.zenMode.singleFile": true,
      "files.exclude": [ "_esy", "node_modules" ],
      "workbench.activityBar.visible": true,
      "workbench.editor.showTabs": true,
      "workbench.iconTheme": "vs-seti",
      "workbench.sideBar.visible": true,
      "workbench.statusBar.visible": true,
      "workbench.tree.indent": 2,
      "vim.useSystemClipboard": [ "yank" ],
      "experimental.viml": [
        "noremap é w",
        "noremap É W",
        "noremap è ^",
        "noremap È 0",
        
        "onoremap aé aw",
        "onoremap aÉ aW",
        "onoremap ié iw",
        "onoremap iÉ iW",
        
        "vnoremap aé aw",
        "vnoremap aÉ aW",
        "vnoremap ié iw",
        "vnoremap iÉ iW",

        "noremap <C-w>C <C-w>H",
        "noremap <C-w>T <C-w>J",
        "noremap <C-w>S <C-w>K",
        "noremap <C-w>R <C-w>L",

        "noremap <C-w>t <C-w>j",
        "noremap <C-w>s <C-w>k",
        "noremap <C-w>c <C-w>h",
        "noremap <C-w>r <C-w>l",

        "noremap <C-w>- <C-w>s",
        "noremap <C-w>/ <C-w>v",

        "noremap c h",
        "noremap r l",
        "noremap t j",
        "noremap s k",
        "noremap C H",
        "noremap R L",
        "noremap T J",
        "noremap S K",
        "noremap zs zk",
        "noremap zt zj",

        "noremap j t",
        "noremap J T",
        "noremap l c",
        "noremap L C",
        "noremap h r",
        "noremap H R",
        "noremap k s",
        "noremap K S",
        "noremap ]k ]s",
        "noremap [k [s",

        "noremap gs gk",
        "noremap gt gj",
        "noremap gb gT",
        "noremap gé gt",

        "nmap «« [[",
        "nmap »» ]]"
      ] 
    }
  '';
}
