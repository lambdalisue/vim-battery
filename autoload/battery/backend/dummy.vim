let s:dummy = {
      \ 'job': 0,
      \ 'data': [],
      \ 'value': -1,
      \ 'is_charging': -1,
      \ 'callback': 0,
      \}

function! s:dummy.update() abort
endfunction

function! s:dummy.on_stdout(job, data, event) abort
endfunction

function! s:dummy.on_exit(...) abort
endfunction


function! battery#backend#dummy#define() abort
  return s:dummy
endfunction
