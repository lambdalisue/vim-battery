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

function! s:read_sysctl(ctl) abort
  let cmd = 'sysctl -n ' . a:ctl
  return system(cmd)
endfunction

function! s:freebsd_update() abort dict
  let self.is_charging = s:read_sysctl(s:bat_status)
  let self.value = s:read_sysctl(s:bat_capacity) + 0
endfunction

function! battery#backend#freebsd#define() abort
  return {
        \ 'value': -1,
        \ 'is_charging': -1,
        \ 'update': funcref('s:freebsd_update'),
        \}
endfunction

function! battery#backend#freebsd#is_available() abort
  return !empty(s:bat_status) && !empty(s:bat_capacity)
endfunction
