
IFS=$' \t\n'
_pwnd_commands=()

function pwnd_register_cmd() {
  _pwnd_commands+=("$1;$2")
}

function pwnd_isroot() {
  local retval=0
  if [ $EUID -ne 0 ]; then
    echo "You must be a root user"
    retval=1
  fi
  return $retval
}
