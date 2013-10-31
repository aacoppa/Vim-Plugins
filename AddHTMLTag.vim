"For html auto completion
inoremap > <Esc>:call AddEndTag()<CR>a
inoremap /> >

"Complete tab function
function! AddEndTag()
    if(&ft == 'html')
        let line = getline(".")
        let start = getpos(".")[2] - 1
        let i = start
        "let words = split(line)
        "let latest = words[len(words) - 1]
        "let i = len(latest) - 1
        "let last = 0
        while(i >= 0)
            if(line[i] == " ")
                let start = i - 1
            endif
            if(line[i] == "<")
                if(line[i+1] == "/")
                    :execute ":normal a/>"
                    :return
                else
                    let b = strpart(line, i+1, start - i)
                    execute "normal! a> </"
                    execute "normal! a\<C-R>=b\<CR>"
                    execute "normal! a>\<esc>bhhi\<BS>\<esc>"
                    "\<esc>ba\<esc>bha"
                   " echo str
                   break
                endif
            endif
            let i = i - 1
            
        endwhile
        if(i < 0)
            :execute ":normal! a>"
        endif
    else
        :execute "normal! a>"
    endif
endfunction


