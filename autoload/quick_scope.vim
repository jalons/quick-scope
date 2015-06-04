let s:primary_color = 081
let s:secondary_color = 050

let s:curr_lnum = line('.')
let s:prev_lnum = s:curr_lnum
let s:line = getline(s:curr_lnum)

" let s:group_names = [
"     'QuickScopePrimary',
"     'QuickScopeSecondary'
" ]

" Helper functions
function! s:set_color(group, attr, color)
    let term = has('gui_running') ? 'gui' : 'cterm'

    execute printf("highlight %s %s%s=%s", a:group, term, a:attr, a:color)
endfunction

" Get a list of unique searchable characters from a string.
function! s:get_unique_chars(str)
    " Remove whitespace
    let str = substitute(a:str, "\s", "", 'g')

    " Get all unique characters in string as keys in a dict
    let unique = {}
    let i = 0
    let len = strlen(str)
    while i < len
        let unique[str[i]] = ''
        let i += 1
    endwhile

    return keys(unique)
endfunction

" Main functions
function! s:highlight_line()
    let s:curr_lnum = line('.')

    if s:curr_lnum == s:prev_lnum
        echo 'same line'
    else
        let s:prev_lnum = s:curr_lnum
        let s:line = getline(s:curr_lnum)

        " Get cursor position, zero-indexed
        let pos = col('.') - 1

        " Get bufline before cursor, exclusive; guard against when cursor is at
        " beginning of line
        let before = s:line[: (pos == 0 ? 0 : pos - 1)]

        " Get bufline after cursor, exclusive; guard against when cursor is at
        " end of line
        let after = s:line[(pos == len(s:line) - 1 ? pos : pos + 1) :]

        echo s:get_unique_chars(after)
    endif

    " If leaving insert mode reconstruct line
    " If on line don't reconstruct line
    " When moving new lines, reconstruct line
    " Mark first occurence of each letter.
    " let pattern = '\v%' . line('.') . 'l' . '
    "
    " :h search-range
endfunction

function! s:unhighlight_line()
    " Do nothing for now.
endfunction

" Autoload
augroup quick_scope
    autocmd!
    autocmd CursorMoved,InsertLeave,ColorScheme * call s:highlight_line()
    autocmd InsertEnter * call s:unhighlight_line()
augroup END
