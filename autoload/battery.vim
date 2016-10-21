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

function! battery#indicator() abort
  let backend = battery#backend()
  let n = round(backend.value / (100.0 / g:battery#barwidth))
  return printf('%s%s',
        \ repeat(g:battery#fillchar, float2nr(n)),
        \ repeat(g:battery#nonechar, g:battery#barwidth - float2nr(n)),
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
  if backend.is_charging
    let format = g:battery#charging_format
  else
    let format = g:battery#not_charging_format
  endif
  let format = substitute(format, '%p', backend.value, 'g')
  let format = substitute(format, '%b', battery#indicator(), 'g')
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
        \ g:battery#interval,
        \ function('s:watch_callback')
        \)
endfunction

function! s:get_available_backend() abort
  if executable('pmset')
    return 'pmset'
  elseif executable('ioreg')
    return 'ioreg'
  endif
  return ''
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
      \ 'interval': 1000,
      \ 'update_tabline': 1,
      \ 'update_statusline': 1,
      \ 'charging_format': '♥ %p% %b',
      \ 'not_charging_format': '♡ %p% %b',
      \ 'fillchar': '█',
      \ 'nonechar': '░',
      \ 'barwidth': 5,
      \ 'watch_on_startup': 1,
      \})

if g:battery#watch_on_startup
  call battery#watch()
endif


