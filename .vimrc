set title
set tabstop=2
set smartindent
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent
set expandtab
set number
set showmatch
set smarttab
set ruler
set whichwrap=b,s,h,l,<,>,[,]
set backspace=indent,eol,start
set laststatus=2

inoremap <s-tab> <Esc><<i
nnoremap <s-tab> <<

set t_ut=
inoremap {<Enter> {<CR>}<Esc><S-o>
inoremap { {}<LEFT>
inoremap {} {}
inoremap [<Enter> [<CR>]<Esc><S-o>
inoremap [ []<LEFT>
inoremap [] []
inoremap (<Enter> (<CR>)<Esc><S-o>
inoremap ( ()<LEFT>
inoremap () ()
inoremap " ""<LEFT>
inoremap "" ""<LEFT>
inoremap '' ''<LEFT>
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

" matchitを有効化
source $VIMRUNTIME/macros/matchit.vim

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

" -----
" NERDTree
" -----
NeoBundle 'scrooloose/nerdtree'
nnoremap <silent><C-p> :NERDTreeToggle<CR>

" ----------------
" ステータスライン
" ----------------
NeoBundle 'itchyny/lightline.vim'
let g:lightline = {
        \ 'colorscheme': 'landscape',
        \ 'mode_map': {'c': 'NORMAL'},
        \ 'active': {
        \   'left': [
        \     ['mode', 'paste'],
        \     ['fugitive', 'gitgutter', 'filename', 'lineinfo', 'syntastic'],
        \   ],
        \   'right': [
        \     ['percent'],
        \     ['charcode', 'fileformat', 'fileencoding', 'filetype'],
        \   ]
        \ },
        \ 'component_function': {
        \   'modified': 'MyModified',
        \   'readonly': 'MyReadonly',
        \   'fugitive': 'MyFugitive',
        \   'filename': 'MyFilename',
        \   'fileformat': 'MyFileformat',
        \   'filetype': 'MyFiletype',
        \   'fileencoding': 'MyFileencoding',
        \   'mode': 'MyMode',
        \   'syntastic': 'SyntasticStatuslineFlag',
        \   'charcode': 'MyCharCode',
        \   'gitgutter': 'MyGitGutter',
        \ },
        \ 'separator': {'left': '⮀', 'right': '⮂'},
        \ 'subseparator': {'left': '⮁', 'right': '⮃'}
        \ }

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &ro ? '⭤' : ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? substitute(b:vimshell.current_dir,expand('~'),'~','') :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
      let _ = fugitive#head()
      return strlen(_) ? '⭠ '._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! MyFileformat()
  return winwidth('.') > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth('.') > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth('.') > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  return winwidth('.') > 60 ? lightline#mode() : ''
endfunction

function! MyGitGutter()
  if ! exists('*GitGutterGetHunkSummary')
        \ || ! get(g:, 'gitgutter_enabled', 0)
        \ || winwidth('.') <= 90
    return ''
  endif
  let symbols = [
        \ g:gitgutter_sign_added . ' ',
        \ g:gitgutter_sign_modified . ' ',
        \ g:gitgutter_sign_removed . ' '
        \ ]
  let hunks = GitGutterGetHunkSummary()
  let ret = []
  for i in [0, 1, 2]
    if hunks[i] > 0
      call add(ret, symbols[i] . hunks[i])
    endif
  endfor
  return join(ret, ' ')
endfunction

" https://github.com/Lokaltog/vim-powerline/blob/develop/autoload/Powerline/Functions.vim
function! MyCharCode()
  if winwidth('.') <= 70
    return ''
  endif

  " Get the output of :ascii
  redir => ascii
  silent! ascii
  redir END

  if match(ascii, 'NUL') != -1
    return 'NUL'
  endif

  " Zero pad hex values
  let nrformat = '0x%02x'

  let encoding = (&fenc == '' ? &enc : &fenc)

  if encoding == 'utf-8'
    " Zero pad with 4 zeroes in unicode files
    let nrformat = '0x%04x'
  endif

  " Get the character and the numeric value from the return value of :ascii
  " This matches the two first pieces of the return value, e.g.
  " "<F>  70" => char: 'F', nr: '70'
  let [str, char, nr; rest] = matchlist(ascii, '\v\<(.{-1,})\>\s*([0-9]+)')

  " Format the numeric value
  let nr = printf(nrformat, nr)

  return "'". char ."' ". nr
endfunction

" Git
NeoBundle 'tpope/vim-fugitive'

NeoBundle 'airblade/vim-gitgutter'
let g:gitgutter_sign_added = '✚'
let g:gitgutter_sign_modified = '➜'
let g:gitgutter_sign_removed = '✘'

" コード補完
if has('lua') && (v:version > 703 || v:version == 703 && has('patch885'))
  NeoBundle 'Shougo/neocomplete.vim'
  let g:acp_enableAtStartup = 0
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_smart_case = 1
  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif
  let g:neocomplete#force_omni_input_patterns.ruby = '[^.*\t]\.\w*\|\h\w*::'
endif

" rsense
NeoBundle 'marcus/rsense'
NeoBundle 'supermomonga/neocomplete-rsense.vim'

" rsenseの自動補完をon
let g:rsenseUseOmniFunc = 1


" linter
NeoBundle 'scrooloose/syntastic'
" syntastic_mode_mapをactiveにするとバッファ保存時にsyntasticが走る
" active_filetypesに、保存時にsyntasticを走らせるファイルタイプを指定する
let g:syntastic_mode_map = { 'mode': 'active', 'active_filetypes': ['ruby'] }
" ruby には rubocop を使う
let g:syntastic_ruby_checkers = ['rubocop']
" QuickFixを自動で出す
" let g:syntastic_auto_loc_list = 1
" :wq で閉じるときに linter を走らせない
let g:syntastic_check_on_wq = 0

" メソッド定義元へのジャンプ
NeoBundle 'szw/vim-tags'

" 非同期処理
NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
  \     'windows' : 'make -f make_mingw32.mak',
  \     'cygwin' : 'make -f make_cygwin.mak',
  \     'mac' : 'make -f make_mac.mak',
  \     'unix' : 'make -f make_unix.mak',
  \    },
  \ }

" Rubyドキュメント参照
NeoBundle 'thinca/vim-ref'
NeoBundle 'yuku-t/vim-ref-ri'

" Rubyのendを自動入力
NeoBundle 'tpope/vim-endwise'

" -----------------------
" unite: ファイルランチャ
" -----------------------
if v:version >= 703
  NeoBundle 'Shougo/unite.vim'
  " unite {{{
  let g:unite_enable_start_insert=1
  nmap <silent> <C-u><C-b> :<C-u>Unite buffer<CR>
  nmap <silent> <C-u><C-f> :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
  nmap <silent> <C-u><C-r> :<C-u>Unite -buffer-name=register register<CR>
  nmap <silent> <C-u><C-m> :<C-u>Unite file_mru<CR>
  nmap <silent> <C-u><C-u> :<C-u>Unite buffer file_mru<CR>
  nmap <silent> <C-u><C-a> :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
  au FileType unite nmap <silent> <buffer> <expr> <C-j> unite#do_action('split')
  au FileType unite imap <silent> <buffer> <expr> <C-j> unite#do_action('split')
  au FileType unite nmap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
  au FileType unite imap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
  au FileType unite nmap <silent> <buffer> <ESC><ESC> q
  au FileType unite imap <silent> <buffer> <ESC><ESC> <ESC>q
  " }}}
endif

call neobundle#end() " プラグイン記述ここまで
NeoBundleCheck " インストールされていないものを自動でインストール

" 空行インデントの削除を抑制
" 参考: http://yakinikunotare.boo.jp/orebase/index.php?Vim%2F%B6%F5%B9%D4%A4%CE%A5%A4%A5%F3%A5%C7%A5%F3%A5%C8%A4%F2%BA%EF%BD%FC%A4%B7%A4%CA%A4%A4%A4%E8%A4%A6%A4%CB%A4%B9%A4%EB
nnoremap o oX<C-h>
nnoremap O OX<C-h>
inoremap <CR> <CR>X<C-h>

" 行末空白を保存時に削除
autocmd BufWritePre * :%s/\s\+$//ge

" 編集中ファイルのディレクトリへ移動
au BufEnter * execute ":lcd " . expand("%:p:h")

syntax on
filetype on
filetype indent on
filetype plugin on

