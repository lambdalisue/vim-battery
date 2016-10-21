if has('nvim')
  function! battery#job#start(argv, options) abort
    return jobstart(a:argv, a:options)
  endfunction

  function! battery#job#is_alive(job) abort
    try
      return jobpid(a:job) > 0
    catch /^Vim\%((\a\+)\)\=:E900/  " Invalid job id
      return 0
    endtry
  endfunction
else
  function! battery#job#start(argv, options) abort
    let options = { 'out_mode': 'raw' }
    if has_key(a:options, 'on_stdout')
      let options.out_cb = function('s:out_cb', [a:options])
    endif
    if has_key(a:options, 'on_exit')
      let options.exit_cb = function('s:exit_cb', [a:options])
    endif
    return job_start(a:argv, options)
  endfunction

  function! battery#job#is_alive(job) abort
    try
      return job_status(a:job) == 'run'
    catch /^Vim\%((\a\+)\)\=:E475/  " Invalid argument
      return 0
    endtry
  endfunction

  function! s:out_cb(instance, channel, msg) abort
    call call(
          \ a:instance.on_stdout,
          \ [a:channel, split(a:msg, '\r\?\n'), 'stdout'],
          \ a:instance,
          \)
  endfunction

  function! s:exit_cb(instance, channel, msg) abort
    call call(
          \ a:instance.on_exit,
          \ [a:channel, split(a:msg, '\r\?\n'), 'exit'],
          \ a:instance,
          \)
  endfunction
endif
