function! battery#backend() abort
  if exists('s:backend')
    return s:backend
  endif
  let s:backend = battery#backend#get(g:battery#backend)
  let s:backend.callback = function('s:update_callback')
  return s:backend
endfunction

function! battery#update() abort
  let backend = battery#backend()
  return backend.update()
endfunction

function! battery#value() abort
  let backend = battery#backend()
  return backend.value
endfunction

function! battery#is_charging() abort
  let backend = battery#backend()
  return backend.is_charging
endfunction

function! battery#sign() abort
  let backend = battery#backend()
  return backend.is_charging
        \ ? g:battery#symbol_charging
        \ : g:battery#symbol_discharging
endfunction

function! battery#graph() abort
  let backend = battery#backend()
  let nf = float2nr(round(backend.value / (100.0 / g:battery#graph_width)))
  let nn = g:battery#graph_width - nf
  return printf('%s%s',
        \ repeat(g:battery#graph_symbol_fill, nf),
        \ repeat(g:battery#graph_symbol_null, nn),
        \)
endfunction

function! battery#watch() abort
  if exists('s:timer')
    call timer_stop(s:timer)
  endif
  let s:timer = timer_start(0, function('s:watch_callback'))
endfunction

function! battery#unwatch() abort
  if exists('s:timer')
    call timer_stop(s:timer)
    unlet s:timer
  endif
endfunction

function! battery#component() abort
  let backend = battery#backend()
  if backend.value == -1
    return ''
  endif
  let format = g:battery#component_format
  let format = substitute(format, '%v', backend.value, 'g')
  let format = substitute(format, '%s', battery#sign(), 'g')
  let format = substitute(format, '%g', battery#graph(), 'g')
  let format = substitute(format, '%\([^%]\)', '\1', 'g')
  let format = substitute(format, '%%', '%', 'g')
  return format
endfunction

function! s:update_callback() abort
  if g:battery#update_tabline
    let &tabline = &tabline
  endif
  if g:battery#update_statusline
    let &statusline = &statusline
  endif
endfunction

function! s:watch_callback(...) abort
  call battery#update()
  let s:timer = timer_start(
        \ g:battery#update_interval,
        \ function('s:watch_callback')
        \)
endfunction

function! s:get_available_backend() abort
  if executable('pmset')
    return 'pmset'
  elseif executable('ioreg')
    return 'ioreg'
  elseif executable('powershell.exe')
    return 'powershell'
  endif
  return 'dummy'
endfunction

function! s:define(prefix, default) abort
  let prefix = a:prefix =~# '^g:' ? a:prefix : 'g:' . a:prefix
  for [key, Value] in items(a:default)
    let name = prefix . '#' . key
    if !exists(name)
      execute 'let ' . name . ' = ' . string(Value)
    endif
    unlet Value
  endfor
endfunction

call s:define('g:battery', {
      \ 'backend': s:get_available_backend(),
      \ 'update_interval': 30000,
      \ 'update_tabline': 0,
      \ 'update_statusline': 0,
      \ 'component_format': '%s %v%% %g',
      \ 'symbol_charging': '♥',
      \ 'symbol_discharging': '♡',
      \ 'graph_symbol_fill': '█',
      \ 'graph_symbol_null': '░',
      \ 'graph_width': 5,
      \})
