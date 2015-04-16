set title
syntax on
set tabstop=2
set smartindent
set shiftwidth=2
set autoindent
set smartindent
set expandtab
set number
set showmatch
set smarttab
set ruler
set whichwrap=b,s,<,>,[,]

inoremap <s-tab> <Esc><<i
nnoremap <s-tab> <<

set t_ut=
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
function! DeleteParenthesesAdjoin()
  let pos = col(".") - 1  " カーソルの位置．1からカウント
  let str = getline(".")  " カーソル行の文字列
  let parentLList = ["(", "[", "{", "\'", "\""]
  let parentRList = [")", "]", "}", "\'", "\""]
  let cnt = 0

  let output = ""

  " カーソルが行末の場合
  if pos == strlen(str)
    return "\b"
  endif
  for c in parentLList
    " カーソルの左右が同種の括弧
    if str[pos-1] == c && str[pos] == parentRList[cnt]
      call cursor(line("."), pos + 2)
      let output = "\b"
      break
    endif
    let cnt += 1
  endfor
  return output."\b"
endfunction
" BackSpaceに割り当て
inoremap <silent> <BS> <C-R>=DeleteParenthesesAdjoin()<CR>

" プラグイン管理
if has('vim_starting')
  set nocompatible
  " neobundle をインストールしてない場合はインストール
  if !isdirectory(expand("~/.vim/bundle/neobundle.vim"))
    echo "install neobundle"
    :call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
  endif
  " runtimepath へ追加
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle')) " プラグイン記述ここから
let g:neobundle_default_git_protocol='https'
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundleCheck " インストールされていないものを自動でインストール
call neobundle#end()
syntax on

