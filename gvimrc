syntax on
filetype plugin indent on

set ic
set incsearch
set autoindent
set tabstop=2            " number of spaces to indent when tab-key is pressed
set shiftwidth=2         " number of space characters inserted for indentation
set expandtab            " insert space characters whenever the tab key is pressed
set nu

set scrolloff=5
set tags=./tags;/
set cursorline

set viminfo='10,\"100,:20,%,n~/.viminfo
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

" Load NerdTree by default
"autocmd vimenter * NERDTree

" Map NerdTree
nnoremap <F5> :NERDTreeToggle<CR>
nnoremap <F6> :TagbarToggle<CR>

" Remember leader n stands for nerdtree in general
nnoremap <leader>nf :NERDTreeFind<CR>

noremap <D-j> <C-w><C-w>
noremap <D-k> <C-w>p

" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .gvimrc source $MYGVIMRC
endif

noremap <leader>v :tabedit $MYGVIMRC<CR>
noremap <leader>xt :tabedit $HOME/.todo<CR>
noremap <leader>xy :tabedit $HOME/.today<CR>
noremap <C-S-c> :s/^/#/<CR>j

map <D-up> :vertical resize +5<cr>
map <C-down> :vertical resize -5<cr>

set background=dark
colorscheme solarized

map <D-e> <C-e>

" Remove trailing whitespace, remember leader x is for replace
map <leader>xs :%s/\s\+$//<CR>

" Ruby debugging
let g:ruby_debugger_progname = 'mvim'

"neocomplcache
let g:neocomplcache_enable_at_startup = 1
let g:ackprg="ack -H --nocolor --nogroup --column"
" minibufexplorer
let g:miniBufExplMapCTabSwitchBufs = 1

"powerline
let g:Powerline_symbols = 'fancy'
set laststatus=2

"pig
augroup filetypedetect 
  au BufNewFile,BufRead *.pig set filetype=pig syntax=pig 
augroup END 

"macvim fullscreen
if has("gui_running")
  "set fuoptions=maxvert,maxhorz
  "au GUIEnter * set fullscreen
endif

"CloseMiniBufExplorer by default
"map <F7> :TMiniBufExplorer<CR>

" Set a large font
set guifont=Menlo\ Regular:h14
au! BufRead,BufNewFile buildfile set filetype=ruby

" Don't interpret numbers starting with 0 as octal
set nrformats=

" Command - T helpers
function! Git_Repo_Cdup() " Get the relative path to repo root
    "Ask git for the root of the git repo (as a relative '../../' path)
    let git_top = system('git rev-parse --show-cdup')
    let git_fail = 'fatal: Not a git repository'
    if strpart(git_top, 0, strlen(git_fail)) == git_fail
        " Above line says we are not in git repo. Ugly. Better version?
        return ''
    else
        " Return the cdup path to the root. If already in root,
        " path will be empty, so add './'
        return './' . git_top
    endif
endfunction

function! CD_Git_Root()
    execute 'cd '.Git_Repo_Cdup()
    let curdir = getcwd()
    echo 'CWD now set to: '.curdir
endfunction
nnoremap <LEADER>gr :call CD_Git_Root()<cr>

" Define the wildignore from gitignore. Primarily for CommandT
function! WildignoreFromGitignore()
    silent call CD_Git_Root()
    let gitignore = '.gitignore'
    if filereadable(gitignore)
        let igstring = ''
        for oline in readfile(gitignore)
            let line = substitute(oline, '\s|\n|\r', '', "g")
            if line =~ '^#' | con | endif
            if line == '' | con  | endif
            if line =~ '^!' | con  | endif
            if line =~ '/$' | let igstring .= "," . line . "*" | con | endif
            let igstring .= "," . line
        endfor
        let execstring = "set wildignore=".substitute(igstring,'^,','',"g")
        execute execstring
        echo 'Wildignore defined from gitignore in: '.getcwd()
    else
        echo 'Unable to find gitignore'
    endif
endfunction

nnoremap <LEADER>cti :call WildignoreFromGitignore()<cr>
nnoremap <LEADER>cwi :set wildignore=''<cr>:echo 'Wildignore cleared'<cr>

" Mapping for current file path on ex
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Let ctrlp ignore gitignore files
let g:ctrlp_working_path_mode = 2
set wildignore+=*.so,*.class,*.o,*.jar,*.swp,*.zip
let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files']

" set dictionary
set dictionary +=~/.vim/dict

" auto save on buffer switching
set autowriteall

" map c-j to escapre
inoremap <C-j> <Esc>
" map c-s to save
inoremap <C-s> <Esc>:w<cr>

" map semicolon to enter
" inoremap <C-;> <cr>
" map shift enter in command mode to adding a new line
map <S-Enter> O<Esc>
map <CR> o<Esc>

set updatetime=3000
au CursorHold * call Save_if_writable()
au CursorHoldI * call Save_if_writable()
au BufLeave * call Save_if_writable()

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
au TabLeave * let g:lasttab = tabpagenr()

noremap <D-1> :tabn 1<cr>
noremap <D-2> :tabn 2<cr>
noremap <D-3> :tabn 3<cr>
noremap <D-4> :tabn 4<cr>
noremap <D-5> :tabn 5<cr>
noremap <D-6> :tabn 6<cr>
noremap <D-7> :tabn 7<cr>
noremap <D-8> :tabn 8<cr>
noremap <D-9> :tablast<cr>

imap ;pn println()<left>
imap ;cl console.log("");<left><left><left>

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


" Ctrlp mappings
noremap <leader>b :CtrlPBuffer<CR>
noremap <leader>m :CtrlPMRU<CR>

fun! GuiTabLabel()
  let tabnumber = tabpagenr()
  let tabname = fnamemodify(bufname(winbufnr(1)), ":t")
  let bettertabname = (match(tabname, "NERD_tree") == -1) ? tabname : fnamemodify(bufname(winbufnr(2)), ":t")
  return  join([ tabnumber, bettertabname ], ":")
endf

au BufEnter * set guitablabel=%{GuiTabLabel()}

" move line around
nnoremap - ddp
nnoremap _ ddkP

" correct receive
iabbrev recieve receive

" quote a word
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
vnoremap <leader>" <esc>a"<esc>`<i"<esc>`>

" Another mapping for escape
inoremap jk <esc>
noremap ,p :execute "rightbelow vsplit ".bufname("#")<cr>

nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>
nnoremap <space> :silent execute "Ack! " . shellescape(expand("<cword>"))<cr> 

function! s:GrepOperator(type)
    let saved_unnamed_register = @@

    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    let @/ = @@
    silent execute "Ack! " . shellescape(@@) . " ."

    let @@ = saved_unnamed_register
endfunction

nnoremap <F7> :call SaveAndMake()

fun! SaveAndMake()
  :wa
  :make
endfun
