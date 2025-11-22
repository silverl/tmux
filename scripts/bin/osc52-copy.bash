#!/usr/bin/env bash
# OSC 52 clipboard copy for terminal-only environments.
# Usage: echo "text" | osc52-copy.bash

set -o errexit -o nounset -o pipefail

# Read stdin
data=$(cat)

# Base64 encode (GNU coreutils wraps lines; strip newlines)
encoded=$(
  printf '%s' "$data" \
  | base64 \
  | tr -d '\r\n'
)

# Send OSC 52 sequence to the *terminal*, not to tmux's stdout
# ESC ] 52 ; c ; <base64> BEL
printf '\033]52;c;%s\007' "$encoded" > /dev/tty
