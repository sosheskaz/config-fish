begin
  set -q EDITOR_PREFERENCE || set -l EDITOR_PREFERENCE nvim vim nano
  if not set -qgx VISUAL
    for pref in $EDITOR_PREFERENCE
      if set -l resolved "$(command -v "$pref")"
        set -gx VISUAL "$resolved"
        alias vi "$VISUAL"
        alias vivi "command vi"
        break
      end
    end
  end
end

if not set -qx EDITOR && set -q VISUAL
  set -gx EDITOR "$VISUAL"
end
