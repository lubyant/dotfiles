# dotfiles

Neovim and tmux configuration, shared across Linux and macOS.

## Layout

```
dotfiles/
├── install.sh              # symlinks everything into place (re-runnable)
├── nvim/                   # -> ~/.config/nvim
│   ├── init.lua
│   └── nvim-pack-lock.json # plugin lockfile (vim.pack)
└── tmux/
    └── tmux.conf           # -> ~/.tmux.conf
```

## Install

```sh
git clone git@github.com:<you>/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` symlinks `nvim/` to `~/.config/nvim` and `tmux/tmux.conf` to
`~/.tmux.conf`. Anything already there is moved to
`~/.dotfiles-backup/<timestamp>/` first. Running it again is a no-op once the
links exist.

## Requirements

| Tool     | Linux                                   | macOS                          |
|----------|-----------------------------------------|--------------------------------|
| Neovim   | `>= 0.12` (uses built-in `vim.pack`)    | `brew install neovim`          |
| tmux     | `>= 3.0` (config uses `if-shell` blocks)| `brew install tmux`            |
| Clipboard| `wl-clipboard` (Wayland) or `xclip` (X11)| `pbcopy` (built in)           |

### Neovim external tools (optional, for LSP / formatting)

- LSP: `clangd`, `pyright`
- Formatters: `black`, `isort` (Python), `clang-format` (C/C++)

Plugins are managed by Neovim's built-in `vim.pack` and install automatically
on first launch. `nvim/nvim-pack-lock.json` pins revisions; update with
`:lua vim.pack.update()` and commit the changed lockfile.

## tmux notes

- Prefix is the default `C-b`.
- `<prefix> |` / `<prefix> -` split vertically / horizontally, keeping the cwd.
- `<prefix> h/j/k/l` move between panes; `H/J/K/L` resize.
- Copy mode is vi-style: `v` select, `y` yank to the system clipboard
  (picks `pbcopy` / `wl-copy` / `xclip` automatically by OS).
- `<prefix> r` reloads the config.
