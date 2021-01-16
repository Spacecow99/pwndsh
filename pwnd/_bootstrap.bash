
function __bash_help_usage() {
  echo "Execute bash builtin help and pass any argument to it"
}

function bash_help() {
  local help_topic=""

  if [ ! -z "${1-}" ]; then
    help_topic="${1}"
  fi

  bash -c "help ${help_topic}"
}

function __help_usage() {
  cat << "EOF"
usage: auto-help <name>
    Display helpful information about ${PWND_NAME} commands. If NAME is specified,
    gives detailed help on command NAME, otherwise a list of the ${PWND_NAME} 
    commands is printed.

    To access bash builtin help use: `bash_help'
EOF
  return 0
}

function help() {
  if [ ! -z "${1-}" ]; then
    eval "__${1}_usage" 2> /dev/null
    if [ ${?} == 127 ]; then
	    echo "auto-help: no help topics match \`${1}'. Try \`help' to see all the defined commands"
	    return 127
	  fi
  else
    cat << EOF
[${PWND_NAME} version ${PWND_VERSION} (${MACHTYPE})]
These ${PWND_NAME} commands are defined internally. Type \`help' to see this list.
Type \`help name' to find out more about the ${PWND_NAME} command \`name'.

EOF
    for pwnd_command in "${_pwnd_commands[@]-}"; do
      IFS=';' read -ra pwnd_cmd_parameters <<< "${pwnd_command}"
      printf "%-19s -- %s\n" "${pwnd_cmd_parameters[0]}" "${pwnd_cmd_parameters[1]}"
    done
  fi
}

cat << EOF
[${PWND_NAME} version ${PWND_VERSION} (${MACHTYPE})]
Type \`help' to display all the ${PWND_NAME} commands.
Type \`help name' to find out more about the ${PWND_NAME} command \`name'.

EOF
PS1="(\[\033[92m\]\[\033[1m\]${PWND_NAME}\[\033[0m\]\[\033[39m\])> "