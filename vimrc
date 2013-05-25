call pathogen#infect()


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

nmap <D-j> <C-w><C-w>
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

map <D-up> :vertical resize +5<cr>
map <C-down> :vertical resize -5<cr>

set background=light
"colorscheme inkpot
colorscheme pyte

map <D-e> <C-e>

" Remove trailing whitespace, remember leader x is for replace
map <leader>xs :%s/\s\+$//<CR>

" Ruby debugging
let g:ruby_debugger_progname = 'mvim'

"neocomplcache
let g:neocomplcache_enable_at_startup = 1
let g:ackprg="ack -i -H --nocolor --nogroup --column"
" minibufexplorer
let g:miniBufExplMapCTabSwitchBufs = 1

"powerline
let g:Powerline_symbols = 'fancy'
set laststatus=2

"pig
augroup filetypedetect 
  au BufNewFile,BufRead *.pig set filetype=pig syntax=pig 
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


" Ctrlp mappings
noremap <leader>b :CtrlPBuffer<CR>
noremap <leader>m :CtrlPMRU<CR>

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
inoremap <expr> ( ConditionalPairMap('(', ')', 0)
inoremap <expr> { ConditionalPairMap('{', '}', 0)
inoremap <expr> [ ConditionalPairMap('[', ']', 0)
inoremap <expr> (<cr> ConditionalPairMap('(', ')', 1)
inoremap <expr> {<cr> ConditionalPairMap('{', '}', 1)
inoremap <expr> [<cr> ConditionalPairMap('[', ']', 1)

inoremap " ""<Left>

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
