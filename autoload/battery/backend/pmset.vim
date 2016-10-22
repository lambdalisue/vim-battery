" Ref:  https://github.com/b4b4r07/dotfiles/blob/master/bin/battery
let s:t_funcref = type(function('tr'))

let s:pmset = {
      \ 'job': 0,
      \ 'data': [],
      \ 'value': -1,
      \ 'is_charging': -1,
      \ 'callback': 0,
      \}

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
  let content = join(self.data, "\n")
  let self.data = []
  let self.value = str2nr(matchstr(content, '\d\+\ze%'))
  let self.is_charging = content =~# 'AC Power'
  if type(self.callback) == s:t_funcref
    call self.callback()
  endif
endfunction


function! battery#backend#pmset#define() abort
  return s:pmset
endfunction
