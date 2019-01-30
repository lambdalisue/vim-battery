battery.vim
==============================================================================
![Version 0.2.0](https://img.shields.io/badge/version-0.2.0-yellow.svg?style=flat-square)
![Support Neovim 0.2.0 or above](https://img.shields.io/badge/support-Neovim%200.2.0%20or%20above-green.svg?style=flat-square)
![Support Vim 8.0.0027 or above](https://img.shields.io/badge/support-Vim%208.0.0027%20or%20above-yellowgreen.svg?style=flat-square)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20battery-orange.svg?style=flat-square)](doc/battery.txt)
[![Powered by vital.vim](https://img.shields.io/badge/powered%20by-vital.vim-80273f.svg?style=flat-square)](https://github.com/vim-jp/vital.vim)

![battery.vim in tabline](https://media.githubusercontent.com/media/lambdalisue/screenshots/master/battery.vim/tabline_with_lightline.png)

*battery.vim* is a `statusline` or `tabline` component for Neovim/Vim.
It uses a job feature of Neovim/Vim to retrieve battery informations so that the plugin won't block the main thread.

It works on macOS and Windows. Any PR of implementations for Linux are welcome.

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
