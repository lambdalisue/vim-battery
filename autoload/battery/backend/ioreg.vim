" Ref:  https://github.com/b4b4r07/dotfiles/blob/master/bin/battery
let s:t_funcref = type(function('tr'))

let s:ioreg = {
      \ 'job': 0,
      \ 'data': [],
      \ 'value': -1,
      \ 'is_charging': -1,
      \ 'callback': 0,
      \}

function! s:ioreg.update() abort
  if battery#job#is_alive(self.job)
    return
  endif
  let self.job = battery#job#start(
        \ 'ioreg -n AppleSmartBattery',
        \ self
        \)
endfunction

function! s:ioreg.on_stdout(job, data, event) abort
  call extend(self.data, a:data)
endfunction

function! s:ioreg.on_exit(...) abort
  let content = join(self.data, "\n")
  let max_cap = str2float(matchstr(content, '"MaxCapacity" = \zs\d\+'))
  let cur_cap = str2float(matchstr(content, '"CurrentCapacity" = \zs\d\+'))
  let charging = matchstr(content, '"IsCharging" = \zs\%(Yes\|No\)')
  let self.data = []
  let self.value = float2nr(cur_cap / max_cap * 100.0)
  let self.is_charging = charging ==# 'Yes'
  if type(self.callback) == s:t_funcref
    call call(self.callback, [], self)
  endif
endfunction

