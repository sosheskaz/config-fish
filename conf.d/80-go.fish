set -qx GOPATH      || set -gx GOPATH "$HOME/go"
set -qx CGO_ENABLED || set -gx CGO_ENABLED 0
set -qx GOPRIVATE   || set -gx GOPRIVATE github.com/sosheskaz
set -qx GOPROXY     || set -gx GOPROXY https://goproxy.miller-machine.xyz,direct

if test -d "$GOPATH/bin"
  fish_add_path -a "$GOPATH/bin" # add it to the path, but low-priority.
end
