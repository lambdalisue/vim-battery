" Ref: https://github.com/lambdalisue/battery.vim/issues/7
let s:bat_dirs = '/sys/class/power_supply/{CMD*,BAT*,battery}'
let s:bat_status = get(glob(s:bat_dirs . '/status', 0, 1), 0, '')
let s:bat_capacity = get(glob(s:bat_dirs . '/capacity', 0, 1), 0, '')

function! s:read(path) abort
  let body = readfile(a:path)
  return get(body, 0, '')
endfunction

function! s:linux_update() abort dict
  let self.is_charging = s:read(s:bat_status) !=# 'Discharging'
  let self.value = s:read(s:bat_capacity) + 0
endfunction

function! battery#backend#linux#define() abort
  return {
        \ 'value': -1,
        \ 'is_charging': -1,
        \ 'update': funcref('s:linux_update'),
        \}
endfunction

function! battery#backend#linux#is_available() abort
  return !empty(s:bat_status) && !empty(s:bat_capacity)
endfunction
