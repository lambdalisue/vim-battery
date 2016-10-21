vim-battery
==============================================================================
![Version 0.1.0](https://img.shields.io/badge/version-0.1.0-yellow.svg?style=flat-square)
![Support Neovim 0.1.6 or above](https://img.shields.io/badge/support-Neovim%200.1.6%20or%20above-green.svg?style=flat-square)
![Support Vim 8.0 or above](https://img.shields.io/badge/support-Vim%208.0.0%20or%20above-yellowgreen.svg?style=flat-square)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20battery-orange.svg?style=flat-square)](doc/battery.txt)

![battery in tabline](https://photos-2.dropbox.com/t/2/AACN0epZgqwK8vG0iw4gGF29Rie4Wj44ulbDcEY-HPdj2A/12/1529319/png/32x32/1/_/1/2/Screenshot%202016-10-22%2005.00.18.png/EIe6oQEYlIPs2gQgAigC/TWprLR6YpGRIsf3qfWjRGAw-wNagYxAtnsBX41qnzyU?size=1280x960&size_mode=3)

*battery* is an asynchronous battery indicator which is used as a component of statusline or tabline.
It uses job features of Vim/Neovim so it won't interrupt the Vim.

**Only for Mac OS X. PR is welcome.**

Install
-------------------------------------------------------------------------------
Use your favorite Vim plugin manager such as [junegunn/vim-plug] or [Shougo/dein.vim] like:

```vim
" Plug.vim
Plug 'lambdalisue/vim-battery'

" dein.vim
call dein#add('lambdalisue/vim-battery')
```

Or copy contents of the repository into your runtimepath manually.

[junegunn/vim-plug]: https://github.com/junegunn/vim-plug
[Shougo/dein.vim]: https://github.com/Shougo/dein.vim


Usage
-------------------------------------------------------------------------------

Use `battery#component()` function to display the battery information like:

```vim
set statusline=...%{battery#component()}...
```

Or with [itchyny/lightline.vim](https://github.com/itchyny/lightline.vim)

```vim
let g:lightline = {
      \ 'tabline': {
      \   'left': [
      \     [ 'tabs' ],
      \   ],
      \   'right': [
      \     [ 'battery' ],
      \   ],
      \ },
      \ 'component_function': {
      \   'battery': 'battery#component',
      \ },
      \}
```

See more detail on [battery.txt](./doc/battery.txt)
