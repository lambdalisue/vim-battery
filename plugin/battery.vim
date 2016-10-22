if exists('g:loaded_battery')
  finish
endif
let g:loaded_battery = 1

if get(g:, 'battery_watch_on_startup', 1)
  call battery#watch()
endif
