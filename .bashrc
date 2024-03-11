alias task="python3 ~/projects/the_task_manager/tasks.py"

if command -v hx &>/dev/null; then
  echo 'helix editor configured'
  alias hx='hx -c ~/.hx.conf.toml'
fi
# cd replacement by zoxide if I donwloaded it
if command -v zoxide &> /dev/null; then
  echo "using zoxide as cd"
  eval "$(zoxide init bash)"
  alias cd=z
fi
# cat replacement by bat if I downloaded it
if command -v bat &> /dev/null; then
  echo "using bat as cat"
  alias cat=bat
fi
# tmux autostart if it's downloaded and the terminal is not already tmux
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi
#print using termux if we are in termux
if command -v neofetch &> /dev/null; then
  neofetch
fi
