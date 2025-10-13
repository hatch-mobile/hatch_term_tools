#!/bin/bash

# Copies compiled binaries from `../HatchTerminal/.build/release` to `./tools`
# 
# Useful when paired with `HatchTerminal/scripts/install.sh`. EX:
# 
# # From hatch_term_tools
# ```sh
# ../HatchTerminal/scripts/install.sh; ./push_hatch_terminal.sh
# ```
# 
# # From HatchTerminal
# ```sh
# ./scripts/install.sh; ../hatch_term_tools/push_hatch_terminal.sh
# ```

# ---- Look for our debug argument first thing (other args processed after bootstrapping).

unset -v IS_DEBUG
for i in "$@"; do
  if [ "$i" == "--debug" ] ; then
    # echo "----- Found"
    IS_DEBUG="true"
  fi
done

# ---- Set up our logging functions

# Writes to stdout using echo_pretty if available
_log_pretty() {
  if which echo_pretty > /dev/null; then
    echo_pretty "$@"
  else 
    # echo_pretty isn't available so let's use echo. But first...
    # we must remove all echo_ansi arguments (those that are
    # prefexed with a '-').
    args=("$@") 
    retained_args=()

    # Those args that do not begin with '-' will be retained
    for (( i=0; i<"${#args[@]}"; i++)); do
      arg=${args[$i]}
      if [ "${arg:0:1}" != "-" ]; then 
        retained_args+=("$arg")
      fi
    done

    # Print the array as a string (preserving whitespaces)
    printf "%s" "${retained_args[@]}"; printf "\n"
  fi
}

# Writes to stdout always
log() {
  _log_pretty "$@";
}

# Writes to stdout if `--debug` param was specified.
logd() {
  if [[ -n "$IS_DEBUG" ]]; then
    log "$@"
  fi
}

# Writes to stderr always
logStdErr() {
  _log_pretty "$@" 1>&2
}

# Writes to stderr if `--debug` param was specified.
logdStdErr() {
  if [[ -n "$IS_DEBUG" ]]; then
    logStdErr "$@"
  fi
}

SCRIPT_DIR=$(realpath "$(dirname "$0")")
SCRIPT_NAME=./$(basename "$0")

logdStdErr "SCRIPT_NAME: $SCRIPT_NAME"
logdStdErr "SCRIPT_DIR:  $SCRIPT_DIR"
logdStdErr "PWD:         $PWD"

# ---- Set up our print_usage function

# Prints the example usage to stderr
# Call like so: `print_usage`
print_usage () {
  SCRIPT_NAME=./$(basename "$0")
  logStdErr "Copies from HatchTerminal/.build/release to ./tools"
  logStdErr ""
  logStdErr "Usage:"
  logStdErr "    $SCRIPT_NAME [OPTIONS]"
  logStdErr ""
  logStdErr "Mandatory:"
  logStdErr ""
  logStdErr "Optional:"
  logStdErr "    --tool [zing|echo_pretty|hatch_log]: Only a specific tool"
  logStdErr "         Default: install"
  # # logStdErr "    --hatch-tools-dir <dir>: The directory to install tools to."
  # # logStdErr "         Directory will be created."
  # # logStdErr "         Default: ~/.hatch/bin"
  logStdErr "    --dry-run: Print intended commands/actions but don't execute."
  logStdErr "    --debug: Enables debug logging to stderr."
  logStdErr "    --help: Prints this message"
  logStdErr ""
  logStdErr "EX:"
  logStdErr "    Print help"
  logStdErr "    \$ $SCRIPT_NAME --help"
  logStdErr ""
  logStdErr "    Normal"
  logStdErr "    \$ $SCRIPT_NAME"
  logStdErr ""
  logStdErr "    Specific tool"
  logStdErr "    \$ $SCRIPT_NAME --tool=zing"
  logStdErr ""
}

# ---- Start parsing and checking our arguments & arguments with parameters. 

# Parses command line arguments for presence of a flag
#
# USAGE: 
#   parse_flag_argument "flag" "${@:1}"
#
# EXAMPLE:
#  if [[ -n "$(argumentPresent "--xcode" "${@:1}")" ]]; then
#    xed ...
#  fi
# 
# STDOUT:
#   Writes the flag value passed in (if found), otherwise nil
# 
# RETURN:
#   0 if flag found, otherwise 1
parse_flag_argument() {
  local flag="$1"
  local args=("${@:2}") 
  for (( i=0; i<"${#args[@]}"; i++)); do
    arg="${args[$i]}"
    lower_arg=$(echo "$arg" | tr '[:upper:]' '[:lower:]')
    if [[ "$flag" == "$lower_arg" ]]; then 
      echo "$flag"
      return 0
    fi
  done
  return 1
}

# Parses command line arguments for presence of a key/value pair,
# extracts both values, returns as a comma delimited string on stdout. 
# Key/value pairs can take these forms:
#   * --key=value
#   * --key value
# 
# USAGE: 
#   parse_key_value_argument key args
#   parse_key_value_argument "--type" "$@"
#  
# EXAMPLE:
# ```sh
# --type*)
#   KEY_VALUE=$(parse_key_value_argument "--type" "$@")
#   VALUE=$(echo "$KEY_VALUE" | cut -d "," -f 1);
#   TO_SHIFT=$(echo "$KEY_VALUE" | cut -d "," -f 2);
#   shift $TO_SHIFT
# ```
# STDOUT: 
#   A comma delimited string (if found). EX: "$KEY,$VALUE,"
#   otherwise no write. 
#
# RETURN: 
#   Additional number of positions to shift the arguments.
#   (0 for "key=value", 1 for "key value").
#
parse_key_value_argument() {
  validate_arg "${1}" "${2}"

  local suffix
  local key
  local value

  suffix=${2//${1}/} # $(echo "${2}" | sed "s/${1}//g")
  if [[ -n "$suffix" ]]; then
    logdStdErr "    Found argument (key=value): ${2}"
    key=$(echo "${2}" | sed -E 's/(.*)(=.*)/\1/g')
    value=$(echo "${2}" | sed -E 's/(.*=)(.*)/\2/g')
    logdStdErr "      key: $key value: $value"
    echo "$value,0," # return value, 0 shift
  else
    logdStdErr "    Found argument pair (key value): ${2} ${3}"
    key="${2}"
    PEEK_VALUE=$(echo "$3" | grep -E "^--")
    if [[ "$PEEK_VALUE" != "" ]]; then
      logdStdErr "      Value for argument (${2} ${3}) appears to be another argument and is invalid: Defaulting to value of 1"
      value="1"
      echo "${value},0," # return value of 1, 0 shift
    else 
      value="${3}"
      echo "${value},1," # return value, 1 shift
    fi
  fi
}

# Makes sure that $2 begins with $1. If not, prints a warning to stderr 
validate_arg() {
  local match
  match=$(echo "${2}" | grep -E "^${1}")
  if [[ "$match" == "" ]]; then
    logdStdErr "[WARNING] Expected argument: '$2' to begin with '$1', but does not."  
  fi
}

if [[ -n "$(parse_flag_argument "--help" "${@:1}")" ]]; then
  print_usage
fi

# Ensure our globals are cleared before populating with args
unset -v MODE
MODE="install"
unset -v HATCH_TOOLS_DIR
unset -v IS_DEBUG
unset -v IS_DRY_RUN
unset -v SPECIFIC_TOOL

while [[ $# -gt 0 ]]; do
  logdStdErr "  Inspecting args: ${1}"
  case $1 in
    --help|help) 
      logdStdErr "Found flag: $1"
      print_usage
      exit 100
      ;;
    --debug)
      logdStdErr "Found flag: $1"
      IS_DEBUG="$1"
      ;;
    --dry-run)
      logdStdErr "Found flag: $1"
      IS_DRY_RUN="$1"
      ;;
    --tool*)
      KEY_VALUE=$(parse_key_value_argument "--tool" "$@")
      VALUE=$(echo "$KEY_VALUE" | cut -d "," -f 1);
      TO_SHIFT=$(echo "$KEY_VALUE" | cut -d "," -f 2);
      logdStdErr "    KEY_VALUE: $KEY_VALUE"
      logdStdErr "    VALUE: $VALUE"
      logdStdErr "    TO_SHIFT: $TO_SHIFT"
      SPECIFIC_TOOL="$VALUE"

      # Validate that mode is a valid value (like a Swift Enum)
      if [[ "$SPECIFIC_TOOL" != "zing" && "$SPECIFIC_TOOL" != "echo_pretty" && "$SPECIFIC_TOOL" != "hatch_log" ]]; then
        logdStdErr --red "[ERROR] " --default "Invalid value for SPECIFIC_TOOL: $SPECIFIC_TOOL"
        print_usage
        exit 1
      fi
      shift "$TO_SHIFT"
      ;;

    *) 
      logdStdErr --orange "[ERROR] " --default "Unhandled arg type. Treating as text: \"$1\""        
      ;;
  esac
  shift
done


if [[ -z "$HATCH_TOOLS_DIR" ]]; then
  # Fall back to a default
  HATCH_TOOLS_DIR="$HOME/.hatch"
fi

HATCH_BIN_DIR="${HATCH_TOOLS_DIR}/bin"
HATCH_CONFIG_DIR="${HATCH_TOOLS_DIR}/config"
HATCH_SCRIPT_DIR="${HATCH_TOOLS_DIR}/script"

logdStdErr "IS_DEBUG: $IS_DEBUG"
logdStdErr "IS_DRY_RUN: $IS_DRY_RUN"
logdStdErr "MODE: $MODE"
logdStdErr "HATCH_TOOLS_DIR: $HATCH_TOOLS_DIR"
logdStdErr "HATCH_BIN_DIR: $HATCH_BIN_DIR"
logdStdErr "HATCH_CONFIG_DIR: $HATCH_CONFIG_DIR"
logdStdErr "HATCH_SCRIPT_DIR: $HATCH_SCRIPT_DIR"
logdStdErr "SPECIFIC_TOOL: $SPECIFIC_TOOL"



# shellcheck disable=SC2164
pushd "$SCRIPT_DIR"
logdStdErr "pwd: $PWD"



if [[ -n "$SPECIFIC_TOOL" ]]; then
  
  tools=(
    "../HatchTerminal/.build/release/$SPECIFIC_TOOL" "./tools"
  )
else 
  tools=(
    "../HatchTerminal/.build/release/echo_pretty" "./tools"
    "../HatchTerminal/.build/release/zing" "./tools"
    "../HatchTerminal/.build/release/hatch_log" "./tools"
  )
fi

# if [[ -n "$SPECIFIC_TOOL" ]]; then
#   cp "../HatchTerminal/.build/release/$SPECIFIC_TOOL" "./tools"
# else 
#   cp "../HatchTerminal/.build/release/echo_pretty" "./tools"
#   cp "../HatchTerminal/.build/release/zing" "./tools"
#   cp "../HatchTerminal/.build/release/hatch_log" "./tools"
# fi

set -e

for tool in "${tools[@]}"; do
  if cp "$tool" "./tools"; then
    logdStdErr "  Copied: $tool"
  else 
    logdStdErr --red "[ERROR] " --default "Failed to copy: $tool"
    exit 1
  fi
done


if [[ -z "$IS_DRY_RUN" ]]; then 
  git add tools/
  git commit -m "backing up latest tools"
  git push
fi

for tool in "${tools[@]}"; do
  version=$("$tool" --version 2>/dev/null || echo "n/a")
  log --green "[SUCCESS] Uploaded $tool version: $version"
done

# shellcheck disable=SC2164
popd "$SCRIPT_DIR"
logdStdErr "pwd: $PWD"

