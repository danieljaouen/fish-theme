# name: danieljaouen
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
    echo "]"
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
        echo
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
    echo "]"
    # /the prompt -------------------------------------------------- }}}
    set_color --bold green
    set_color --background black
end
# /__hg_prompt_info ------------------------------------------------------- }}}

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

# __prompt_char ----------------------------------------------------------- {{{
function __prompt_char
    git branch >/dev/null ^/dev/null; and echo -n '±'; and return
    hg root >/dev/null ^/dev/null; and echo -n '☿'; and return
    echo -n '○'
end
# /__prompt_char ---------------------------------------------------------- }}}

# __rbenv_info ------------------------------------------------------------ {{{
function __rbenv_info
    rbenv local ^/dev/null; or rbenv global ^/dev/null
end
# /__rbenv_info ----------------------------------------------------------- }}}

# __pyenv_info ------------------------------------------------------------ {{{
function __pyenv_info
    pyenv local ^/dev/null; or pyenv global ^/dev/null
end
# /__pyenv_info ----------------------------------------------------------- }}}

# __virtualenv_info ------------------------------------------------------- {{{
function __virtualenv_info
    [ $VIRTUAL_ENV ]; and echo '('`basename $VIRTUAL_ENV`') '
end
# /__virtualenv_info ------------------------------------------------------ }}}

function fish_prompt
    # colors -------------------------------------------------------------- {{{
    set --local black_foreground (set_color black)
    set --local black_foreground_bold (set_color --bold black)
    set --local black_background (set_color --background black)

    set --local red_foreground (set_color red)
    set --local red_foreground_bold (set_color --bold red)
    set --local red_background (set_color --background red)

    set --local green_foreground (set_color green)
    set --local green_foreground_bold (set_color --bold green)
    set --local green_background (set_color --background green)

    set --local yellow_foreground (set_color yellow)
    set --local yellow_foreground_bold (set_color --bold yellow)
    set --local yellow_background (set_color --background yellow)

    set --local blue_foreground (set_color blue)
    set --local blue_foreground_bold (set_color --bold blue)
    set --local blue_background (set_color --background blue)

    set --local magenta_foreground (set_color magenta)
    set --local magenta_foreground_bold (set_color --bold magenta)
    set --local magenta_background (set_color --background magenta)

    set --local cyan_foreground (set_color cyan)
    set --local cyan_foreground_bold (set_color --bold cyan)
    set --local cyan_background (set_color --background cyan)

    set --local white_foreground (set_color white)
    set --local white_foreground_bold (set_color --bold white)
    set --local white_background (set_color --background white)

    set --local reset (set_color normal)
    # /colors ------------------------------------------------------------- }}}

    # helper functions ---------------------------------------------------- {{{
    # /helper functions --------------------------------------------------- }}}

    # _rprint ------------------------------------------------------------- {{{
    # Prints first argument left-aligned, second argument right-aligned, newline
    function _rprint
        if [ (count $argv) = 1 ]
            echo -s $argv
        else
            set --local arglength (echo -n -s "$argv[1]$argv[2]" | perl -le 'while (<>) {
                s/ \e[ #%()*+\-.\/]. |
                    (?:\e\[|\x9b) [ -?]* [@-~] | # CSI ... Cmd
                    (?:\e\]|\x9d) .*? (?:\e\\|[\a\x9c]) | # OSC ... (ST|BEL)
                    (?:\e[P^_]|[\x90\x9e\x9f]) .*? (?:\e\\|\x9c) | # (DCS|PM|APC) ... ST
                    \e.|[\x80-\x9f] //xg;
                print;
            }' | awk '{printf length;}')

            set --local termwidth (tput cols)

            set --local padding
            if [ $arglength -lt $termwidth ]
                set padding (printf "%0"(math $termwidth - $arglength)"d"|tr "0" " ")
            end

            echo -s "$argv[1]$padding$argv[2]"
        end
    end
    # /_rprint ------------------------------------------------------------ }}}

    # Unconditional stuff

    # the prompt ---------------------------------------------------------- {{{
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

    __git_prompt_info
    __hg_prompt_info

    __prompt_char
    set_color normal
    echo -n ' '
    return
    # /the prompt --------------------------------------------------------- }}}

    set --local path $red_foreground_bold(pwd | sed "s:^$HOME:~:")$normal
    set --local basic_prompt $yellow(whoami)$normal" at "$green(hostname -s)$normal" in "$blue$path" "

    # Prompt
    set --local prompt
    if [ "$UID" = "0" ]
        set prompt "$red# "
    else
        set prompt "$normal% "
    end

    # Last command
    set --local status_info ""
    if [ $last_status -ne 0 ]
        set status_info "$red""command failed with status: $last_status"
    end

    # WTB: time spend on last command (if ≥ 1s)

    ##################################################
    # Output
    if [ -n $status_info ]
        echo -s $status_info
    end
    _rprint "$basic_prompt$git_info" $job_info
    echo -n -s $prompt
end
