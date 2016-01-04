m4_include(env_config.m4)
" Function Keys
" -------------
" F2  - Toggle NERDTree
" F4  - Select buffer
" F5  - YCM Recompile and Regenerate diagnostics
" F6  - Generate ctags
" F7  - Python lint
" F8  - Toggle Tagbar
" F10 - Syntax Group under cursor
" F11 - Paste Mode
set shell=/bin/bash " Vim doesn't like fish

" Run :PluginInstall to install or update plugins managed by Vundle
set nocompatible
scriptencoding utf-8
set encoding=utf-8

" Vundle
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle. Required
Bundle 'gmarik/Vundle.vim'

" My bundles here:
Bundle 'adimit/prolog.vim'
Bundle 'airblade/vim-gitgutter'
Bundle 'altercation/vim-colors-solarized'
Bundle 'bkad/CamelCaseMotion'
Bundle 'bling/vim-airline'
Bundle 'chrisbra/Recover.vim'
Bundle 'christoomey/vim-tmux-navigator'
Bundle 'edkolev/tmuxline.vim'
Bundle 'EdTsft/python-mode'
Bundle 'EdTsft/vim-qrc'
Bundle 'jeaye/color_coded'
Bundle 'kien/ctrlp.vim'
Bundle 'Konfekt/FastFold'
Bundle 'lyuts/vim-rtags'
Bundle 'majutsushi/tagbar'
Bundle 'moll/vim-bbye'
Bundle 'morhetz/gruvbox'
Bundle 'ntpeters/vim-better-whitespace'
Bundle 'peterhoeg/vim-qml'
Bundle 'rdnetto/YCM-Generator'
Bundle 'scrooloose/nerdtree'
Bundle 'tmux-plugins/vim-tmux-focus-events'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-unimpaired'
Bundle 'Valloric/YouCompleteMe'
Bundle 'vim-scripts/fish-syntax'
Bundle 'vim-scripts/Smart-Tabs'
Bundle 'Xuyuanp/nerdtree-git-plugin'

" End Vundle
call vundle#end()

" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"" Custom Commands
" CommandCabbr enables arbitrary command abbreviations (including lower case)
function! CommandCabbr(abbreviation, expansion)
	execute 'cabbr ' . a:abbreviation . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:expansion . '" : "' . a:abbreviation . '"<CR>'
endfunction
command! -nargs=+ CommandCabbr call CommandCabbr(<f-args>)

" Reset the location list to default size (close it then re-open it)
command! Lresize lclose|lopen
CommandCabbr lresize Lresize
CommandCabbr lrs Lresize

" Filetype associations
au BufRead,BufNewFile *.mac setfiletype maxima
au BufRead,BufNewFile *.make setfiletype make
au BufRead,BufNewFile *.prototxt setfiletype yaml

syntax on " Syntax Highlighting
filetype plugin indent on

call camelcasemotion#CreateMotionMappings('<leader>')

let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_extra_conf_globlist = [ '~/.vim/.ycm_extra_conf.py', '~/Programming/*']
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_filetype_blacklist = {
      \ 'tagbar' : 1,
      \ 'qf' : 1,
      \ 'notes' : 1,
      \ 'markdown' : 1,
      \ 'unite' : 1,
      \ 'text' : 1,
      \ 'vimwiki' : 1,
      \ 'pandoc' : 1,
      \ 'infolog' : 1,
      \ 'mail' : 1,
      \ 'tex' : 1,
      \ 'rnoweb' : 1
      \}

if has('python3')
	" Disable YCM and rtabs when running with Python3 - They require Python2
	set runtimepath-=~/.vim/bundle/YouCompleteMe
	set runtimepath-=~/.vim/bundle/vim-rtags
	let g:pymode_rope_completion = 1
else
	let g:pymode_rope_completion = 0 " Disable Rope completion - competes with YCM
endif
let g:pymode_rope_goto_definition_cmd = 'e'
let g:pymode_lint_unmodified = 1 " Lint on write even when unmodified

m4_ifdef(??[[<<m4_env_config_USING_PYTHON3>>]]??,
" Run lint checks against Python3 code (by using python3 interpreter)
let g:pymode_lint_external_python = "m4_env_config_PYTHON"
)m4_dnl

let g:clighter_cursor_hl_default = 0 " Cursor highlighting is somewhat slow.

set modeline
set backspace=indent,eol,start

set autoindent
set cinoptions=(0,u0,U0 " Options to cindent (turned on automatically in c files)

set tabstop=2
set shiftwidth=2
set softtabstop=2
set noshiftround
set textwidth=80 " Auto wrap at 80 char line width
set formatoptions+=t " Auto-wrap text using textwidth
set formatoptions+=c " Auto-wrap comments using textwidth, inserting the
                     " current comment leader automatically.
set formatoptions+=r " Automatically insert the current comment leader after
                     " hitting <Enter> in Insert mode.
set formatoptions+=o " Automatically insert the comment leader after hitting 'o'
                     " or 'O' in Normal mode.
set formatoptions+=q " Allow formatting of comments with "gq"
set formatoptions+=l " Long lines are not broken in insert mode: When a line was
                     " longer than 'textwidth' when the insert command started,
                     " Vim does not automatically format it.
set formatoptions+=1 " Don't break a line after a one-letter word.  It's broken
                     " before it instead (if possible).
set formatoptions+=j " Where it makes sense, remove a comment leader when
                     " joining lines.

set showmatch

set number " Line Numbers
set hidden " When opening new files, keep old one in a buffer
set ruler " Column Numbers

set nohlsearch
set incsearch

set scrolloff=10

set laststatus=2 " Always show status line

set foldmethod=indent
set foldlevel=99

set background=dark
colorscheme desert
hi Normal ctermbg=NONE

" Set the highlighted column colour (grey)
highlight ColorColumn ctermbg=233 guibg=#121212
" Highlight columns after textwidth
let &colorcolumn=join(range((&textwidth + 1),999),",")

" Search for tags file first in cwd then recursively up to ~/Programming
set tags=./tags;~/Programming

" Display tabs as ⇥
set list
set listchars=tab:⇥\ ,
" And show them as dark grey
hi SpecialKey ctermfg=8

" Toggle paste
set pastetoggle=<F11>
" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

inoremap jk <Esc>

" Enable spell check on text files
autocmd BufNewFile,BufRead *.txt setlocal spell
" But not help files
autocmd FileType help setlocal nospell
set spelllang=en_ca

" Open spelling suggestions with <leader>s
:nnoremap \s ea<C-X><C-S>

" autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

set exrc    " Enable per-directory .vimrc files
set secure  " Disable unsafe commands in local .vimrc files

" For vim-latex
" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*
" Also for vim-latex
let &runtimepath.=',$VIM/vimfiles'

let g:tex_flavor = "latex" " Load .tex files as latex
let g:tex_conceal="abdmgtD" " t is custom s, D is double-strike

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
" Use git or mercurial to generate list of files if possible
let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'cd %s && git ls-files --cached --exclude-standard --others'],
    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
    \ },
  \ 'fallback': 'find %s -type f'
  \ }

" Toggle NERDTree
nnoremap <F2> :NERDTreeToggle<CR>

" Show list of buffers and select one by number
nnoremap <F4> :buffers<CR>:buffer<Space>

" Refresh YCM diagnostics on F5
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>

" Generate CTags
nnoremap <F6> :!echo 'Generating ctags' && ctags -R --fields=+ialsSfk --extra=+q --options=.ctags.conf --verbose .<CR>

" Python Lint
nnoremap <F7> :PymodeLint<CR>

" Toggle Tag Bar
nnoremap <F8> :TagbarToggle<CR>

" Syntax group under cursor"
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Buffer navigation with gb and gB
nnoremap gb :bnext<CR>
nnoremap gB :bprev<CR>

" Resize panes with ,. instead of <>
nnoremap <C-W>, <C-W><
nnoremap <C-W>. <C-W>>

" Saves the current file using sudo
cmap w!! w ! sudo tee > /dev/null %

" Use non-standard symbols for a better-looking airline.
" Requires installing the powerline fonts:
" https://powerline.readthedocs.org/en/master/installation.html#patched-fonts
let g:airline_powerline_fonts = 1

" Enable buffer display on airline
let g:airline#extensions#tabline#enabled = 1

" Set the airline theme
let g:airline_theme = 'wombat'

" Check trailing whitespace with airline (but not mixed tabs/spaces)
let g:airline#extensions#whitespace#checks = ['trailing']

let NERDTreeIgnore = [
	\'\.pyc$',
	\'\.egg-info',
	\'__pycache__',
	\]

" Don't update the NERDTree git flags (nerdtree-git-plugin) on write.
" The update interferes with python-mode's lint-on-write.
let NERDTreeUpdateOnWrite=0

autocmd Filetype
	\ c,
	\cpp,
	\html,
	\java,
	\php,
	\python,
	\qml,
	\ruby,
	\xml
	\ autocmd BufWritePre <buffer> StripWhitespace
