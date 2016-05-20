if !has("python")
    finish
endif

function! PrettyJSON()
    let content = join(getline(1, '$'), "\n")

    if !exists("g:pretty_json_indent")
        let g:pretty_json_indent = 4
    endif

    if !exists("g:pretty_json_sort_keys")
        let g:pretty_json_sort_keys = 1
    endif

python << EOF
import vim
import json

def main():
    indent = int(vim.eval("g:pretty_json_indent"))
    sort_keys = int(vim.eval("g:pretty_json_sort_keys"))
    try:
        content = json.loads(vim.eval('content'))
    except (TypeError, ValueError) as e:
        vim.command("echoe 'JSON Format Error: %s'" % e.message)
        return

    result = json.dumps(content, ensure_ascii=True, indent=indent, 
                        sort_keys=sort_keys == 1)

    for ln, line in enumerate(result.splitlines()):
        vim.command("call setline(%s, '%s')" % (ln + 1, line))

main()
EOF
endfunction

nmap <Leader>pj :call PrettyJSON()<cr>
