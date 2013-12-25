# name: danieljaouen
# __user ------------------------------------------------------------------ {{{
function __user
    set_color --bold red
    set_color --background black
    echo -n (whoami)
end
# /__user ----------------------------------------------------------------- }}}

# __hostname -------------------------------------------------------------- {{{
function __hostname
    set_color normal
    set_color magenta
    set_color --background black
    echo -n (hostname -s)
end
# /__hostname ------------------------------------------------------------- }}}

# __collapsed_pwd --------------------------------------------------------- {{{
function __collapsed_pwd
    set_color cyan
    set_color --background black
    echo -n (pwd | sed -e "s,^$HOME,~,g")
end
# /__collapsed_pwd -------------------------------------------------------- }}}

# __first_line ------------------------------------------------------------ {{{
function __first_line
    echo
    set_color normal
    set_color --bold green
    set_color --background black
    echo -n "["

    __user

    set_color --bold green
    echo -n "@"

    __hostname

    set_color --bold green
    set_color --background black
    echo -n "] "

    set_color normal
    set_color --bold green
    set_color --background black
    echo -n "["
    set_color normal
    set_color --background black
    echo -n "pwd: "

    __collapsed_pwd

    set_color --bold green
    echo -n "]"
    echo
end
# /__first_line ----------------------------------------------------------- }}}

# __git_prompt_info ------------------------------------------------------- {{{
function __git_prompt_info
    # current branch ----------------------------------------------- {{{
    set --local git_branch (command git symbolic-ref HEAD ^/dev/null)
    or set --local git_branch (command git rev-parse --short HEAD ^/dev/null)
    or return

    set --local git_branch (echo $git_branch | sed -e 's,^refs/heads/,,g')
    # /current branch ---------------------------------------------- }}}

    # prefix ------------------------------------------------------- {{{
    set_color normal
    set_color --bold green
    set_color --background black
    echo -n "["
    set_color normal
    set_color --background black
    echo -n "git: "
    set_color normal
    set_color blue
    set_color --background black
    # /prefix ------------------------------------------------------ }}}

    # the prompt --------------------------------------------------- {{{
    echo -n $git_branch
    # if [ (command git status ^/dev/null | tail -n1 | grep -v "nothing to commit" | grep -v "untracked files present") ]
    git status --porcelain -b ^/dev/null | grep -E '^\s*M ' >/dev/null ^/dev/null
    and set_color --bold red
    and echo -n "!"

    git status --porcelain -b ^/dev/null | grep -E '^\?\? ' >/dev/null ^/dev/null
    and set_color --bold red
    and echo -n "?"

    set_color --bold green
    set_color --background black
    echo -n "]"
    # /the prompt -------------------------------------------------- }}}

    # suffix ------------------------------------------------------- {{{
    set_color --bold green
    # /suffix ------------------------------------------------------ }}}
end
# /__git_prompt_info ------------------------------------------------------ }}}

# __hg_prompt_info -------------------------------------------------------- {{{
function __hg_prompt_info
    if [ ! (hg id ^/dev/null) ]
        return
    end

    # current branch ----------------------------------------------- {{{
    set --local hg_branch (command hg branch ^/dev/null)
    set --local hg_tags (command hg id ^/dev/null| cut -d' ' -f2 | sed -e 's|/|, |g')
    set --local hg_patches_applied (command hg qapplied ^/dev/null)
    set --local hg_patches_unapplied (command hg qunapplied ^/dev/null)
    # /current branch ---------------------------------------------- }}}

    # prefix ------------------------------------------------------- {{{
    set_color normal
    set_color --bold green
    set_color --background black
    echo -n "["
    set_color normal
    set_color --background black
    echo -n "hg: "
    # /prefix ------------------------------------------------------ }}}

    # the prompt --------------------------------------------------- {{{
    set_color normal
    set_color blue
    set_color --background black
    echo -n "$hg_branch"

    hg status ^/dev/null | grep -E '^M ' >/dev/null ^/dev/null
    and set_color --bold red
    and echo -n "!"

    hg status ^/dev/null | grep -E '^\? ' >/dev/null ^/dev/null
    and set_color --bold red
    and echo -n "?"

    set_color --background black
    echo -n ' '
    set_color normal
    set_color magenta
    set_color --background black
    echo -n "$hg_tags"
    set_color normal
    set_color --bold green
    set_color --background black
    echo -n "]"

    if [ -z "$hg_patches_applied" -a -z "$hg_patches_unapplied" ]
        return
    end

    echo
    echo -n "["
    set_color normal
    set_color --background black
    echo -n "hg-patches: "

    set --local hg_patches_applied (echo $hg_patches_applied | sed -e "s,\n, ,g")
    set --local hg_patches_unapplied (echo $hg_patches_unapplied | sed -e "s,\n, ,g")

    if [ -n "$hg_patches_applied" ]
        set_color yellow
        set_color --background black
        echo -n $hg_patches_applied

        if [ -n "$hg_patches_unapplied" ]
            echo -n ' '
        end
    end

    if [ -n "$hg_patches_unapplied" ]
        set_color --bold green
        set_color --background black
        echo -n $hg_patches_unapplied
    end

    set_color normal
    set_color --background black
    echo -n "]"
    # /the prompt -------------------------------------------------- }}}
    set_color --bold green
    set_color --background black
end
# /__hg_prompt_info ------------------------------------------------------- }}}

# __pyenv_info ------------------------------------------------------------ {{{
function __pyenv_info
    set --local pyenv_local (pyenv local ^/dev/null)
    set --local pyenv_global (pyenv global ^/dev/null)
    set_color normal
    set_color --bold green
    set_color --background black
    echo -n '['
    set_color normal
    set_color --background black
    echo -n 'python: '
    set_color yellow
    set_color --background black

    if [ -n "$pyenv_local" ]
        echo -n "$pyenv_local"
    else
        echo -n "$pyenv_global"
    end
    set_color --bold green
    set_color --background black
    echo -n ', '
end
# /__pyenv_info ----------------------------------------------------------- }}}

# __rbenv_info ------------------------------------------------------------ {{{
function __rbenv_info
    set --local rbenv_local (rbenv local ^/dev/null)
    set --local rbenv_global (rbenv global ^/dev/null)
    set_color normal
    set_color --background black
    echo -n 'ruby: '
    set_color yellow
    set_color --background black
    if [ -n "$rbenv_local" ]
        echo -n "$rbenv_local"
    else
        echo -n "$rbenv_global"
    end
    set_color --bold green
    set_color --background black
    echo -n ']'
end
# /__rbenv_info ----------------------------------------------------------- }}}

# __virtualenv_info ------------------------------------------------------- {{{
function __virtualenv_info
    if [ $VIRTUAL_ENV ]
        set_color green
        set_color --background black
        echo -n '('(basename $VIRTUAL_ENV)') '
    end
end
# /__virtualenv_info ------------------------------------------------------ }}}

# __prompt_char ----------------------------------------------------------- {{{
function __prompt_char
    set_color normal
    set_color --background black
    git branch >/dev/null ^/dev/null; and echo -n '±'; and return
    hg root >/dev/null ^/dev/null; and echo -n '☿'; and return
    echo -n '○'
end
# /__prompt_char ---------------------------------------------------------- }}}

# the prompt -------------------------------------------------------------- {{{
function fish_prompt
    __first_line
    __git_prompt_info
    echo
    __hg_prompt_info
    echo

    __pyenv_info
    __rbenv_info
    echo

    __virtualenv_info
    __prompt_char
    set_color normal
    echo -n ' '
    return
end
# /the prompt ------------------------------------------------------------- }}}
