# name: danieljaouen
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
    # __prompt_char ------------------------------------------------ {{{
    function __prompt_char
        git branch >/dev/null ^/dev/null; and echo '±'; and return
        hg root >/dev/null ^/dev/null; and echo '☿'; and return
        echo '○'
    end
    # /__prompt_char ----------------------------------------------- }}}

    # __rbenv_info ------------------------------------------------- {{{
    function __rbenv_info
        rbenv local ^/dev/null; or rbenv global ^/dev/null
    end
    # /__rbenv_info ------------------------------------------------ }}}

    # __pyenv_info ------------------------------------------------- {{{
    function __pyenv_info
        pyenv local ^/dev/null; or pyenv global ^/dev/null
    end
    # /__pyenv_info ------------------------------------------------ }}}

    # __virtualenv_info -------------------------------------------- {{{
    function __virtualenv_info
        [ $VIRTUAL_ENV ]; and echo '('`basename $VIRTUAL_ENV`') '
    end
    # /__virtualenv_info ------------------------------------------- }}}

    # __hg_prompt_info --------------------------------------------- {{{
    function __hg_prompt_info
    end
    # /__hg_prompt_info -------------------------------------------- }}}

    # __git_prompt_prefix ------------------------------------------ {{{
    function __git_prompt_info
        # prefix ----------------------------- {{{
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
        # /prefix ---------------------------- }}}

        set --local ref (command git symbolic-ref HEAD ^/dev/null)
        or set --local ref (command git rev-parse --short HEAD ^/dev/null)

        # suffix ----------------------------- {{{
        set_color --bold green
        # /suffix ---------------------------- }}}

        # dirty ------------------------------ {{{
        set_color --bold red
        echo -n "!"
        # /dirty ----------------------------- }}}

        # untracked -------------------------- {{{
        set_color --bold red
        echo -n "?"
        # /untracked ------------------------- }}}

        set --local git_info
        if [ (command git rev-parse --is-inside-work-tree ^/dev/null) ]
            # Get the current branch name/commit
            set --local git_branch_name (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
            if [ -z $git_branch_name ]
                set git_branch_name (command git show-ref --head -s --abbrev | head -n1 2> /dev/null)
            end

            # Unconditional git component
            set git_info "$normal""on $white$git_branch_name"

            if [ (command git status -s --ignore-submodules=dirty | wc -l) -gt 0 ]
                set git_info "$git_info$yellow*"
            end

            set git_info "$git_info "
        end
    end
    # /__git_prompt_prefix ----------------------------------------- }}}

    # __git_prompt_info -------------------------------------------- {{{
    function __git_prompt_info
        set --local git_info
        if [ (command git rev-parse --is-inside-work-tree ^/dev/null) ]
            # Get the current branch name/commit
            set --local git_branch_name (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
            if [ -z $git_branch_name ]
                set git_branch_name (command git show-ref --head -s --abbrev | head -n1 2> /dev/null)
            end

            # Unconditional git component
            set git_info "$normal""on $white$git_branch_name"

            if [ (command git status -s --ignore-submodules=dirty | wc -l) -gt 0 ]
                set git_info "$git_info$yellow*"
            end

            set git_info "$git_info "
        end
    end
    # /__git_prompt_info ------------------------------------------- }}}
    # /helper functions --------------------------------------------------- }}}

    set --local last_status $status

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
