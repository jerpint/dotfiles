set nocompatible

set incsearch "Highlight searches while typing
set nowrap "Dont wrap
set ic "default to case insensitive search
set hlsearch " highlight words on search


set splitright " open to the right
set number relativenumber " set line number and relative line number
set ts=4 " set tabs to have 4 spaces
set autoindent " indent when moving to the next line while writing code
set expandtab " expand tabs into spaces
set shiftwidth=4 " when using the >> or << commands, shift lines by 4 spaces
set cursorline " show a visual line under the cursor's current line
set updatetime=100
set showmatch " show the matching part of the pair for [] {} and ()
set backspace=indent,eol,start
set clipboard=unnamedplus " Copy to system register:
set mouse=a


" navigate wrapped lines
nnoremap j gj
nnoremap k gk

" Remap :W to :w
:command WQ wq
:command Wq wq
:command W w
:command Q q

"Macro for debugging in ipython
let @o = 'ofrom IPython import embed; embed(colors="neutral");'
let @p = 'oimport ipdb; ipdb.set_trace();'

syntax on
syntax enable

" Termguicolors
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
set t_Co=256

" .py specific settings
au BufNewFile,BufRead,BufWritePre *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=120 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
au BufWritePre *.py,*.*rc %s/\s\+$//e
let g:python_highlight_all = 1 " enable all Python syntax highlighting features

" PLUGINS


"Download Plug if it doesn't exist
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin()
Plug 'https://github.com/joshdick/onedark.vim.git'
Plug 'sonph/onehalf', { 'rtp': 'vim'}
Plug 'arcticicestudio/nord-vim'
Plug 'ryanoasis/vim-devicons'
Plug 'christoomey/vim-tmux-navigator'
Plug 'scrooloose/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'mhinz/vim-startify'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-python/python-syntax'
Plug 'https://github.com/simnalamburt/vim-mundo'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'jreybert/vimagit'
Plug 'bluz71/vim-nightfly-guicolors'
call plug#end()

nmap <C-n> :noh <CR> " undo highlight

" COLORSCHEME
colorscheme nightfly
function! BgToggleSol()
    " use leader-D to toggle light and dark mode
    if (&background == "light")
      colorscheme nord
    else
      colorscheme nightfly
    endif
endfunction
nnoremap <silent> <leader>d :call BgToggleSol()<cr>


" Mundo: Enable persistent undo so that undo history persists across vim sessions
set undofile
set undodir=~/.vim/undo
nnoremap <F5> :MundoToggle<CR>

" navigate splits
" (for tmux you also have to install a plugin, see: https://github.com/christoomey/vim-tmux-navigator
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>



"NerdCommenter
"Toggle comment
map <C-_> <plug>NERDCommenterToggle

" Create default mappings
let g:NERDCreateDefaultMappings = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1


" nerdtree
nnoremap <C-[>n <plug>NERDTreeTabsToggle<CR>
nnoremap <space> :NERDTreeToggle<CR>
nnoremap <C-n> :noh <CR> " undo highlight - needs to be reset because it was overridden
