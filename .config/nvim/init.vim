" --- vscode-neovim起動時 ---
if exists('g:vscode')
  " clipboard共有
  set clipboard+=unnamed

  "" Leaderキー
  let mapleader = "\<Space>"

  "" 行頭/行末へ移動
  noremap t ^
  noremap T $

  "" タブ操作系
  noremap <Leader>j :Tabnext<CR>
  noremap <Leader>k :Tabprevious<CR>

  "" https://github.com/vscode-neovim/vscode-neovim/issues/247
  nnoremap <silent> u :<C-u>call VSCodeNotify('undo')<CR>
  nnoremap <silent> <C-r> :<C-u>call VSCodeNotify('redo')<CR>

  finish
endif



" --- 通常起動時 ---
" deinセットアップ
let s:dein_path       = expand('~/.cache/dein.vim')
let s:dein_repo_path  = expand(s:dein_path.'/repos/github.com/Shougo/dein.vim')
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
"" Leaderキー
let mapleader = "\<Space>"

"" 行頭/行末へ移動
noremap t ^
noremap T $

"" バッファ操作系
noremap <C-j> :bnext<CR>
noremap <C-k> :bprev<CR>

"" ウィンドウ操作系
noremap <Leader>- :split<CR><C-w>w
noremap <Leader><Bar> :vsplit<CR><C-w>w
noremap <Leader>j <C-w>w
noremap <Leader>k <C-w>W

"" QuickFix開閉
noremap <Leader>co :copen<CR>
noremap <Leader>cc :cclose<CR>

"" ファイルブラウザ(Fern) トグル
noremap <Leader>o :Fern . -reveal=% -drawer -toggle<CR>


" オプションいろいろ
set tabstop=2
set shiftwidth=2
set expandtab
set laststatus=2
set hlsearch
set termguicolors
set backspace=indent,eol,start
set cursorline
set number
set hidden
set list
set listchars=tab:→\ ,trail:･,nbsp:･
set signcolumn=yes
set clipboard+=unnamed
set diffopt+=algorithm:histogram
set mouse=a

" 全角スペース強調表示
augroup HighlightZenkakuSpace
  autocmd!
  autocmd VimEnter,ColorScheme * highlight link ZenkakuSpace Error
  autocmd VimEnter * match ZenkakuSpace /　/
augroup END

" 言語カスタム系
"" Vagrantfileはrubyのシンタックスを使用
autocmd BufNewFile,BufRead Vagrantfile setlocal filetype=ruby

"" Makefileにはハードタブを使う
autocmd FileType make setlocal noexpandtab
