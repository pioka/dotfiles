" deinセットアップ
let s:dein_path = expand('~/.vim/dein')
let s:dein_repo_path = expand('~/.vim/dein/repos/github.com/Shougo/dein.vim')
let s:dein_toml_path = expand('~/.vim/dein/dein.toml')

if !isdirectory(s:dein_repo_path)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_path
endif

execute 'set runtimepath+=' . s:dein_repo_path

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


" 自前キーマップ
noremap <Space>nh :noh<CR>
noremap <Space>nt :NERDTreeToggle<CR>
noremap <Space>e :tabe 
noremap <Space>h ^
noremap <Space>l $

" いろいろ
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set smartindent
set laststatus=2
set hlsearch
set termguicolors
set backspace=indent,eol,start
set cursorline
set number


" 言語カスタム系
"" Vagrantfileはrubyのシンタックスを使用
autocmd BufNewFile,BufRead Vagrantfile setlocal filetype=ruby

"" Makefileは例外的にハードタブを使用
autocmd FileType make setlocal noexpandtab
