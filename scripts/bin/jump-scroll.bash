#!/usr/bin/env bash
#
# Jump scrolling in tmux copy mode (5-line increments)
# Usage: jump-scroll.bash <number-of-lines>
#   Positive number = scroll down
#   Negative number = scroll up
#   'half' = scroll half page
#   'full' = scroll full page

# Parse arguments
lines=${1?number of lines missing}
step=5

# Calculate scroll distance for special values
if [[ "$lines" == 'half' ]]; then
	pane_height="$(tmux display-message -p '#{pane_height}')"
	lines=$((pane_height / 2))
elif [[ "$lines" == 'full' ]]; then
	lines="$(tmux display-message -p '#{pane_height}')"
fi

# Determine direction
if [[ $lines -lt 0 ]]; then
	direction="up"
	lines=${lines#-}  # Make positive
else
	direction="down"
fi

# Scroll in chunks
while (( lines > 0 )); do
	if ((step > lines)); then
		tmux send-keys -X -N $lines cursor-$direction
		lines=0
	else
		tmux send-keys -X -N $step cursor-$direction
		lines=$((lines - step))
	fi
done
