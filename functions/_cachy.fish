function _cachy_ctime
  set -f rc 0
  for f in $argv
    if test -f "$f"
      path mtime "$f"
    else
      set rc 1
    end
  end
  return $rc
end

function _cachy
  argparse -n _cachy 'n/name=' 't/ttl=' -- $argv
  set -f cachy_dir "$HOME/.cache/_cachy.fish"

  set -f name $_flag_name
  set -f ttl $_flag_ttl
  if test -z "$name"
    echo "Error: Name is required" >&2
    return 1
  end
  if test -z "$ttl"
    set -f ttl 3600
  end

  if test (count $argv) -eq 0
    echo "Error: Command is required" >&2
    return 1
  end

  set -f cmd $argv

  set -f cache_file "$cachy_dir/$name"
  set -l needs_update 1
  if test -f "$cache_file"
    set -l file_ctime (_cachy_ctime "$cache_file")
    set -l current_time (date +%s)
    set -l age (math $current_time - $file_ctime)
    if test $age -lt $ttl
      set needs_update 0
    end
  end

  if test $needs_update -eq 1
    if not test -d "$cachy_dir"; mkdir -p "$cachy_dir"; end
    $cmd | tee "$cache_file"
    return $status
  else
    read -z < "$cache_file"
  end
end
