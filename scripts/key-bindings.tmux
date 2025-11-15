#!/usr/bin/env bash
# Custom tmux key bindings
# Adapted from tmux-prefixless with Ctrl+S prefix

# ==============================================================================
# PREFIX CONFIGURATION
# ==============================================================================

# Change prefix from Ctrl+B to Ctrl+S (easier with Caps Lock mapped to Ctrl)
unbind C-b
set -g prefix C-s
bind C-s send-prefix

# ==============================================================================
# PANE NAVIGATION (Vim-style)
# ==============================================================================

# Navigate panes with h/j/k/l (after prefix)
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Smart vertical pane switching with resize trick
# (prevents "invisible pane" problem by briefly resizing before switch)
bind -r j resize-pane -t .-1 -y 1 \; select-pane -D \; resize-pane -y -
bind -r k resize-pane -t .+1 -y 1 \; select-pane -U \; resize-pane -y -

# ==============================================================================
# PANE SPLITTING (with path preservation)
# ==============================================================================

# Split horizontally (vertical divider)
bind v split-window -h -c "#{pane_current_path}"

# Split vertically (horizontal divider)
bind s split-window -v -c "#{pane_current_path}"

# ==============================================================================
# PANE MANAGEMENT
# ==============================================================================

# Get script directory for helper scripts
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Smart pane killing (confirms for vim/ssh, instant for shells)
bind x run-shell "$CURRENT_DIR/bin/kill-pane.bash"

# Toggle pane zoom
bind f resize-pane -Z

# Pane resizing with arrow keys
bind -r Left resize-pane -L 5
bind -r Right resize-pane -R 5
bind -r Down resize-pane -D 5
bind -r Up resize-pane -U 5

# ==============================================================================
# WINDOW NAVIGATION
# ==============================================================================

# Previous/Next window with [ and ] (doesn't conflict with pane navigation)
bind -r [ previous-window
bind -r ] next-window

# Also support H/L (shifted) for window navigation
bind H previous-window
bind L next-window

# Create new window in current path
bind c new-window -c "#{pane_current_path}"

# ==============================================================================
# COPY MODE (Vim-style with clipboard integration)
# ==============================================================================

# Use vim keybindings in copy mode
setw -g mode-keys vi

# Enter copy mode easily
bind y copy-mode

# Vim-style visual selection and yanking
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi V send-keys -X select-line
bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle

# Yank to system clipboard (macOS)
bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "pbcopy"

# Smooth scrolling in copy mode
bind-key -T copy-mode-vi K run-shell "$CURRENT_DIR/bin/smooth-scroll.bash -5"
bind-key -T copy-mode-vi J run-shell "$CURRENT_DIR/bin/smooth-scroll.bash 5"

# Navigate to line boundaries
bind-key -T copy-mode-vi H send-keys -X start-of-line
bind-key -T copy-mode-vi L send-keys -X end-of-line

# Half-page scrolling
bind-key -T copy-mode-vi C-u send-keys -X halfpage-up
bind-key -T copy-mode-vi C-d send-keys -X halfpage-down

# ==============================================================================
# SESSION MANAGEMENT
# ==============================================================================

# Show session menu
bind a choose-session

# ==============================================================================
# MISC SETTINGS
# ==============================================================================

# Enable mouse support (useful for quick pane selection)
set -g mouse on

# Increase history limit
set -g history-limit 50000

# Start window and pane numbering at 1
set -g base-index 1
setw -g pane-base-index 1

# Renumber windows when one is closed
set -g renumber-windows on

# Enable focus events for vim
set -g focus-events on

# Faster command sequences (reduce escape time)
set -s escape-time 10

# Enable 24-bit color
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",xterm-256color:Tc"

# Bell notifications (hear bells from background windows)
set -g bell-action any
set -g visual-bell off
set -g monitor-bell on
set -g window-status-bell-style 'fg=red,bold'
