set -x FZF_DEFAULT_COMMAND 'fd --type file --follow --hidden --exclude .git'

function fish_right_prompt
  set_color blue
  echo "$IN_NIX_SHELL"
  set_color normal
end
