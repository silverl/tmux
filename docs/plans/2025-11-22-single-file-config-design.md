# Tmux Single-File Configuration Design

**Date:** 2025-11-22
**Goal:** Simplify tmux configuration for maximum portability across machines

## Problem

Current setup has:

- Duplicate settings in `tmux.conf` and `scripts/key-bindings.tmux`
- Conflicting terminal settings (platform-specific overridden by hardcoded)
- Complex TPM plugin loading of own config (circular dependency)
- Confusing installation requiring symlinks in two places

## Solution

Merge everything into single `tmux.conf` file.

## Design

### File Structure

```
tmux/
├── tmux.conf              # Complete configuration (new)
├── scripts/
│   └── bin/
│       ├── kill-pane.bash     # Smart pane killing
│       └── jump-scroll.bash   # Jump scrolling in copy mode
├── README.md              # Updated installation instructions
└── docs/
    └── plans/
        └── 2025-11-22-single-file-config-design.md
```

**Files removed:**

- `tmux-custom.tmux` (no longer needed)
- `scripts/key-bindings.tmux` (merged into tmux.conf)

### Installation Steps (New)

1. Clone repo: `git clone https://github.com/silverl/tmux.git ~/code/tmux`
2. Symlink config: `ln -s ~/code/tmux/tmux.conf ~/.tmux.conf`
3. Install TPM: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
4. Install plugins: `~/.tmux/plugins/tpm/bin/install_plugins`

**Compared to current:** Removed symlink step for plugin directory.

### tmux.conf Organization

```
1. Platform-specific terminal settings
2. General settings (mouse, history, numbering, bells)
3. Prefix configuration (Ctrl+S)
4. Pane navigation (vim h/j/k/l)
5. Pane splitting (with path preservation)
6. Pane management (smart kill, zoom, resize)
7. Window navigation ([], HL, create)
8. Copy mode (vim-style with clipboard)
9. Session management
10. TPM plugin declarations
11. TPM initialization (last line)
```

### Key Decisions

**Terminal settings:**

- Keep platform-specific logic at top
- Don't duplicate in other sections
- macOS: `screen-256color` with RGB
- Linux: `tmux-256color` with Tc

**Script paths:**

- Use hardcoded `~/code/tmux/scripts/bin/` paths
- Assumes repo cloned to `~/code/tmux` (documented in README)
- Alternative: use `~/.tmux.conf` directory detection, but adds complexity

**TPM plugins:**

- Keep existing: tmux-resurrect, tmux-continuum
- Remove: `@plugin 'tmux'` (no longer needed)

## Implementation Plan

1. Merge `scripts/key-bindings.tmux` into `tmux.conf`
2. Remove duplicate settings
3. Delete obsolete files
4. Update README with new installation steps
5. Test on this Mac
6. Update on other machine

## Testing

1. Remove old plugin directory: `rm -rf ~/.tmux/plugins/tmux`
2. Reload config: `tmux source ~/.tmux.conf`
3. Verify keybindings work (Ctrl+S prefix)
4. Verify smart scripts work (kill-pane, jump-scroll)
5. Check TPM plugins loaded (resurrect, continuum)

## Success Criteria

- Single source of truth (`tmux.conf`)
- No duplicate settings
- No conflicting terminal settings
- Installation requires only 2 symlinks (config + TPM)
- Works on both macOS and Linux
