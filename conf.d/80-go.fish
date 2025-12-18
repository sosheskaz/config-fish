set -qx GOPATH      || set -gx GOPATH "$HOME/go"
set -qx CGO_ENABLED || set -gx CGO_ENABLED 0
set -qx GOPRIVATE   || set -gx GOPRIVATE github.com/sosheskaz

if test -d "$GOPATH/bin"
  fish_add_path -a "$GOPATH/bin" # add it to the path, but low-priority.
end
