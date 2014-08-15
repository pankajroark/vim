call pathogen#infect()

set nocompatible              " be iMproved
filetype off                  " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'scrooloose/nerdtree.git'
Bundle 'mileszs/ack.vim.git'
Bundle 'Shougo/neocomplcache.git'
Bundle 'ervandew/supertab.git'
Bundle 'majutsushi/tagbar.git'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-fugitive.git'
Bundle 'vim-ruby/vim-ruby.git'
Bundle 'tpope/vim-unimpaired.git'
"Bundle 'altercation/vim-colors-solarized.git'
Bundle 'nelstrom/vim-textobj-rubyblock.git'
Bundle 'kana/vim-textobj-user.git'
Bundle 'edsono/vim-matchit.git'
Bundle 'bkad/CamelCaseMotion.git'
Bundle 'kien/ctrlp.vim.git'
Bundle 'altercation/vim-colors-solarized.git'
Bundle 'pankajroark/vim-scala.git'
Bundle 'scrooloose/nerdcommenter.git'
Bundle 'jakar/vim-json.git'
Bundle 'ciaranm/inkpot.git'
Bundle 'flazz/vim-colorschemes.git'
Bundle 'rodjek/vim-puppet.git'
Bundle 'uarun/vim-protobuf.git'
Bundle 'ton/vim-bufsurf.git'
Bundle 'ktvoelker/sbt-vim.git'
Bundle 'jigish/vim-thrift.git'
Bundle 'sprsquish/thrift.vim.git'
Bundle 'tpope/vim-surround.git'
Bundle 'maxbrunsfeld/vim-yankstack'
Bundle 'bling/vim-airline'
Bundle 'sickill/vim-pasta'
Bundle 'skwp/greplace.vim'
Bundle 'vim-scripts/genutils'
Bundle 'pankajroark/vim-scala-jump'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'Shougo/unite.vim'
Bundle 'msanders/cocoa.vim'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'tpope/timl.git'
Bundle 'AndrewRadev/sideways.vim'
Bundle 'Shougo/vimproc.vim'
" Needs building https://github.com/JazzCore/ctrlp-cmatcher
Bundle 'JazzCore/ctrlp-cmatcher'
Bundle 'mikewest/vimroom'
Bundle 'wting/rust.vim'
Bundle 'oplatek/Conque-Shell'

set tabstop=2            " number of spaces to indent when tab-key is pressed
set shiftwidth=2         " number of space characters inserted for indentation
set expandtab            " insert space characters whenever the tab key is pressed
syntax on
filetype plugin indent on

set ic
set incsearch
set autoindent
set tabstop=2            " number of spaces to indent when tab-key is pressed
set shiftwidth=2         " number of space characters inserted for indentation
set expandtab            " insert space characters whenever the tab key is pressed

set scrolloff=5
set tags=./tags;/
set cursorline
set relativenumber
set nf=octal,hex,alpha

set viminfo='10,\"100,:20,%,n~/.viminfo
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

" Restore cursor"
augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

" Load NerdTree by default
"autocmd vimenter * NERDTree

" Map NerdTree
nmap <F5> :NERDTreeToggle<CR>
nmap <F6> :TagbarToggle<CR>

" Remember leader n stands for nerdtree in general
nmap <leader>nf :NERDTreeFind<CR>

" This has been assigned to jump to definition
"nmap <D-j> <C-w><C-w>
nmap <D-k> <C-w>p

" Source the vimrc file after saving it
augroup VimrcReload
  autocmd!
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif
augroup end

nmap <leader>v :tabedit $MYVIMRC<CR>
nmap <C-S-c> :s/^/#/<CR>j


set background=dark
"colorscheme inkpot
" colorscheme pyte
" colorscheme molokai
colorscheme solarized

map <D-e> <C-e>

" Remove trailing whitespace, remember leader x is for replace
map <leader>xs :%s/\s\+$//<CR>

" Ruby debugging
let g:ruby_debugger_progname = 'mvim'

"neocomplcache
let g:neocomplcache_enable_at_startup = 1
let g:ackprg="ack -i -H --nocolor --nogroup --column"
let g:neocomplcache_disable_auto_complete=1
" minibufexplorer
let g:miniBufExplMapCTabSwitchBufs = 1

"powerline
let g:Powerline_symbols = 'fancy'
set laststatus=2

" file type detections
augroup Filetypedetect 
  autocmd!
  au BufNewFile,BufRead *.pig set filetype=pig syntax=pig 
  au BufNewFile,BufRead *.aurora set filetype=python syntax=python 
  au BufNewFile,BufRead *.gradle set filetype=groovy
  au BufNewFile,BufRead *.thrift set filetype=thrift syntax=thrift 
  au BufNewFile,BufRead buildfile set filetype=ruby
augroup END 

" matchit
runtime macros/matchit.vim

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>


fun! GuiTabLabel()
  let tabnumber = tabpagenr()
  let tabname = fnamemodify(bufname(winbufnr(1)), ":t")
  let bettertabname = (match(tabname, "NERD_tree") == -1) ? tabname : fnamemodify(bufname(winbufnr(2)), ":t")
  return  join([ tabnumber, bettertabname ], ":")
endf

augroup NumberTabs
  autocmd!
  au BufEnter * set guitablabel=%{GuiTabLabel()}
augroup END

augroup NerdSync
  autocmd!
  ""au BufEnter * if (exists("b:NERDTreeType")) :normal NERDTreeFind endif
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
augroup end

set winwidth=90
noremap <Tab> :call Next_buffer_or_next_tab()<cr>

fun! Next_buffer_or_next_tab()
  let num_buffers = len(tabpagebuflist())
  echo num_buffers
  if (num_buffers <= 1) 
    :tabnext
  else
    :exe "normal \<C-w>\<C-w>"
  endif
endf

noremap <S-Tab> :call Previous_window()<cr>
fun! Previous_window()
  let cur_win_nr = winnr()
  let num_windows = len(tabpagebuflist())
  let prev_win_nr = cur_win_nr - 1
  if (prev_win_nr < 1)
    let prev_win_nr = num_windows
  endif
  :exe "normal " . prev_win_nr . "\<C-w>\<C-w>"
endf

nnoremap <leader>j :%! python -mjson.tool<cr>

set updatetime=3000
augroup AutomaticSave
  autocmd!
  au CursorHold * call Save_if_writable()
  au CursorHoldI * call Save_if_writable()
  au BufLeave * call Save_if_writable()
augroup END

fun! Save_if_writable()
  if(filewritable(bufname("%")))
    if(&readonly == 0 && &mod)
      :w
    endif
  endif
endf  

" rather drastic no swap file
set noswapfile

noremap <C-w>1 :only<cr>

" switch to last tab
let g:lasttab = 1
noremap <C-Tab> :exe "tabn ".g:lasttab<CR>
augroup RememberLastTab
  autocmd!
  au TabLeave * let g:lasttab = tabpagenr()
augroup END

" Another mapping for escape
inoremap jk <esc>

imap ;pn println()<left>
imap ;cl console.log("");<left><left><left>
imap ;sn System.out.println();<left><left>

" nnoremap <space> :silent execute "Ack! " . shellescape(expand("<cword>"))<cr> 
nnoremap <space> :w<cr>

nnoremap gp `[v`]

" Automatically close open brace
function! ConditionalPairMap(open, close, nextLine)
  let line = getline('.')
  let col = col('.')
  if col < col('$') || stridx(line, a:close, col + 1) != -1
    return a:open
  else
    if(a:nextLine == 0)
      return a:open . a:close . repeat("\<left>", len(a:close))
    else
      return a:open . "\<cr>" . a:close . repeat("\<Esc>O", 1)
    endif
  endif
endf
"inoremap <expr> ( ConditionalPairMap('(', ')', 0)
inoremap <expr> { ConditionalPairMap('{', '}', 0)
"inoremap <expr> [ ConditionalPairMap('[', ']', 0)
"inoremap <expr> (<cr> ConditionalPairMap('(', ')', 1)
"inoremap <expr> {<cr> ConditionalPairMap('{', '}', 1)
"inoremap <expr> [<cr> ConditionalPairMap('[', ']', 1)

"inoremap " ""<Left>

noremap <D-[> :BufSurfBack<cr>
noremap <D-]> :BufSurfForward<cr>

" git vim sessions stuff
let s:sessions_dir = "~/.vim/sessions/"

function! GetCurrentGitBranch()
    return system("git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* //'")
endfunction

function! GetWorkingDirectory()
    redir => current_dir
    silent pwd
    redir END
    return current_dir
endfunction

function! GetSessionFile()
    let branch = GetCurrentGitBranch()
    if branch == ""
        echo "No git repository at " . GetWorkingDirectory()
    else
        return s:sessions_dir . GetCurrentGitBranch()
    endif
    return ""
endfunction

function! GitSessionSave()
    let session_file = GetSessionFile()
    if session_file != ""
        execute "mksession! " . session_file
        echo "Saved session to " . session_file
    endif
endfunction

function! GitSessionRestore()
    let session_file = GetSessionFile()
    if session_file != ""
        execute "tabo"
        execute "source " . session_file
        echo "Restored session " . session_file
    endif
endfunction

command! Gss call GitSessionSave()
command! Gsr call GitSessionRestore()

augroup MySessions
  autocmd!
  au VimLeave * call GitSessionSave()
augroup end
"au VimEnter * call GitSessionRestore()

" Pull word under cursor into LHS of a substitute
:nmap <leader>z :%s#\<<c-r>=expand("<cword>")<cr>\>#
" Pull Visually Highlighted text into LHS of a substitute
:vmap <leader>z :<C-U>%s/\<<c-r>*\>/

" Make Y behave like C and D"
nmap Y y$

augroup ScalaRemoveWhiteSpaceOnSave
  autocmd!
  autocmd BufWritePre *.scala :%s/\s\+$//ge
augroup END

onoremap an :<c-u>call <SID>NextTextObject('a', 'f')<cr>
xnoremap an :<c-u>call <SID>NextTextObject('a', 'f')<cr>
onoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>
xnoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>

onoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
xnoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
onoremap il :<c-u>call <SID>NextTextObject('i', 'F')<cr>
xnoremap il :<c-u>call <SID>NextTextObject('i', 'F')<cr>

function! s:NextTextObject(motion, dir)
  let c = nr2char(getchar())

  if c ==# "b"
      let c = "("
  elseif c ==# "B"
      let c = "{"
  elseif c ==# "d"
      let c = "["
  endif

  exe "normal! ".a:dir.c."v".a:motion.c
endfunction

" Make system key board the default
set clipboard=unnamed

" Mapping for Yank Ring
"nnoremap <silent> <F7> :YRShow<CR>

" map c-j to escapre
inoremap <C-j> <Esc>
" map c-s to save
inoremap <C-s> <Esc>:w<cr>

map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" For a rainy that I want to jump forward
" nnoremap g. <C-i>

" [Trick] To copy-paste line 10 lines above current line -> ':-10t.'
" [Trick] For below -> ':+10t.'

" [Override] Use gp to select previously paste text, overrides paste + go to end
nmap gp `[v`]

" Make the current window more obvious
augroup BgHighlight
  autocmd!
  autocmd WinEnter * set colorcolumn=81
  autocmd WinLeave * set colorcolumn=0
augroup END

" Unite.vim customizations
let g:unite_data_directory='~/.vim/.cache/unite'
let g:unite_source_rec_max_cache_files = 200000
call unite#custom#source('file_rec/async', 'max_candidates', 20)
noremap <leader>b :<C-u>Unite buffer<CR>
let g:unite_source_history_yank_enable = 1
nnoremap <leader>y :<C-u>Unite history/yank<CR>

if executable('ag')
  let g:unite_source_rec_async_command= 'ag --nocolor --nogroup -g "scala"'
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts =
  \ '--line-numbers --nocolor --nogroup --hidden --ignore ' .
  \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr''' .
  \ '--ignore ''.pants.d'''
  let g:unite_source_grep_recursive_opt = ''
  " Unite.vim fuzzy finder
  call unite#filters#matcher_default#use(['matcher_fuzzy'])
  nnoremap <leader>f :<C-u>Unite -start-insert file_rec<CR>
endif


" Disable gui cursor blinking
set guicursor+=a:blinkon0

augroup rainbow
  autocmd!
  au BufWinEnter * RainbowParenthesesActivate
  au Syntax * RainbowParenthesesLoadRound
  au Syntax * RainbowParenthesesLoadSquare
  au Syntax * RainbowParenthesesLoadBraces
augroup END

" Sideways mapping (swap function params)
nnoremap <leader><right> :SidewaysRight<cr>
nnoremap <leader><left>  :SidewaysLeft<cr>

" Let ctrlp ignore gitignore files
let g:ctrlp_working_path_mode = 2
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_max_files = 0
let g:ctrlp_max_depth = 40
let g:ctrlp_by_filename = 1
let g:ctrlp_mruf_max = 1000
set wildignore+=*.so,*.class,*.o,*.jar,*.swp,*.zip
" Jump to only scala or java files
" let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files | grep "\(scala\|java\)"']
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:10'
let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }

" Ctrlp mappings
noremap <leader>m :CtrlPMRU<CR>
noremap <leader>a :CtrlPMixed<CR>

" command mode mappings
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <S-Left>
cnoremap <C-f> <S-Right>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>

" preview dot file
nnoremap <leader>p :silent ! dot -Tpng % > /tmp/test.png; open /tmp/test.png <CR>

" Moving to lines with same indentation
nnoremap <M-,> :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%<' . line('.') . 'l\S', 'be')<CR>
nnoremap <M-.> :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%>' . line('.') . 'l\S', 'e')<CR>

" Set persistent undo
set undofile
set undodir=/Users/pankajg/.vimundo

" backspace to go to beginning of file
nnoremap <BS> gg
nnoremap <Del> G
