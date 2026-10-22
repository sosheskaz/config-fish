# Hosts that keep Codex state on a persistent volume at /data/herdr/codex use it
# directly. Codex's workspace-write sandbox refuses a symlinked ~/.codex inside a
# writable root, so the home is selected with CODEX_HOME rather than a link.
if not set -q CODEX_HOME; and test -d /data/herdr/codex
    set -gx CODEX_HOME /data/herdr/codex
end
