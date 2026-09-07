#!/usr/bin/env bash
# Symlink dotfiles into place. Safe to re-run. Works on Linux and macOS.
#
#   git clone <repo-url> ~/dotfiles && ~/dotfiles/install.sh
#
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d%H%M%S)"

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
        local rel="${dest#"$HOME"}"
        mkdir -p "$BACKUP_DIR$(dirname "$rel")"
        mv "$dest" "$BACKUP_DIR$rel"
        echo "back  $dest  ->  $BACKUP_DIR$rel"
    fi
    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    echo "link  $dest  ->  $src"
}

echo "OS:       $(uname -s)"
echo "Dotfiles: $DOTFILES_DIR"
echo

link "$DOTFILES_DIR/nvim"           "$HOME/.config/nvim"
link "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

echo
if [ -d "$BACKUP_DIR" ]; then
    echo "Existing files were moved to: $BACKUP_DIR"
fi
echo "Done."
echo
echo "Next steps:"
echo "  - nvim  : launch nvim; plugins install on first run (vim.pack)."
echo "  - tmux  : run 'tmux' or reload with  <prefix> r  inside a session."
