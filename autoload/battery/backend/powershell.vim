let s:Job = vital#battery#import('System.Job')

function! s:powershell_update() abort dict
  call self._run_if_not_running()
  if type(self.job) is# v:t_dict && self.job.status() ==# 'run'
    call self.job.send("[System.Console]::Error.WriteLine('i' + [System.Windows.Forms.SystemInformation]::PowerStatus.PowerLineStatus)\n")
    call self.job.send("[System.Console]::Error.WriteLine('v' + [System.Windows.Forms.SystemInformation]::PowerStatus.BatteryLifePercent)\n")
  endif
endfunction

function! s:powershell_run_if_not_running() abort dict
  if type(self.job) is# v:t_dict && self.job.status() ==# 'run'
    return
  endif
  let args = [
        \ 'powershell.exe',
        \ '-NoLogo',
        \ '-NonInteractive',
        \ '-NoExit',
        \ '-Command',
        \ 'function prompt() {''#''} Add-Type -Assembly System.Windows.Forms',
        \]
  let buffer = ['']
  let self.job = s:Job.start(args, {
        \ 'on_stderr': funcref('s:on_stderr', [buffer], self),
        \})
endfunction

function! s:on_stderr(buffer, data) abort dict
  let a:buffer[-1] .= a:data[0]
  call extend(a:buffer, a:data[1:])
  if len(a:buffer) is# 1
    return
  endif
  for line in remove(a:buffer, 0, -2)
    let key = line[0]
    let value = line[1:]
    if key ==# 'i'
      let self.is_charging = value =~# 'Online'
    elseif key ==# 'v'
      let self.value = float2nr(100 * str2float(value))
    endif
  endfor
  if type(self.callback) == v:t_func
    call self.callback()
  endif
endfunction

function! battery#backend#powershell#define() abort
  return {
        \ 'job': 0,
        \ 'value': -1,
        \ 'is_charging': -1,
        \ 'callback': 0,
        \ 'update': funcref('s:powershell_update'),
        \ '_run_if_not_running': funcref('s:powershell_run_if_not_running'),
        \}
endfunction
