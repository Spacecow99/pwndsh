#!/usr/bin/env bash


#############
# Functions #
#############

normalize_and_append() {
  printf "Normalizing '${1}'\n"
	grep -v "^#" < "$1" >> "$2"
	echo " " >> "$2"
}


###############
# Entry Point #
###############

function main() {

  local OUTPUT_FILENAME="./pwnd.sh"
  local COMMAND_PATH=""
  local NORMALISE="false"
  local SHELL_NAME="pwnd"
  local SHELL_VERSION="1.0.0"

  while getopts 'hno:c:s:v:' OPT; do
    case ${OPT} in
      h)
        printf "usage: ${0} [-h] [-n] [-o FILENAME] [-s NAME] [-v VERSION] -c PATH\n"
        printf "REQUIRED:\n"
        printf "\t-c PATH: Path to commands directory.\n"
        printf "\nOPTIONAL:\n"
        printf "\t-n          : Normalize bootstrap/module code.\n"
        printf "\t-o FILENAME : Output filename of built shell. (Default: ./pwnd.sh)\n"
        printf "\t-s NAME     : Name to include in shell (Default: pwnd).\n"
        printf "\t-v VERSION  : Version to include in shell (Default: 1.0.0).\n"
        exit 0
        ;;
      n)
          NORMALISE='true'
          ;;
      o)
          OUTPUT_FILENAME="${OPTARG}"
          ;;
      c)
          COMMAND_PATH="${OPTARG}"
          ;;
      s)
          SHELL_NAME="${OPTARG}"
          ;;
      v)
          SHELL_VERSION="${OPTARG}"
          ;;
    esac
  done

  # Ensure COMMAND_PATH is provided and valid
  if [[ -z "${COMMAND_PATH}" ]]; then
    printf "\n" >2
    exit 1
  fi

  # Start with a shebang line
  echo "#!/usr/bin/env bash" > "${OUTPUT_FILENAME}"

  # echo PWND_NAME and PWND_VERSION to OUTPUT_FILENAME
  echo "PWND_NAME='$SHELL_NAME'" >> "${OUTPUT_FILENAME}"
  echo "PWND_VERSION='$SHELL_VERSION'" >> "${OUTPUT_FILENAME}"

  if [[ "${NORMALISE}" = "true" ]]; then
    normalize_and_append "./pwnd/_pwnd.bash" "${OUTPUT_FILENAME}"
    for module in $(find "${COMMAND_PATH}" -type f -name "[a-zA-Z0-9]*.bash"); do
      printf "Found module '${module}'\n"
      normalize_and_append "${module}" "${OUTPUT_FILENAME}"
    done
    normalize_and_append "./pwnd/_bootstrap.bash" "${OUTPUT_FILENAME}"
  else
    cat "./pwnd/_pwnd.bash" >> "${OUTPUT_FILENAME}"
    for module in $(find "${COMMAND_PATH}" -type f -name "[a-zA-Z0-9]*.bash"); do
      printf "Found module '${module}'\n"
      cat "${module}" >> "${OUTPUT_FILENAME}"
    done
    cat "./pwnd/_bootstrap.bash" >> "${OUTPUT_FILENAME}"
  fi

  ls -la "${OUTPUT_FILENAME}"

}


main ${@}
