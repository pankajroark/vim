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
  autocmd bufwritepost .gvimrc source $MYGVIMRC
endif

nmap <leader>v :tabedit $MYGVIMRC<CR>
nmap <C-S-c> :s/^/#/<CR>j

map <D-up> :vertical resize +5<cr>
map <C-down> :vertical resize -5<cr>

set background=light
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
  set fuoptions=maxvert,maxhorz
  au GUIEnter * set fullscreen
endif

"CloseMiniBufExplorer by default
map <F7> :TMiniBufExplorer<CR>
