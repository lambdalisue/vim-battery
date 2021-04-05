" Ref: https://wiki.termux.com/wiki/Termux-battery-status
let s:Job = vital#battery#import('System.Job')

function! s:termux_update() abort dict
  if type(self.job) is# v:t_dict && self.job.status() ==# 'run'
    return
  endif
  let data = []
  let args = ['termux-battery-status']
  let self.job = s:Job.start(args, {
        \ 'on_stdout': funcref('s:on_stdout', [data]),
        \ 'on_exit': funcref('s:on_exit', [self, data]),
        \})
endfunction

function! s:on_stdout(buffer, data) abort
  call extend(a:buffer, a:data)
endfunction

function! s:on_exit(backend, buffer, exitval) abort
  let obj = json_decode(join(a:buffer, ''))
  let status = get(obj, 'status', '')
  let a:backend.is_charging = !(status ==# 'NOT_CHARGING' || status ==# 'DISCHARGING')
  let a:backend.value = get(obj, 'percentage', 0) + 0
endfunction

function! battery#backend#termux#define() abort
  return {
        \ 'job': 0,
        \ 'value': -1,
        \ 'is_charging': -1,
        \ 'update': funcref('s:termux_update'),
        \}
endfunction

function! battery#backend#termux#is_available() abort
  return executable('termux-battery-status')
endfunction
