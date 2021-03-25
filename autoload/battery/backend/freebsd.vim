" Reference:
" sysctl -d hw.acpi.battery
"
" hw.acpi.battery: battery status and info
" hw.acpi.battery.info_expire: time in seconds until info is refreshed
" hw.acpi.battery.units: number of batteries
" hw.acpi.battery.state: current status flags
"   discharging = 1
"   charging = 2
"   critical = 4
" hw.acpi.battery.rate: present rate in mW
" hw.acpi.battery.time: remaining time in minutes
" hw.acpi.battery.life: percent capacity remaining

let s:Job = vital#battery#import('System.Job')

let s:BAT_STATUS = 'hw.acpi.battery.state'
let s:BAT_CAPACITY = 'hw.acpi.battery.life'

let s:job = v:null

function! s:freebsd_update() abort dict
  if type(s:job) is# v:t_dict && s:job.status() ==# 'run'
    return
  endif
  let data = []
  let args = ['sysctl', '-n', s:BAT_STATUS, s:BAT_CAPACITY]
  let s:job = s:Job.start(args, {
        \ 'on_stdout': funcref('s:on_stdout', [data]),
        \ 'on_exit': funcref('s:on_exit', [self, data]),
        \})
endfunction

function! s:on_stdout(buffer, data) abort
  call extend(a:buffer, a:data)
endfunction

function! s:on_exit(backend, buffer, exitval) abort
  let data = filter(a:buffer, '!empty(v:val)')
  let a:backend.is_charging = get(data, 0, '') !=# 'NOT_CHARGING'
  let a:backend.value = get(data, 1, '') + 0
endfunction

function! battery#backend#freebsd#define() abort
  return {
        \ 'value': -1,
        \ 'is_charging': -1,
        \ 'update': funcref('s:freebsd_update'),
        \}
endfunction

function! battery#backend#freebsd#is_available() abort
  return executable('sysctl')
endfunction
