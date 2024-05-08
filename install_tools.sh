#!/bin/bash

# See this code as gist: https://gist.githubusercontent.com/zakkhoyt/c76a013602afded4b5240e6ca457acb0/raw/8764f97ff6bbdd41ca1d4d8290ac051115c91437/shell%2520script%2520arg%2520parsing

# ---- Look for our debug argument first thing (other args processed after bootstrapping).

unset -v IS_DEBUG
for i in "$@"; do
  if [ "$i" == "--debug" ] ; then
    # echo "----- Found"
    IS_DEBUG="true"
  fi
done

# ---- Set up our logging functions

# Writes to stdout using echo_ansi if available
_log_ansi() {
  if which echo_ansi.sh > /dev/null; then
    echo_ansi.sh "$@"
  else 
    # echo_ansi isn't available so let's use echo. But first...
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
  # echo "$@";
  _log_ansi "$@";
}

# Writes to stdout if `--debug` param was specified.
logd() {
  if [[ -n "$IS_DEBUG" ]]; then
    # log "$@"
    log "$@"
  fi
}

# Writes to stderr always
logStdErr() {
  # echo "$@" 1>&2
  _log_ansi "$@" 1>&2
}

# Writes to stderr if `--debug` param was specified.
logdStdErr() {
  if [[ -n "$IS_DEBUG" ]]; then
    # logStdErr "$@"
    logStdErr "$@"
  fi
}

SCRIPT_DIR=$(realpath "$(dirname "$0")")
SCRIPT_NAME=./$(basename "$0")

logdStdErr "SCRIPT_NAME: $SCRIPT_NAME"
logdStdErr "SCRIPT_DIR:  $SCRIPT_DIR"
logdStdErr "PWD:         $PWD"

# ---- Set up our print_usage function

# TODO: zakkhoyt. print_usage

# Prints the example usage to stderr
# Call like so: `print_usage`
print_usage () {
  SCRIPT_NAME=./$(basename "$0")
  logStdErr "TODO"
  logStdErr ""
  logStdErr "Usage:"
  logStdErr "    $SCRIPT_NAME <OPTIONS>"
  logStdErr ""
  logStdErr "Mandatory:"
  logStdErr "    --pull-request-count [int]: The number of items to analyze. Defaults to 1000."
  logStdErr "    --report-type [stale-branches | pull-requests]: The type of report to produce"
  logStdErr ""
  logStdErr "Optional:"
  logStdErr "    --list-authors: List all authors/users as a stanza in the report."
  logStdErr "    --level=[level]: Specify a level."
  logStdErr ""
  logStdErr "EX:"
  logStdErr "    \$ $SCRIPT_NAME --help"
  logStdErr ""
  logStdErr "    TODO: description"
  logStdErr "    \$ $SCRIPT_NAME --pull-request-count 100"
  logStdErr ""
  logStdErr "    TODO: description"
  logStdErr "    \$ $SCRIPT_NAME --pull-request-count 100 --list-authors"
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
unset -v HATCH_TOOLS_DIR
unset -v IS_DEBUG
unset -v IS_DRY_RUN

while [[ $# -gt 0 ]]; do
  logdStdErr "  Inspecting args[$counter]: ${1}"
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
    --output-dir*)
      KEY_VALUE=$(parse_key_value_argument "--output-dir" "$@")
      VALUE=$(echo "$KEY_VALUE" | cut -d "," -f 1);
      TO_SHIFT=$(echo "$KEY_VALUE" | cut -d "," -f 2);
      logdStdErr "    KEY_VALUE: $KEY_VALUE"
      logdStdErr "    VALUE: $VALUE"
      logdStdErr "    TO_SHIFT: $TO_SHIFT"
      HATCH_TOOLS_DIR=$(realpath "$VALUE")

      # Ensure it's really a dir
      if ! [[ -d "$HATCH_TOOLS_DIR" ]]; then
        logdStdErr --red "[ERROR] " --default "HATCH_TOOLS_DIR is NOT a dir"
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
  HATCH_TOOLS_DIR="$HOME/bin/hatch"
fi

logdStdErr "IS_DEBUG: $IS_DEBUG"
logdStdErr "IS_DRY_RUN: $IS_DRY_RUN"
logdStdErr "HATCH_TOOLS_DIR: $HATCH_TOOLS_DIR"

# ---- Script main work

# TODO: zakkhoyt - Move these tools to a public repo so no dealing with tokens. 
# TODO: zakkhoyt - Update text written to .zshrc

mkdir -p "$HATCH_TOOLS_DIR"
pushd "$HATCH_TOOLS_DIR" || exit 1

# Confirm that HATCH_TOOLS_DIR is in PATH
CONFIRM_PATH=$(echo "$PATH" | grep -o "$HATCH_TOOLS_DIR")
if [[ "$CONFIRM_PATH" == "$HATCH_TOOLS_DIR" ]]; then 
  logStdErr --yellow "$HATCH_TOOLS_DIR" --default " is already on " --yellow --bold "PATH" --default
else 

  # TODO: zakkhoyt - Read .zshrc to see if already exists 
  CRITICAL_LINE="export PATH=$PATH:\"$HATCH_TOOLS_DIR\""

  # shellcheck disable=SC2002
  EXISTING_LINE=$(cat "$HOME/.zshrc" | grep -o "$CRITICAL_LINE")

  if [[ "$EXISTING_LINE" != "" ]]; then
    : #already exists. Tell user to source
    logStdErr --yellow "$HOME/.zshrc" --default " is already configured." --default
  else
    if [[ -n "$DRY_RUN" ]]; then
      : # Skip cause --dry-run
    else
      echo "# This section added by $0" >> "$HOME/.zshrc"
      echo "$CRITICAL_LINE" >> "$HOME/.zshrc"
      logStdErr --cyan --underline "$HATCH_TOOLS_DIR" --default " has been added to PATH in " --cyan --underline "$HOME/.zshrc" --default
    fi
  fi
  logStdErr "To update this terminal session: "
  logStdErr "    " --yellow --bold "source $HOME/.zshrc" --default
  logStdErr ""
fi

# Downloads a file, copies it to specified DIR
# 
# 1: Tool name: EX: echo_ansi.sh
#
# 2: Tool source url: Will be downloaded with curl.
#   EX: https://raw.githubusercontent.com/org/repo/main/my_file
#
# 3: Dest dir (where to install the downloaded file)
#   EX: "$HOME/bin"
function install_tool {
  TOOL_NAME="$1"
  TOOL_SRC_URL="$2"
  TOOL_DEST_DIR="$3"
  IS_DRY_RUN="$4"

  logdStdErr "install_tool called with params:"
  logdStdErr "    TOOL_NAME: $TOOL_NAME"
  logdStdErr "    TOOL_SRC_URL: $TOOL_SRC_URL"
  logdStdErr "    TOOL_DEST_DIR: $TOOL_DEST_DIR"


  if ls "${TOOL_DEST_DIR}/$TOOL_NAME" 1> /dev/null; then 
    logStdErr --yellow "$TOOL_NAME" --default " is already installed: " --cyan --underline "${TOOL_DEST_DIR}" --default
  else 
    logStdErr "Installing " --cyan --underline "${TOOL_DEST_DIR}/$TOOL_NAME" --default

    # Install $TOOL_NAME
    command="curl -L \"$TOOL_SRC_URL\" --output \"${TOOL_DEST_DIR}/$TOOL_NAME\""

    logdStdErr "command: " --yellow --bold "$command" --default
    if [[ -z "$DRY_RUN" ]]; then
      eval "$command"

      # Ensure that it's executable
      chmod +x "${TOOL_DEST_DIR}/$TOOL_NAME"

      # TODO: zakkhoyt. Test each tool using which
    fi
  fi

  logdStdErr ""
}

install_tool "echo_ansi.sh" \
  "https://raw.githubusercontent.com/hatch-mobile/zakk_scripts/main/shell/bin/echo_ansi\?token\=GHSAT0AAAAAACK6UDPM2LKVEQMERIY6U5AUZR323EA" \
  "$HATCH_TOOLS_DIR" \
  "$IS_DRY_RUN"

install_tool "hatch_log.sh" \
  "https://raw.githubusercontent.com/hatch-mobile/zakk_scripts/main/shell/bin/hatch_log.sh?token=GHSAT0AAAAAACK6UDPMR5G7KTC657DCM34KZR33AZQ" \
  "$HATCH_TOOLS_DIR" \
  "$IS_DRY_RUN"

logStdErr ""
logStdErr "Listing ${TOOL_DEST_DIR}"
ls -al

