#!/usr/bin/env bash

# TPM entry point for custom tmux configuration
# This file is loaded by TPM when the plugin is installed

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tmux source-file "$CURRENT_DIR/scripts/key-bindings.tmux"
