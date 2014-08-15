syntax on
filetype plugin indent on

" Load NerdTree by default
"autocmd vimenter * NERDTree

" This has been remapped to jump to definition
"noremap <D-j> <C-w><C-w>
noremap <D-j> :ScalaJump<CR>
noremap <D-k> :ScalaProjFind<CR>
" This has been remapped for easy motion
"noremap <D-k> <C-w>p

" Source the gvimrc file after saving it
augroup GVimrcReload
  autocmd!
  autocmd bufwritepost .gvimrc source $MYGVIMRC
augroup END

noremap <leader>xt :tabedit ~/Dropbox/pankaj/docs/techie/lists/todo<CR>
noremap <leader>xy :tabedit ~/Dropbox/pankaj/docs/techie/lists/scratch<CR>
noremap <leader>k :tabedit $HOME/Dropbox/pankaj/funda<CR>

set macmeta

map <C-l> :vertical resize +5<cr>
map <C-h> :vertical resize -5<cr>

" set background=dark
" colorscheme inkpot

map <D-e> <C-e>

" Ruby debugging
let g:ruby_debugger_progname = 'mvim'

"macvim fullscreen
if has("gui_running")
  "set fuoptions=maxvert,maxhorz
  "au GUIEnter * set fullscreen
endif

"CloseMiniBufExplorer by default
"map <F7> :TMiniBufExplorer<CR>

" Set a large font
set guifont=Menlo\ Regular:h17

" Command - T helpers
function! Git_Root() " Get the relative path to repo root
    "Ask git for the root of the git repo (as a relative '../../' path)
    let git_top = system('git rev-parse --show-cdup')
    let git_fail = 'fatal: Not a git repository'
    if strpart(git_top, 0, strlen(git_fail)) == git_fail
        " Above line says we are not in git repo. Ugly. Better version?
        return ''
    else
        " Return the cdup path to the root. If already in root,
        " path will be empty, so add './'
        " Also remove newline at the end
        return './' . strpart(git_top, 0, strlen(git_top) - 1)
    endif
endfunction

function! CD_Git_Root()
    execute 'cd '.Git_Root()
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

" set dictionary
set dictionary +=~/.vim/dict

" map semicolon to enter
" inoremap <C-;> <cr>
" map shift enter in command mode to adding a new line
map <S-Enter> O<Esc>
map <CR> o<Esc>

" note that command 0 is still available for future
noremap <D-1> :tabn 1<cr>
noremap <D-2> :tabn 2<cr>
noremap <D-3> :tabn 3<cr>
noremap <D-4> :tabn 4<cr>
noremap <D-5> :tabn 5<cr>
noremap <D-6> :tabn 6<cr>
noremap <D-7> :tabn 7<cr>
noremap <D-8> :tabn 8<cr>
noremap <D-9> :tablast<cr>


" move line around
nnoremap - ddp
nnoremap _ ddkP

" correct receive
iabbrev recieve receive

" Open other buffer in a vertical split
noremap ,p :execute "rightbelow vsplit ".bufname("#")<cr>

"nnoremap <F7> :call SaveAndMake()

fun! SaveAndMake()
  :wa
  :make
endfun

nnoremap <leader>q :call QuickfixToggle()<cr>

let g:quickfix_is_open = 0

function! QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
    else
        copen
        let g:quickfix_is_open = 1
    endif
endfunction

fun! OpenReadme()
  execute 'tabedit '.Git_Root().'/README'
endfun

nnoremap <leader>r :call OpenReadme()<cr>
"Yankring
nnoremap <silent> <C-space> :YRShow<CR>

" disable toolbar, don't need it
if has("gui_running")
    set guioptions=egmrt
endif

set transparency=2

function! CGitPathToClipBoard()
  let a:cur_path = expand('%:p')
  let git_root_abs_path = substitute(system('git rev-parse --show-toplevel'), '\n$', "", "")
  let file_relative_path = substitute(a:cur_path, git_root_abs_path, "", "")
  let remote_repo = system('git remote -v | head -n 1 | awk ''{ print $2 }'' | sed ''s/git/cgit/''')
  let repo = substitute(remote_repo, '\n$', "", "")
  let a:cg_path = repo."/tree".file_relative_path."#n".line('.')
  let @* = a:cg_path
  echo a:cg_path
endfunction

nnoremap <F7> :call CGitPathToClipBoard()<cr>

" Easy motion  + colors
map <C-j> <Plug>(easymotion-W)
map <C-k> <Plug>(easymotion-B)

hi link EasyMotionTarget ErrorMsg
hi link EasyMotionShade  Comment

hi link EasyMotionTarget2First ErrorMsg
hi link EasyMotionTarget2Second Function
hi Search guibg=peru guifg=wheat

" modify selected text using combining diacritics
command! StrikeThrough   call s:StrikeT()

function! s:StrikeT()
  execute 's/\v(.)/\1-/g'
  execute 's/-$//'
endfunction

nnoremap <leader>s :StrikeThrough<CR>
