if v:version < 704
  " NOTE: this line fixes an issue with the default system-wide lisp ftplugin
  "       which didn't define b:undo_ftplugin on older Vim versions
  "       (*.jl files are recognized as lisp)
  autocmd BufRead,BufNewFile *.jl    let b:undo_ftplugin = "setlocal comments< define< formatoptions< iskeyword< lisp<"
endif

autocmd BufRead,BufNewFile *.jl      set filetype=julia

" Use latex to unicode on these pattern only
let s:l2u_patterns = get(g:, "latex_to_unicode_file_types", "*.jl,*.jmd")

" This autocommand is used to postpone the first initialization of LaTeXtoUnicode as much as possible,
" by calling LaTeXtoUnicode#SetTab and LaTeXtoUnicode#SetAutoSub only at InsertEnter or later
function! s:L2UTrigger()
  augroup L2UInit
    autocmd!
    execute 'autocmd InsertEnter ' . s:l2u_patterns . ' let g:did_insert_enter = 1 | call LaTeXtoUnicode#Enable()'
  augroup END
endfunction
execute 'autocmd BufEnter ' . s:l2u_patterns . ' call s:L2UTrigger()'

function! s:HighlightJuliaMarkdown()
  if !exists('g:markdown_fenced_languages')
    let g:markdown_fenced_languages = []
  endif
  if index(g:markdown_fenced_languages, 'julia') == -1
    call add(g:markdown_fenced_languages, 'julia')
  endif
endfunction
autocmd BufRead,BufNewFile *.jmd     call s:HighlightJuliaMarkdown()
autocmd BufRead,BufNewFile *.jmd     set filetype=markdown
