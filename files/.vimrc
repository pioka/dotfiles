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
"" 汎用
""" 行頭/行末へ移動
noremap t ^
noremap T $

""" Ctrl+Kでノーマルモードへ
inoremap <C-k> <Esc>
vnoremap <C-k> <Esc>
cnoremap <C-k> <C-c>

""" 検索ハイライト解除
noremap /<CR> :noh<CR>

""" バッファ移動
noremap <C-n> :bnext<CR>
noremap <C-p> :bprev<CR>

"" Leaderキー系独自マップ
let mapleader = "\<Space>"

""" ウィンドウ操作系
noremap <Leader>- :split<CR><C-w>w
noremap <Leader><Bar> :vsplit<CR><C-w>w
noremap <Leader>n <C-w>w
noremap <Leader>p <C-w>W

""" QuickFix開閉
noremap <Leader>co :copen<CR>
noremap <Leader>cc :cclose<CR>

""" ファイルブラウザ トグル
noremap <Leader>o :Fern . -reveal=% -drawer -toggle<CR>

""" grep
noremap <expr> <Leader>f ':sil grep! ' . substitute(expand('<cword>'), '#', '\\#','g') . ' . \| copen'


" オプションいろいろ
set tabstop=2
set shiftwidth=2
set expandtab
set laststatus=2
set hlsearch
set backspace=indent,eol,start
set cursorline
set number
set hidden
set list
set listchars=tab:→\ ,trail:･,nbsp:･
set signcolumn=yes
set clipboard+=unnamed
set diffopt+=algorithm:histogram

" TrueColor表示
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors

if executable('rg')
  set grepprg=rg\ --vimgrep\ --hidden\ --glob='!.git'\ --glob='!.svn'\ $*
else
  set grepprg=grep\ --exclude-dir=.svn\ --exclude-dir=.git\ -rnI\ $*
endif

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

