# Custom Tmux Configuration

A ergonomic tmux configuration optimized for macOS with Caps Lock mapped to Ctrl. Inspired by tmux-prefixless but maintains tmux's standard prefix-based workflow.

## Philosophy

- **Ergonomic prefix**: Ctrl+S instead of Ctrl+B (easy with Caps Lock → Ctrl mapping)
- **Vim-style navigation**: h/j/k/l for intuitive pane movement
- **Smart behaviors**: Path preservation, intelligent pane killing, jump scrolling
- **Standard tmux workflow**: Uses prefix key (no timing-based prefixless mode)

## Features

### Prefix Key

- **Ctrl+S** - New prefix (replaces Ctrl+B)
- **Ctrl+S, Ctrl+S** - Send Ctrl+S to application

### Pane Navigation (Vim-style)

- **Prefix, h/j/k/l** - Navigate left/down/up/right
- **Prefix, f** - Toggle pane zoom (fullscreen)

### Smart Pane Switching

- **Prefix, j** - Select next pane (down) with resize trick
- **Prefix, k** - Select previous pane (up) with resize trick

The resize trick briefly shrinks the target pane before switching, preventing the "invisible pane" problem.

### Pane Splitting (with path preservation)

- **Prefix, s** - Split horizontally (new pane below)
- **Prefix, v** - Split vertically (new pane to right)

New panes inherit the current directory automatically.

### Smart Pane Killing

- **Prefix, x** - Smart kill pane
  - Vim/SSH sessions → Asks for confirmation
  - Shell sessions (bash/zsh) → Kills immediately
  - Everything else → Asks for confirmation

### Pane Resizing

- **Prefix, Arrow Keys** - Resize pane in direction (repeatable)

### Window Management

- **Prefix, c** - New window (in current directory)
- **Prefix, [** - Previous window (repeatable)
- **Prefix, ]** - Next window (repeatable)
- **Prefix, H** - Previous window (alternative)
- **Prefix, L** - Next window (alternative)

### Session Management

- **Prefix, a** - Choose session (interactive menu)

### Copy Mode (Vim-style with macOS clipboard)

- **Prefix, y** - Enter copy mode
- **v** - Begin visual selection (in copy mode)
- **V** - Select line (in copy mode)
- **Ctrl+V** - Rectangle selection (in copy mode)
- **y** - Yank to macOS clipboard and exit (in copy mode)
- **Enter** - Yank to macOS clipboard and exit (in copy mode)

### Jump Scrolling in Copy Mode

- **J** - Scroll down 5 lines
- **K** - Scroll up 5 lines
- **H** - Jump to start of line
- **L** - Jump to end of line
- **Ctrl+U** - Half page up
- **Ctrl+D** - Half page down

## Installation with TPM

### 1. Clone this repository

```bash
git clone https://github.com/silverl/tmux.git ~/code/tmux
```

### 2. Symlink the tmux configuration

```bash
# Backup existing config if you have one
mv ~/.tmux.conf ~/.tmux.conf.backup

# Create symlink to the repo config
ln -s ~/code/tmux/tmux.conf ~/.tmux.conf
```

### 3. Install TPM (if not already installed)

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### 4. Symlink this repo as a TPM plugin

This allows TPM to automatically discover and load the configuration:

```bash
ln -s ~/code/tmux ~/.tmux/plugins/tmux
```

**How it works**: TPM automatically executes all `*.tmux` files in plugin directories. The symlink allows TPM to find and run `tmux-custom.tmux`, which loads the key bindings (including the `Ctrl+S` prefix).

### 5. Install the plugins

Inside tmux:

- **Prefix, I** (capital I) - Install plugins (if using default Ctrl+B prefix initially)

Or from command line:

```bash
~/.tmux/plugins/tpm/bin/install_plugins
tmux source ~/.tmux.conf
```

### 6. Verify installation

Press **Prefix** (Ctrl+S) followed by **h** - you should navigate to the left pane.

## Manual Installation (without TPM)

If you prefer not to use TPM, source the configuration directly:

```bash
# Add to ~/.tmux.conf
run-shell "~/code/tmux/scripts/key-bindings.tmux"
```

Then reload:

```bash
tmux source ~/.tmux.conf
```

## Configuration Details

### Smart Scripts

#### kill-pane.bash

Intelligently handles pane closing based on the running process:

- Protects important sessions (vim, ssh) with confirmation
- Instantly closes safe processes (shells, pagers)
- Defaults to confirmation for unknown processes

#### jump-scroll.bash

Provides quick jumping in copy mode (5 lines at a time with J/K keys).

### Additional Settings

- **Mouse support**: Enabled for quick selections
- **History limit**: 50,000 lines
- **Window numbering**: Starts at 1 (not 0)
- **Renumber windows**: Automatically renumbers when windows close
- **Focus events**: Enabled for vim integration
- **Fast escape**: 10ms escape time for better vim experience
- **True color**: 24-bit color support enabled
- **Bell notifications**: Hear bells from background windows/panes (highlights window name in red)

## Customization

Edit `~/code/tmux/scripts/key-bindings.tmux` to customize bindings.

Common customizations:

- Change prefix key (edit `set -g prefix C-s`)
- Modify split keys
- Adjust mouse behavior
- Change color settings

## Troubleshooting

### Prefix key not working

- Verify Caps Lock is mapped to Ctrl in macOS System Settings
- Test with `Ctrl+S` in a text editor first
- Reload tmux config: `tmux source ~/.tmux.conf`

### Smart kill not working

- Check script permissions: `ls -l ~/code/tmux/scripts/bin/`
- Scripts should be executable (chmod +x)

### Clipboard integration not working

- Requires `pbcopy` (built into macOS)
- Test: `echo "test" | pbcopy && pbpaste`

### Jump scrolling not working

- Enter copy mode first (Prefix, y)
- Then use J/K to jump 5 lines up/down

### Not hearing bells from background windows

- Check `bell-action` is set to `any` (not `current` or `none`)
- Ensure `visual-bell` is set to `off` for audible bells
- In iTerm2: Settings → Profiles → Terminal → Uncheck "Silence bell"
- For macOS notifications: Settings → Profiles → Session → Check "Post a notification when a bell rings..."
- Test with: `echo -e '\a'` (should hear/see bell immediately)

## Credits

Inspired by [tmux-prefixless](https://github.com/joshmedeski/tmux-prefixless) by joshmedeski, adapted for standard tmux workflow with ergonomic enhancements.
