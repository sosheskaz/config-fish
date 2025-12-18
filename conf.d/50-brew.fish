begin
  if not set -qgx HOMEBREW_PREFIX
    set -l candidate_paths /opt/homebrew /home/linuxbrew/.linuxbrew
    for candidate in $candidate_paths
      if test -f "$candidate/bin/brew"
        set -gx HOMEBREW_PREFIX "$candidate" && break
      end
    end
  end
end

if set -qgx HOMEBREW_PREFIX
  set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar";
  set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX";
  fish_add_path --global --move --path "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin";
  if test -n "$MANPATH[1]"; set --global --export MANPATH '' $MANPATH; end;
  if not contains "$HOMEBREW_PREFIX/share/info" $INFOPATH; set --global --export INFOPATH "$HOMEBREW_PREFIX/share/info" $INFOPATH; end;
end
