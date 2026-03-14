# PinePhone Terminal Desktop - Shell Integration
# Append this to ~/.bashrc or ~/.zshrc, or source it directly
# source /path/to/shell_integration.sh

# Guard against being sourced multiple times
if [ -n "${_PINEPHONE_SHELL_LOADED:-}" ]; then
    return 0
fi
_PINEPHONE_SHELL_LOADED=1

# --- Auto-attach tmux session ---
# Start or attach to a tmux session named "main" on every interactive login
if command -v tmux &>/dev/null && [ -z "${TMUX:-}" ] && [[ $- == *i* ]]; then
    exec tmux new-session -A -s main
fi

# --- File picker: nnn ---
export NNN_FIFO=/tmp/nnn.fifo
export NNN_PLUG='p:preview-tui'
export VISUAL="${VISUAL:-vi}"
export EDITOR="${EDITOR:-vi}"

# --- Brightness alias ---
# Usage: bright 50%    (set to 50%)
#        bright +10%   (increase by 10%)
#        bright 10%-   (decrease by 10%)
alias bright='brightnessctl set'
