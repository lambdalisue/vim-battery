function! battery#backend#get(name) abort
  try
    return battery#backend#{a:name}#define()
  catch /^Vim\%((\a\+)\)\=:E117/
    " Unknown function. Fallback to a dummy backend
    return battery#backend#dummy#define()
  endtry
endfunction
