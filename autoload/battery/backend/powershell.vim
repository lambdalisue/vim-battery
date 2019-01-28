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
let s:charge_pattern = s:mode == 0 ? 'Online' : 'Charging'

function! s:powershell.run_if_not_running()
  if battery#job#is_alive(self.job)
    return
  endif
  let self.job = battery#job#start('powershell.exe -NoLogo -NonInteractive -NoExit -Command "function prompt() {''#''} Add-Type -Assembly System.Windows.Forms"', self)
endfunction

function! s:powershell.on_stderr(job, data, event) abort
  let l:msg = get(a:data,0)
  if s:callback_count == s:mode
    let self.is_charging = l:msg =~ s:charge_pattern
  elseif s:callback_count == 2
    let self.value = float2nr(100 * str2float(l:msg))
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
  if type(self.callback) == s:t_funcref
    call self.callback()
  endif
endfunction


function! battery#backend#powershell#define() abort
  return s:powershell
endfunction
