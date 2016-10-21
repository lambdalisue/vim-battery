let s:t_funcref = type(function('tr'))


function! battery#backend#get(name) abort
  if exists('s:' . a:name)
    return s:{a:name}
  endif
  return s:dummy
endfunction


" dummy ----------------------------------------------------------------------
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


" pmset -------------------------------------------------------------
let s:pmset = deepcopy(s:dummy)

function! s:pmset.update() abort
  if battery#job#is_alive(self.job)
    return
  endif
  let self.job = battery#job#start('pmset -g ps', self)
endfunction

function! s:pmset.on_stdout(job, data, event) abort
  call extend(self.data, a:data)
endfunction

function! s:pmset.on_exit(...) abort
  let content = join(self.data, '\n')
  let self.data = []
  let self.value = str2nr(matchstr(content, '\d\+\ze%'))
  let self.is_charging = content =~# 'AC Power'
  if type(self.callback) == s:t_funcref
    call self.callback()
  endif
endfunction


" ioreg ------------------------------------------------------------
let s:ioreg = deepcopy(s:dummy)

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
  let content = join(self.data, '\n')
  let max_cap = str2float(matchstr(content, '"MaxCapacity" = \zs\d\+'))
  let cur_cap = str2float(matchstr(content, '"CurrentCapacity" = \zs\d\+'))
  let charging = matchstr(content, '"IsCharging" = \zs\%(Yes\|No\)')
  let self.data = []
  let self.value = cur_cap / max_cap * 100
  let self.is_charging = charging ==# 'Yes'
  if type(self.callback) == s:t_funcref
    call call(self.callback, [], self)
  endif
endfunction
