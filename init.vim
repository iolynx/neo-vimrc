cd D:/code/
set encoding=UTF-8
set foldmethod=indent
set signcolumn=yes
set mouse=a
set tabstop=4 softtabstop=4
set completeopt=menuone,noselect
set nocompatible
set shiftwidth=4
set expandtab
set smartindent
set nowrap
set exrc
set relativenumber
"set guicursor=i:hor50-n-ciCursor-blinkwait300-blinkon200-blinkoff150
"set guicursor=i:hor25-iCursor
set nu
set nohlsearch
set hidden
set noerrorbells
set smartcase
"set ignorecase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set noshowmode
set signcolumn=yes
set guifont=Ubuntumono\ NF:h19
set linespace=0
set t_md=
set shortmess+=c 
set updatetime=300
set splitbelow
"set guicursor=n-v-c:block-Cursor

"set clipboard=unnamedplus
set clipboard=
autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE

let g:gruvbox_transparent_bg = 1
let g:coc_disable_uncaught_error = 1
let g:airline_powerline_fonts = 1
let g:node_client_debug = 1
let delimitMate_expand_cr = 1
filetype indent plugin on 
filetype plugin on


"--------------------------------- P L U G I N S ------------------------------
call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'nvim-lua/popup.nvim'
Plug 'kabouzeid/nvim-lspinstall'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'gruvbox-community/gruvbox'
Plug 'nvim-treesitter/playground'

Plug 'neoclide/coc.nvim', {'branch' : 'release'}
"Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}

Plug 'voldikss/vim-floaterm'

Plug 'Raimondi/delimitMate'
Plug 'mhinz/vim-startify'
Plug 'preservim/nerdtree'
Plug 'karb94/neoscroll.nvim'
Plug 'kyazdani42/nvim-web-devicons' " Recommended (for coloured icons)
Plug 'ryanoasis/vim-devicons'
Plug 'akinsho/nvim-bufferline.lua'
Plug 'easymotion/vim-easymotion'
Plug 'preservim/nerdcommenter'
"Plug 'nikvdp/neomux'
Plug 'tpope/vim-dispatch'
Plug 'gelguy/wilder.nvim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()


colorscheme gruvbox

let mapleader=" "
nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep for > ")})<CR>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
noremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <C-n> :tabnew<CR>
nnoremap <A-k> <C-^><CR>
nnoremap <A-l> :bd!<CR>


"- - - - - - - compile and run - - - - - - - 
"autocmd filetype cpp nnoremap <A-j> :w <bar> :term g++ -std=c++11 -O2 -Wall % -o %:r && %:r.exe<CR>
"autocmd filetype python nnoremap <A-j> <Esc>:w<CR>:terminal python %<CR>
autocmd filetype cpp nnoremap <A-j> <Esc>:w<CR>:!g++ -g % -o %:r<CR>:vert term %:r<CR>i
autocmd filetype cpp nnoremap <F7> <Esc>:w<CR>:!g++ -g % -o %:r && %:r <CR>
autocmd filetype python nnoremap <A-j> <Esc>:w<CR>:FloatermNew python %<CR>
autocmd filetype python nnoremap <A-s> <Esc>:w<CR>:FloatermNew --silent python %<CR>
nnoremap <A-m> :FloatermToggle<CR>
noremap <A-,> :FloatermPrev<CR>
noremap <A-.> :FloatermNext<CR>


" Bind F5 to save file if modified and execute python script in a buffer.
nnoremap <silent> <F5> :call SaveAndExecutePython()<CR>
vnoremap <silent> <F5> :<C-u>call SaveAndExecutePython()<CR>

function! SaveAndExecutePython()
    " SOURCE [reusable window]: https://github.com/fatih/vim-go/blob/master/autoload/go/ui.vim

    " save and reload current file
    silent execute "update | edit"

    " get file path of current file
    let s:current_buffer_file_path = expand("%")

    let s:output_buffer_name = "Python"
    let s:output_buffer_filetype = "output"

    " reuse existing buffer window if it exists otherwise create a new one
    if !exists("s:buf_nr") || !bufexists(s:buf_nr)
        silent execute 'botright new ' . s:output_buffer_name
        let s:buf_nr = bufnr('%')
    elseif bufwinnr(s:buf_nr) == -1
        silent execute 'botright new'
        silent execute s:buf_nr . 'buffer'
    elseif bufwinnr(s:buf_nr) != bufwinnr('%')
        silent execute bufwinnr(s:buf_nr) . 'wincmd w'
    endif

    silent execute "setlocal filetype=" . s:output_buffer_filetype
    setlocal bufhidden=delete
    setlocal buftype=nofile
    setlocal noswapfile
    setlocal nobuflisted
    setlocal winfixheight
    setlocal cursorline " make it easy to distinguish
    setlocal nonumber
    setlocal norelativenumber
    setlocal showbreak=""

    " clear the buffer
    setlocal noreadonly
    setlocal modifiable
    %delete _

    " add the console output
    silent execute ".!python " . shellescape(s:current_buffer_file_path, 1)

    " resize window to content length
    " Note: This is annoying because if you print a lot of lines then your code buffer is forced to a height of one line every time you run this function.
    "       However without this line the buffer starts off as a default size and if you resize the buffer then it keeps that custom size after repeated runs of this function.
    "       But if you close the output buffer then it returns to using the default size when its recreated
    "execute 'resize' . line('$')

    " make the buffer non modifiable
    setlocal readonly
    setlocal nomodifiable
endfunction

vnoremap Y "+yy
nnoremap P "+p
imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<Plug>delimitMateCR"

" These commands will navigate through buffers in order regardless of which mode you are using
" e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
nnoremap <leader>l :BufferLineCycleNext<CR>
nnoremap <leader>h :BufferLineCyclePrev<CR>

" These commands will move the current buffer backwards or forwards in the bufferline
nnoremap <silent><mymap> :BufferLineMoveNext<CR>
nnoremap <silent><mymap> :BufferLineMovePrev<CR>

" These commands will sort buffers by directory, language, or a custom criteria
nnoremap <silent>be :BufferLineSortByExtension<CR>
nnoremap <silent>bd :BufferLineSortByDirectory<CR>
nnoremap <silent><mymap> :lua require'bufferline'.sort_buffers_by(function (buf_a, buf_b) return buf_a.id < buf_b.id end)<CR>


source $HOME\appdata\local\nvim\plug-config\nerdtree.vim
source $HOME\appdata\local\nvim\plug-config\coc.vim 
source $HOME\appdata\local\nvim\plug-config\start-screen.vim


"if has('nvim')
"    tnoremap <Esc> <C-\><C-n>
"    au TermOpen  * setlocal nonumber | startinsert
"    au TermClose * setlocal   number | call feedkeys("\<C-\>\<C-n>")
"endif

inoremap <silent><expr> <c-space> coc#refresh()
"inoremap jj <Esc>  
inoremap jk <Esc>l

"lua require("coq")

lua require("bufferline").setup{}
lua require'nvim-treesitter.configs'.setup { highlight = {enable = true} }
lua require('neoscroll').setup()
lua require ('telescope').load_extension('fzy_native')

"call dein#add('voldikss/vim-floaterm')
call wilder#enable_cmdline_enter()
set wildcharm=<Tab>
cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"
cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"

" only / and ? are enabled by default
call wilder#set_option('modes', ['/', '?', ':'])

" use wilder#wildmenu_lightline_theme() if using Lightline
" 'highlights' : can be overriden, see :h wilder#wildmenu_renderer()
" 'highlighter' : applies highlighting to the candidates

call wilder#set_option('renderer', wilder#popupmenu_renderer({
      \ 'highlighter': wilder#basic_highlighter(),
      \ 'left': [
      \   wilder#popupmenu_devicons(),
      \ ],
      \ }))
" For Neovim only
" For wild#cmdline_pipeline():
"   'language'   : set to 'python' to use python
"   'fuzzy'      : set fuzzy searching
" For wild#python_search_pipeline():
"   'pattern'    : can be set to wilder#python_fuzzy_delimiter_pattern() for stricter fuzzy matching
"   'sorter'     : omit to get results in the order they appear in the buffer
"   'engine'     : can be set to 're2' for performance, requires pyre2 to be installed
call wilder#set_option('pipeline', [
      \   wilder#branch(
      \     wilder#cmdline_pipeline({
      \       'language': 'python',
      \       'fuzzy': 1,
      \     }),
      \     wilder#python_search_pipeline({
      \       'pattern': wilder#python_fuzzy_pattern(),
      \       'sorter': wilder#python_difflib_sorter(),
      \       'engine': 're',
      \     }),
      \   ),
      \ ])


"-------------------------------------------------------------------------
" Terminal Function
let g:term_buf = 0
let g:term_win = 0
function! TermToggle(height)
    if win_gotoid(g:term_win)
        hide
    else
        botright new
        exec "resize " . a:height
        try
            exec "buffer " . g:term_buf
        catch
            call termopen($SHELL, {"detach": 0})
            let g:term_buf = bufnr("")
            set nonumber
            set norelativenumber
            set signcolumn=no
        endtry
        startinsert!
        let g:term_win = win_getid()
    endif
endfunction
"
" Toggle terminal on/off (neovim)
nnoremap <A-t> :call TermToggle(12)<CR>
inoremap <A-t> <Esc>:call TermToggle(12)<CR>
tnoremap <A-t> <C-\><C-n>:call TermToggle(12)<CR>

" Terminal go back to normal mode
tnoremap <Esc> <C-\><C-n>
tnoremap :q! <C-\><C-n>:q!<CR>
