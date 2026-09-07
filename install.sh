#!/usr/bin/env bash
# Symlink dotfiles into place. Safe to re-run. Works on Linux and macOS.
#
#   git clone <repo-url> ~/dotfiles && ~/dotfiles/install.sh
#
# Anything already at a destination is overwritten, after a per-item y/N prompt.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
    local src="$1" dest="$2"

    if [ ! -e "$src" ]; then
        echo "skip  $dest  (source missing: $src)"
        return
    fi
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        echo "ok    $dest"
        return
    fi
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        local reply=""
        printf 'overwrite  %s ?  [y/N] ' "$dest"
        read -r reply || true
        case "$reply" in
            [yY] | [yY][eE][sS]) ;;
            *) echo "skip  $dest  (kept existing)"; return ;;
        esac
        rm -rf "$dest"
    fi
    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    echo "link  $dest  ->  $src"
}

echo "OS:       $(uname -s)"
echo "Dotfiles: $DOTFILES_DIR"
echo

link "$DOTFILES_DIR/nvim"           "$HOME/.config/nvim"
link "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

echo
echo "Done."
echo
echo "Next steps:"
echo "  - nvim  : launch nvim; plugins install on first run (vim.pack)."
echo "  - tmux  : run 'tmux' or reload with  <prefix> r  inside a session."
