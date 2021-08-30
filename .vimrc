execute pathogen#infect()
let g:ycm_max_diagnostics_to_display=0
:let g:python3_host_prog='/usr/bin/python3'
:let g:python_host_prog='/usr/bin/python'
:let g:ycm_server_python_interpreter='/usr/bin/python3'
if !exists("g:ycm_semantic_triggers") | let g:ycm_semantic_triggers = {} | endif
:let g:ycm_semantic_triggers['javascript.jsx'] = ['.']
let g:ycm_python_interpreter_path = '/usr/bin'
let g:ycm_python_sys_path = []
let g:ycm_extra_conf_vim_data = [
  \  'g:ycm_python_interpreter_path',
  \  'g:ycm_python_sys_path'
  \]
let g:ycm_global_ycm_extra_conf = '~/global_extra_conf.py'
:set switchbuf=usetab
let g:CommandTAcceptSelectionCommand = 'CommandTOpen vs'
:set completeopt-=preview
:set dir=$HOME/.vim/tmp/swap
if !isdirectory(&dir) | call mkdir(&dir, 'p', 0700) | endif
:set foldmethod=indent
:set tabstop=2
:set softtabstop=2
:set shiftwidth=2
:set expandtab
:set number relativenumber
:set signcolumn=yes
:set cursorline
:set winwidth=80
:set winminwidth=10
:set winheight=29
:set wildignore+=*/node_modules/*
:map <up> :echoerr "use K"<CR>
:map <down> :echoerr "use J"<CR>
:map <left> :echoerr "use H"<CR>
:map <right> :echoerr "use L"<CR>
:noremap <C-]> :YcmCompleter GoToDeclaration<CR>
:noremap <C-\> :YcmCompleter GoToReferences<CR>
:noremap <C-g> :YcmShowDetailedDiagnostic<CR>
:noremap <C-p> :CommandT<CR>
:inoremap <tab> <c-x><c-o>
:inoremap <silent> <Up> <ESC><Up>
:inoremap <silent> <Down> <ESC><Down>
:inoremap <A-h> <C-o>h
:inoremap <A-j> <C-o>j
:inoremap <A-k> <C-o>k
:inoremap <A-l> <C-o>l
:set autoindent
:colorscheme xoria256
:syntax on
:set splitbelow
:set splitright
:set diffopt=vertical
:set conceallevel=1
:set mouse=a
":let &colorcolumn=join(range(81,999),",")
:highlight ColorColumn ctermbg=235 guibg=#2c2d27
call pathogen#helptags()
