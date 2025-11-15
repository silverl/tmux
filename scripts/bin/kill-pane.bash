#!/usr/bin/env bash
#
# Smart pane killing - confirms before killing important sessions
# Usage: Called by tmux when pressing the kill-pane binding

declare -r cmd=$(tmux display-message -p '#{pane_current_command}')

case "$cmd" in
	# Confirm before killing vim or ssh sessions
	vim|nvim|ssh)
		tmux confirm-before -p "kill-pane running '$cmd'? (y/n)" kill-pane
		;;

	# Kill shell and pager processes immediately (safe to close)
	less|bash|zsh|fish)
		tmux kill-pane
		;;

	# For everything else, ask for confirmation
	*)
		tmux confirm-before -p "kill-pane running '$cmd'? (y/n)" kill-pane
		;;
esac
