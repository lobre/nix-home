''
  " Variable to hold the enable status
  let g:is_enabled = 0

  " Function to enable or disable bepo mappings
  function s:set(enable)
      let g:is_enabled = a:enable

      if a:enable
          " Use é and è
          noremap é w
          noremap É W
          noremap è ^
          noremap È 0
          
          " Remap text objects with é
          onoremap aé aw
          onoremap aÉ aW
          onoremap ié iw
          onoremap iÉ iW
          vnoremap aé aw
          vnoremap aÉ aW
          vnoremap ié iw
          vnoremap iÉ iW

          " Remap windows manipulations
          noremap <C-w>C <C-w>H
          noremap <C-w>T <C-w>J
          noremap <C-w>S <C-w>K
          noremap <C-w>R <C-w>L

          noremap <C-w>t <C-w>j
          noremap <C-w>s <C-w>k
          noremap <C-w>c <C-w>h
          noremap <C-w>r <C-w>l

          noremap <C-w>- <C-w>s
          noremap <C-w>/ <C-w>v

          " Remap terminal windows manipulations
          if has("terminal")
              tnoremap <C-w>C <C-w>H
              tnoremap <C-w>T <C-w>J
              tnoremap <C-w>S <C-w>K
              tnoremap <C-w>R <C-w>L

              tnoremap <C-w>t <C-w>j
              tnoremap <C-w>s <C-w>k
              tnoremap <C-w>c <C-w>h
              tnoremap <C-w>r <C-w>l

              tnoremap <C-w>- <C-w>s
              tnoremap <C-w>/ <C-w>v
          endif

          " hjkl -> ctsr
          noremap c h
          noremap r l
          noremap t j
          noremap s k
          noremap C H
          noremap R L
          noremap T J
          noremap S K
          noremap zs zk
          noremap zt zj

          " hjkl <- ctsr
          noremap j t
          noremap J T
          noremap l c
          noremap L C
          noremap h r
          noremap H R
          noremap k s
          noremap K S
          noremap ]k ]s
          noremap [k [s

          " Remap g keymaps
          noremap gs gk
          noremap gt gj
          noremap gb gT
          noremap gé gt
          noremap gB :exe "silent! tabfirst"<CR>
          noremap gÉ :exe "silent! tablast"<CR>
          noremap g" g0

          " Move around in code
          nmap «« [[
          nmap »» ]]

          " Remap jump to/from tags
          nnoremap <C-t> g<C-]>
          nnoremap g<C-t> <C-t>

      else
          unmap é
          unmap É
          unmap è
          unmap È

          ounmap aé
          ounmap aÉ
          ounmap ié
          ounmap iÉ
          vunmap aé
          vunmap aÉ
          vunmap ié
          vunmap iÉ

          unmap <C-w>C
          unmap <C-w>T
          unmap <C-w>S
          unmap <C-w>R

          unmap <C-w>t
          unmap <C-w>s
          unmap <C-w>c
          unmap <C-w>r

          unmap <C-w>-
          unmap <C-w>/

          if has("terminal")
              tunmap <C-w>C
              tunmap <C-w>T
              tunmap <C-w>S
              tunmap <C-w>R

              tunmap <C-w>t
              tunmap <C-w>s
              tunmap <C-w>c
              tunmap <C-w>r

              tunmap <C-w>-
              tunmap <C-w>/
          endif

          unmap c
          unmap r
          unmap t
          unmap s
          unmap C
          unmap R
          unmap T
          unmap S
          unmap zs
          unmap zt

          unmap j
          unmap J
          unmap l
          unmap L
          unmap h
          unmap H
          unmap k
          unmap K
          unmap ]k
          unmap [k

          unmap gs
          unmap gt
          unmap gb
          unmap gé
          unmap gB
          unmap gÉ
          unmap g"

          unmap ««
          unmap »»

          nunmap <C-t>
          nunmap g<C-t>
      endif

      " Remap in netrw
      if has("autocmd")
          augroup Netrw
              autocmd!
              autocmd FileType netrw call s:netrw()
          augroup END
      endif
  endfunction

  " Remap when in Ex file explorer
  function s:netrw()
      if g:is_enabled == 0
          nunmap <buffer> k
          nunmap <buffer> t
       else
          nnoremap <buffer> t j
          nnoremap <buffer> s k
      endif
  endfunction

  " Toggle the activation of bepo mappings
  function s:toggle()
      if g:is_enabled == 0 
          call Bepo(1)
          echo "Bepo has been enabled"
      else
          call Bepo(0)
          echo "Bepo has been disabled"
      endif
  endfunction

  " Display whether bepo mode is activated
  function s:status()
      if g:is_enabled == 0 
          echo "Bepo is disabled"
      else
          echo "Bepo is enabled"
      endif
  endfunction

  " Create commands
  command BepoStatus :call <SID>status()
  command BepoToggle :call <SID>toggle()
  command BepoEnable :call <SID>set(1)
  command BepoDisable :call <SID>set(0)

  " Activate bepo by default
  call <SID>set(1)
''
