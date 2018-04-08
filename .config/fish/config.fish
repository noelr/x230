set -U fish_user_paths ~/.local/bin $fish_user_paths

function fish_right_prompt
  set_color blue
  echo "$IN_NIX_SHELL"
  set_color normal
end
