set shiftwidth=4
set softtabstop=4
set tabstop=4
syntax enable
set smarttab
set cindent
set cinoptions={.5s,+.5s,t0,n-2,p2s,(03s,=.5s,>1s,=1s,:1s
set smartindent
set autoindent
set ignorecase
set incsearch
set smartcase
set showmatch
set wrapscan
set showmatch
set hlsearch
"set viminfo="NONE"
set expandtab
set ruler
set pastetoggle=<F9>
nnoremap <CR> :noh<CR> 
"Disable beep
set vb
"set paste

set so=30
" set cursorline
" arrow keys move via screen lines instead of logical lines
imap <silent> <Down> <C-o>gj
imap <silent> <Up> <C-o>gk
nmap <silent> <Down> gj
nmap <silent> <Up> gk
" move the current line up or down
nmap <silent> <C-j> :m+<CR>
nmap <silent> <C-k> :m-2<CR>
imap <silent> <C-j> <C-O>:m+<CR><C-O>
imap <silent> <C-k> <C-O>:m-2<CR><C-O>
" move the selected block up or down
vmap <silent> <C-j> :m'>+<CR>gv=gv
vmap <silent> <C-k> :m'<-2<CR>gv=gv


"jump to last position
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
"augroup xiphias
"	autocmd!
"	au BufRead *.xml so /home/mwoodson/.vim/maps_r3.vim
"	au BufRead *.xml so /home/mwoodson/.vim/import.vim
"	au BufRead *.xml so /home/mwoodson/.vim/make.vim
"	map <F12> vat<Esc>`<df>`>F<df>
"augroup END

set laststatus=2
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]

ab shapy #!/usr/bin/env python<CR>
ab sharb #!/usr/bin/env ruby<CR>

highlight ExtraWhitespace ctermbg=red guibg=red
augroup WhitespaceMatch
  " Remove ALL autocommands for the WhitespaceMatch group.
  autocmd!
  autocmd BufWinEnter * let w:whitespace_match_number =
        \ matchadd('ExtraWhitespace', '\s\+$')
  autocmd InsertEnter * call s:ToggleWhitespaceMatch('i')
  autocmd InsertLeave * call s:ToggleWhitespaceMatch('n')
augroup END
function! s:ToggleWhitespaceMatch(mode)
  let pattern = (a:mode == 'i') ? '\s\+\%#\@<!$' : '\s\+$'
  if exists('w:whitespace_match_number')
    call matchdelete(w:whitespace_match_number)
    call matchadd('ExtraWhitespace', pattern, 10, w:whitespace_match_number)
  else
    " Something went wrong, try to be graceful.
    let w:whitespace_match_number =  matchadd('ExtraWhitespace', pattern)
  endif
endfunction
