map <C-F> :call ListFunctions()<CR>

"List the functions in our file!
function! ListFunctions()
    let options= GetKeywords()
    let lines=getline(0, 1000000)
    let funcs =  []
    let lineNums = []
    let lNum = 0
    for line in lines
        let i = 0
        let invalid = 0
        while i < len(options)
            try
                let j = 0
                while j < len(options[i])
                    if(len(options[i][j]) > 1)
                        if line =~ options[i][j]
                            let invalid = 1
                            break
                        endif
                    else 
                        throw "We should be in catch..."
                    endif
                    let j = j + 1
                endwhile
            catch
                if line =~ options[i]
                else
                    let invalid=1
                endif
            endtry
            let i = i + 1
        endwhile
        if(invalid == 1 || ReturnCommentExists(lNum + 1) == 1 )
        else
            let funcs = add(funcs, line)
            let lineNums = add(lineNums, lNum + 1)
        endif
        let lNum = lNum + 1
    endfor
    let i = 0
    silent !clear
    for f in funcs
        echo (i + 1) . ": " . f
        let i = i + 1
    endfor
    let num = input("Choose a function: ")
    try
        if num > 0
            :call setpos(".", [0, lineNums[num - 1], 10000, 0])
        endif
    catch

    endtry
    redraw!
endfunction

"Make sure the function isn't commented out
function! ReturnCommentExists(lNum)
    let currLine = getline(a:lNum)
    let words = split(currLine)
    let firstChar = 'a'
    if(len(words) < 1)
        let firstChar = 'a'
    else
        let i = 1
            let firstChar = words[0]
            while(firstChar == '\s' || firstChar == '\t')
                if(len(words) < i)
                    let firstChar = 'a'
                else
                    let firstChar = words[i]
                endif
                 let i = i + 1
             endwhile
    endif
    if(len(firstChar > 1)) 
        let firstChar = firstChar[0]
    endif
    if(&ft == 'c' || &ft == 'java' || &ft == 'cpp' || &ft == 'processing')
        if(firstChar != "/") 
            return 0
        else 
            return 1
        endif
    elseif(&ft == "vim")
        if(firstChar != '"')
            return 0
        else
            return 1
        endif
    else
        if(firstChar != '#') 
            return 0
        else 
            return 1
        endif
    endif
    return 1
endfunction

"Get keywords for function finding...
function! GetKeywords()
    if(&ft == "vim")    
        let keywords = ['function!', '(', ')']
    elseif(&ft == "c" || &ft == "java") 
        let options = ['if', 'for', 'while', 'try', 'switch', 'catch'] 
        let keywords = [options, '(', ')', '{']
    elseif(&ft == "python")
        let keywords = ['def', '(', '):']
    endif
    return keywords
endfunction

