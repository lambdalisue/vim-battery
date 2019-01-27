" Ref:  https://github.com/b4b4r07/dotfiles/blob/master/bin/battery
let s:t_funcref = type(function('tr'))

let s:powershell = {
      \ 'job': 0,
      \ 'data': [],
      \ 'value': -1,
      \ 'is_charging': -1,
      \ 'callback': 0,
      \}

let s:callback_count = 0

" mode0: charging indicator will be on when ac adopter is connected
" mode1: charging indicator will be on only when battery is charging
let s:mode = 1

function! s:powershell.run_if_not_running()
  if battery#job#is_alive(self.job)
    return
  endif
  let options = {}
  let options.err_cb = function('s:on_stderr', [self])
  let self.job = job_start('powershell.exe -NoLogo -NonInteractive -NoExit -Command "function prompt() {''#''} Add-Type -Assembly System.Windows.Forms"', options)
endfunction

function! s:on_stderr(inst, channel, msg)
  call a:inst.on_stderr(a:msg)
endfunction
function! s:powershell.on_stderr(msg)
  if s:callback_count == s:mode
    let self.is_charging = a:msg =~ 'Online'
  elseif s:callback_count == s:mode
    let self.is_charging = a:msg =~ 'Charging'
  elseif s:callback_count == 2
    let self.value = float2nr(100 * str2float(a:msg))
  endif

  if s:callback_count == 2
    let s:callback_count = 0
  else
    let s:callback_count = s:callback_count + 1
  endif

endfunction


function! s:powershell.update() abort
  if s:callback_count != 0
    return
  endif
  call s:powershell.run_if_not_running()
  let l:channel = job_getchannel(self.job)
  call ch_sendraw(l:channel, '[System.Windows.Forms.SystemInformation]::PowerStatus | %{echo $_.PowerLineStatus; echo $_.BatteryChargeStatus; echo $_.BatteryLifePercent} | %{[System.Console]::Error.WriteLine($_)}')
  call ch_sendraw(l:channel, "\n")
endfunction

function! s:powershell.on_stdout(job, data, event) abort
  " ignore all outputs of stdout because powershell cannot hide the prompt(PS>)
endfunction

function! s:powershell.on_exit(...) abort
  " this function will never be called ?
  if type(self.callback) == s:t_funcref
    call self.callback()
  endif
endfunction


function! battery#backend#powershell#define() abort
  return s:powershell
endfunction
