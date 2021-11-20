" deinセットアップ
let s:dein_path       = expand('~/.local/share/dein.vim')
let s:dein_repo_path  = expand('~/.local/share/dein.vim/repos/github.com/Shougo/dein.vim')
let s:dein_toml_path  = expand('~/.config/dein.vim/dein.toml')

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
if len(dein#check_clean()) != 0
  call map(dein#check_clean(), "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif

" キーマップ
"" 次/前のウィンドウ
noremap <C-n> <C-w>w
noremap <C-p> <C-w>W

"" 行頭/行末へ移動
noremap t ^
noremap T $

"" 検索ハイライト解除
noremap <BSlash> :noh<CR>

"" NERDTree表示切り替え
noremap <C-s> :NERDTreeToggle<CR>

"" Terminalモード時、Escでノーマルモードへ
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
set diffopt+=algorithm:histogram


" 言語カスタム系
"" Vagrantfileはrubyのシンタックスを使用
autocmd BufNewFile,BufRead Vagrantfile setlocal filetype=ruby

"" Makefileにはハードタブを使う
autocmd FileType make setlocal noexpandtab
