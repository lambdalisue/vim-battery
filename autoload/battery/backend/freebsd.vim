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

let s:bat_status = 'hw.acpi.battery.state'
let s:bat_capacity = 'hw.acpi.battery.life'

let s:Job = vital#battery#import('System.Job')

function! s:freebsd_update() abort dict
  if type(self.job) is# v:t_dict && self.job.status() ==# 'run'
    return
  endif
  let data = []
  let args = ['sysctl', '-n', s:bat_status, s:bat_capacity]
  let self.job = s:Job.start(args, {
        \ 'on_stdout': funcref('s:on_stdout', [data]),
        \ 'on_exit': funcref('s:on_exit', [self, data]),
        \})
endfunction

function! s:on_stdout(buffer, data) abort
  call extend(a:buffer, a:data)
endfunction

function! s:on_exit(backend, buffer, exitval) abort
  let a:backend.is_charning = get(a:buffer, 0, '') !=# 'NOT_CHARNING'
  let a:backend.value = get(a:buffer, 1, '') + 0
endfunction

function! battery#backend#freebsd#define() abort
  return {
   	\ 'job': 0,
        \ 'value': -1,
        \ 'is_charging': -1,
        \ 'update': funcref('s:freebsd_update'),
        \}
endfunction

function! battery#backend#freebsd#is_available() abort
  return !empty(s:bat_status) && !empty(s:bat_capacity)
endfunction
