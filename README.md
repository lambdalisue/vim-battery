battery.vim
==============================================================================
![Version 0.1.0](https://img.shields.io/badge/version-0.1.0-yellow.svg?style=flat-square)
![Support Neovim 0.1.6 or above](https://img.shields.io/badge/support-Neovim%200.1.6%20or%20above-green.svg?style=flat-square)
![Support Vim 8.0 or above](https://img.shields.io/badge/support-Vim%208.0.0%20or%20above-yellowgreen.svg?style=flat-square)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20battery-orange.svg?style=flat-square)](doc/battery.txt)

![battery.vim in tabline](https://photos-6.dropbox.com/t/2/AABsMlzdOJ2vc2YukhntmqzxT5ogJXpd12a20mmhvjW8Bw/12/1529319/png/32x32/1/_/1/2/Screenshot%202016-10-22%2019.40.09.png/EIe6oQEYlYPs2gQgAigC/G4NUU0h7vuh7Ulnu1wgZobKIjFxsH7QmBaEhSIeWyZg?size=1024x768&size_mode=3)

*battery.vim* is a `statusline` or `tabline` component for Neovim/Vim.
It uses a job feature of Neovim/Vim to retrieve battery informations so that the plugin won't block the main thread.

**NOTE: Only for Mac OS X. PR is welcom.**

The implementation was translated to Vim script from a Bash script found on https://github.com/b4b4r07/dotfiles/blob/master/bin/battery.

Install
-------------------------------------------------------------------------------
Use [junegunn/vim-plug] or [Shougo/dein.vim] like:

```vim
" Plug.vim
Plug 'lambdalisue/battery.vim'

" dein.vim
call dein#add('lambdalisue/battery.vim')
```

Or copy contents of the repository into your runtimepath manually.

[junegunn/vim-plug]: https://github.com/junegunn/vim-plug
[Shougo/dein.vim]: https://github.com/Shougo/dein.vim


Usage
-------------------------------------------------------------------------------

Use `battery#component()` like:

```vim
set statusline=...%{battery#component()}...
set tabline=...%{battery#component()}...
```

Or with [itchyny/lightline.vim](https://github.com/itchyny/lightline.vim)

```vim
let g:lightline = {
      \ ...
      \ 'component_function': {
      \   ...
      \   'battery': 'battery#component',
      \   ...
      \ },
      \ ...
      \}
```

Additionally, assign 1 to corresponding variables to immediately reflect the
changes to `statusline` or `tabline`.

```vim
let g:battery#update_tabline = 1    " For tabline.
let g:battery#update_statusline = 1 " For statusline.
```


See also
-------------------------------------------------------------------------------

- [lambdalisue/wifi.vim](https://github.com/lambdalisue/wifi.vim)
