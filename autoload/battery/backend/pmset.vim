" Ref:  https://github.com/b4b4r07/dotfiles/blob/master/bin/battery
let s:Job = vital#battery#import('System.Job')

function! s:pmset_update() abort dict
  if type(self.job) is# v:t_dict && self.job.status() ==# 'run'
    return
  endif
  let data = []
  let args = ['pmset', '-g', 'ps']
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
  let a:backend.value = str2nr(matchstr(content, '\d\+\ze%'))
  let a:backend.is_charging = content =~# 'AC Power'
  if type(a:backend.callback) == v:t_func
    call a:backend.callback()
  endif
endfunction

function! battery#backend#pmset#define() abort
  return {
        \ 'job': 0,
        \ 'value': -1,
        \ 'is_charging': -1,
        \ 'callback': 0,
        \ 'update': funcref('s:pmset_update'),
        \}
endfunction
