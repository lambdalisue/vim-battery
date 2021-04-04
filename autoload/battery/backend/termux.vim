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
	let g:bat_status_list = ['NOT_CHARGING' , 'DISCHARGING']
  let content = join(a:buffer, '')
	if index(g:bat_status_list, json_decode(content).status) >= 0
		let a:backend.is_charging = 0
	endif
  let a:backend.value = json_decode(content).percentage + 0
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
