if [[ ! -o interactive ]]; then
    return
fi

compctl -K _project-cluster project-cluster

_project-cluster() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(project-cluster commands)"
  else
    completions="$(project-cluster completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
