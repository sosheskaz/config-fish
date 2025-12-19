function fish_prompt --description 'Informative prompt'
        #Save the return status of the previous command
        set -l last_pipestatus $pipestatus
        set -lx __fish_last_status $status # Export for __fish_print_pipestatus.

        if functions -q fish_is_root_user; and fish_is_root_user
                printf '%s@%s %s%s%s# ' $USER (prompt_hostname) (set -q fish_color_cwd_root
                                                                     and set_color $fish_color_cwd_root
                                                                     or set_color $fish_color_cwd) \
                        (prompt_pwd) (set_color normal)
        else
                set -l status_color (set_color $fish_color_status)
                set -l statusb_color (set_color --bold $fish_color_status)
                set -l pipestatus_string (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

                set -l left_top (printf '[%s] %s%s@%s %s%s %s%s' (date "+%H:%M:%S") (set_color brblue) \
                        $USER (prompt_hostname) (set_color $fish_color_cwd) $PWD $pipestatus_string  \
                        (set_color normal))
                set -l right_top (test -d .git && fish_git_prompt '(%s)')
                set -l left_bottom "$(printf '%s> ' (set_color normal))"

                set -l padding (math $COLUMNS - (string length -v "$left_top"))
                if test $padding -lt 1
                        set right_top ''
                else
                        set right_top (string pad -c ' ' -w "$padding" "$right_top")
                end

                printf '%s%s\n%s' "$left_top" "$right_top" "$left_bottom"
        end
end
