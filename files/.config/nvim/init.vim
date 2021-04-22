" deinセットアップ
let s:dein_path       = expand('~/.local/share/dein.vim')
let s:dein_repo_path  = expand('~/.local/share/dein.vim/repos/github.com/Shougo/dein.vim')
let s:dein_toml_path  = expand('~/.config/dein.vim/dein.toml')

if !isdirectory(s:dein_repo_path)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_path
endif

execute 'set runtimepath+=' . s:dein_repo_path
let g:dein#auto_recache = 1

"" プラグイン読み込み
if dein#load_state(s:dein_path)
  call dein#begin(s:dein_path)
  call dein#load_toml(s:dein_toml_path)
  call dein#end()
  call dein#save_state()
endif

"" Update plugins
if dein#check_install()
  call dein#install()
endif

"" 使ってないプラグインは消す
call map(dein#check_clean(), "delete(v:val, 'rf')")


" キーマップ
noremap <C-n> <C-w>w
noremap <C-p> <C-w>W
noremap t ^
noremap T $

noremap <Space> <Nop>
noremap <Space>nh :noh<CR>
noremap <C-s> :NERDTreeToggle<CR>

noremap <Space>tm :bo split \| resize 16 \| term<CR>
tnoremap <Esc> <C-\><C-n>


" いろいろ
set tabstop=2
set shiftwidth=2
set expandtab
set laststatus=2
set hlsearch
set termguicolors
set backspace=indent,eol,start
set cursorline
set number
set clipboard+=unnamed


" 言語カスタム系
"" Vagrantfileはrubyのシンタックスを使用
autocmd BufNewFile,BufRead Vagrantfile setlocal filetype=ruby

"" Makefileは例外的にハードタブを使用
autocmd FileType make setlocal noexpandtab
