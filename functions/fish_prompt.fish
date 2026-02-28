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

                set -l duration_str ''
                if test "$CMD_DURATION" -gt 3000 2>/dev/null
                        set -l secs (math --scale=1 "$CMD_DURATION / 1000")
                        if test "$secs" -ge 60 2>/dev/null
                                set -l mins (math --scale=0 "floor($secs / 60)")
                                set secs (math --scale=1 "$secs - $mins * 60")
                                set duration_str (printf ' %s+%dm%ss%s' (set_color yellow) $mins $secs (set_color normal))
                        else
                                set duration_str (printf ' %s+%ss%s' (set_color yellow) $secs (set_color normal))
                        end
                end

                set -l left_top (printf '[%s%s] %s%s@%s %s%s %s%s' (date "+%H:%M:%S") "$duration_str" (set_color brblue) \
                        $USER (prompt_hostname) (set_color $fish_color_cwd) $PWD $pipestatus_string  \
                        (set_color normal))
                set -l right_top (fish_git_prompt '(%s)' 2>/dev/null)
                set -l left_bottom
                set -l bw_status ''
                set -l bw_cmd bw
                if set -q BW_CMD
                        set bw_cmd $BW_CMD
                end
                if command -q $bw_cmd
                        if set -q BW_SESSION; or set -q __bw_session
                                set bw_status '🔓 '
                        end
                end
                if set -q VIRTUAL_ENV
                        set -l venv_name (basename $VIRTUAL_ENV)
                        set left_bottom (printf '%s%s🐍(%s)%s > ' "$bw_status" (set_color yellow) $venv_name (set_color normal))
                else
                        set left_bottom (printf '%s%s> ' "$bw_status" (set_color normal))
                end

                set -l padding (math $COLUMNS - (string length -v "$left_top"))
                if test $padding -lt 1
                        set right_top ''
                else
                        set right_top (string pad -c ' ' -w "$padding" "$right_top")
                end

                printf '%s%s\n%s' "$left_top" "$right_top" "$left_bottom"
        end
end
