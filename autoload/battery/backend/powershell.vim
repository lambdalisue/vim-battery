" Ref:  https://github.com/b4b4r07/dotfiles/blob/master/bin/battery
let s:t_funcref = type(function('tr'))

let s:powershell = {
      \ 'job': 0,
      \ 'data': [],
      \ 'value': -1,
      \ 'is_charging': -1,
      \ 'callback': 0,
      \}

function! s:powershell.update() abort
  if battery#job#is_alive(self.job)
    return
  endif
  let self.job = battery#job#start('powershell.exe -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SystemInformation]::PowerStatus | %{echo $_.PowerLineStatus; echo $_.BatteryChargeStatus; echo $_.BatteryLifePercent}"', self)
endfunction

function! s:powershell.on_stdout(job, data, event) abort
  call extend(self.data, a:data)
endfunction

function! s:powershell.on_exit(...) abort
  let self.value = float2nr(100 * str2float(get(self.data,2)))
  " set true when ac power (whether charging or not), replace follow two lines.
  "let self.is_charging = get(self.data,0) =~ 'Online'
  let self.is_charging = get(self.data,1) =~ 'Charging'
  let self.data = []
  if type(self.callback) == s:t_funcref
    call self.callback()
  endif
endfunction


function! battery#backend#powershell#define() abort
  return s:powershell
endfunction
