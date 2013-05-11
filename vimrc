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
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

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
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}
