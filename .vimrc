" deinのセットアップ
let s:dein_path = expand('~/.vim/dein')
let s:dein_repo_path = expand('~/.vim/dein/repos/github.com/Shougo/dein.vim')

if !isdirectory(s:dein_repo_path)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_path
endif

execute 'set runtimepath+=' . s:dein_repo_path
call dein#begin(expand(s:dein_path))

" Github上のプラグインを追加
call dein#add('Shougo/dein.vim')
call dein#add('itchyny/lightline.vim')
call dein#add('tpope/vim-fugitive')
call dein#add('tomasr/molokai')
call dein#add('cohama/lexima.vim')
call dein#end()
" Update plugins
if dein#check_install()
  call dein#install()
endif

" 使ってないプラグインは消す
call map(dein#check_clean(), "delete(v:val, 'rf')")


" lightline.vim
set noshowmode
let g:lightline = {
\ 'active': {
\ 'left': [['mode', 'paste'],
\   ['gitbranch', 'readonly', 'filename', 'modified']]
\ },
\ 'component_function': {
\   'gitbranch': 'fugitive#head'
\ }}

" 自前キーマップ
noremap \ :noh<CR>
noremap <C-_> :%s///gc

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

" 言語ごとの設定
autocmd BufNewFile,BufRead Vagrantfile setlocal filetype=ruby
autocmd FileType make setlocal noexpandtab

" カラースキーム
colorscheme molokai
syntax on

" 括弧が見づらいので変える
if g:colors_name == "molokai"
  hi MatchParen ctermfg=208 ctermbg=233 gui=bold
  hi MatchParen guifg=#FD971F guibg=#000000 gui=bold
endif
