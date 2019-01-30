" Ref:  https://github.com/b4b4r07/dotfiles/blob/master/bin/battery
let s:Job = vital#battery#import('System.Job')

function! s:ioreg_update() abort dict
  if type(self.job) is# v:t_dict && self.job.status() ==# 'run'
    return
  endif
  let data = []
  let args = ['ioreg', '-n', 'AppleSmartBattery']
  let self.job = s:Job.start(args, {
        \ 'on_stdout': funcref('s:on_stdout', [data]),
        \ 'on_exit': funcref('s:on_exit', [self, data]),
        \})
endfunction

function! s:on_stdout(buffer, data) abort
  call extend(a:buffer, a:data)
endfunction

function! s:on_exit(backend, buffer, exitval) abort
  let content = join(a:buffer, "\n")
  let max_cap = str2float(matchstr(content, '"MaxCapacity" = \zs\d\+'))
  let cur_cap = str2float(matchstr(content, '"CurrentCapacity" = \zs\d\+'))
  let charging = matchstr(content, '"IsCharging" = \zs\%(Yes\|No\)')
  let a:backend.value = float2nr(cur_cap / max_cap * 100.0)
  let a:backend.is_charging = charging ==# 'Yes'
  if type(a:backend.callback) == v:t_func
    call call(a:backend.callback, [], a:backend)
  endif
endfunction

function! battery#backend#ioreg#define() abort
  return {
        \ 'job': 0,
        \ 'value': -1,
        \ 'is_charging': -1,
        \ 'callback': 0,
        \ 'update': funcref('s:ioreg_update'),
        \}
endfunction
