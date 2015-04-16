set title
syntax on
set tabstop=2
set smartindent
set shiftwidth=2
set autoindent
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

