#!/bin/bash

# This script was derived from a gist which provides boilerplate
# for argument parsing (flags, options, key/value pairs, etc..), 
# usage/help, printing/logging, and more: 
# https://gist.github.com/zakkhoyt/c76a013602afded4b5240e6ca457acb0

# TODO: zakkhoyt - Support config dir, 
# HATCH_TOOLS_DIR=root dir, not root/bin
# rename HATCH_TOOLS_DIR -> HATCH_BIN_DIR
#
# HATCH_BIN_DIR="${HATCH_TOOLS_DIR}/bin"
# HATCH_CONFIG_DIR="${HATCH_TOOLS_DIR}/config"
# HATCH_SCRIPT_DIR="${HATCH_TOOLS_DIR}/script"
#
# [ ] Test


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
  logStdErr "Installs hatch command line tools"
  logStdErr ""
  logStdErr "Usage:"
  logStdErr "    $SCRIPT_NAME [OPTIONS]"
  logStdErr ""
  logStdErr "Mandatory:"
  logStdErr ""
  logStdErr "Optional:"
  logStdErr "    --mode [install|uninstall]: The installation mode"
  logStdErr "         Default: install"
  # logStdErr "    --hatch-tools-dir <dir>: The directory to install tools to."
  # logStdErr "         Directory will be created."
  # logStdErr "         Default: ~/.hatch/bin"
  logStdErr "    --dry-run: Print intended commands/actions but don't execute."
  logStdErr "    --debug: Enables debug logging to stderr."
  logStdErr "    --help: Prints this message"
  logStdErr ""
  logStdErr "EX:"
  logStdErr "    Print help"
  logStdErr "    \$ $SCRIPT_NAME --help"
  logStdErr ""
  logStdErr "    Normal installation"
  logStdErr "    \$ $SCRIPT_NAME"
  logStdErr ""
  logStdErr "    Custom destination"
  logStdErr "    \$ $SCRIPT_NAME --hatch-tools-dir=\"~/my_fav_dir\""
  logStdErr ""
  logStdErr "    Uninstall"
  logStdErr "    \$ $SCRIPT_NAME" --mode=uninstall
  logStdErr "    \$ $SCRIPT_NAME --mode=uninstall --hatch-tools-dir=\"~/my_fav_dir\""
  logStdErr ""
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
    --mode*)
      KEY_VALUE=$(parse_key_value_argument "--mode" "$@")
      VALUE=$(echo "$KEY_VALUE" | cut -d "," -f 1);
      TO_SHIFT=$(echo "$KEY_VALUE" | cut -d "," -f 2);
      logdStdErr "    KEY_VALUE: $KEY_VALUE"
      logdStdErr "    VALUE: $VALUE"
      logdStdErr "    TO_SHIFT: $TO_SHIFT"
      MODE="$VALUE"

      # Validate that mode is a valid value (like a Swift Enum)
      if [[ "$MODE" != "install" && "$MODE" != "uninstall" ]]; then
        logdStdErr --red "[ERROR] " --default "Invalid value for MODE: $MODE"
        print_usage
        exit 1
      fi
      shift "$TO_SHIFT"
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
  # shellcheck disable=SC2016
  HATCH_TOOLS_DIR='$HOME/.hatch'
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

# ---- Script main work

mkdir -p "$HATCH_TOOLS_DIR"
mkdir -p "$HATCH_BIN_DIR"
mkdir -p "$HATCH_CONFIG_DIR"
mkdir -p "$HATCH_SCRIPT_DIR"

pushd "$HATCH_BIN_DIR" || exit 1

function refresh_environment {
  # Use echo here w/ansi codes vs calling echo_ansi to cover all cases (installed or not)
  echo 
  echo -e "The value of \x1B[1mPATH\x1B[0m has changed thus the environment should be reloaded.\x1B[0m"
  echo -e "\033[1m\033[5mOpen a new terminal or update the current session:\n    \033[0m\033[93m\033[1msource ~/.zshrc\033[0m"
}

function configure_path {
  logdStdErr "configure_path called ------------------------------------------ "

  RC_HEADER_LINE="# This section added by https://raw.githubusercontent.com/hatch-mobile/hatch_term_tools/main/configure_tools.sh"

  # shellcheck disable=SC2116
  # shellcheck disable=SC2016
  CRITICAL_LINE="export PATH=$(echo '$PATH'):$HATCH_BIN_DIR"

  if [[ "$MODE" == "uninstall" ]]; then
    # Delete relevant PATH lines from .zshrc
    first_line=$(grep -n "$RC_HEADER_LINE" ~/.zshrc | cut -d ":" -f 1 | head -n 1)
    second_line=$((first_line+1))
    if [[ "$first_line" == "" || "$second_line" == "" ]]; then
      logStdErr "Nothing to delete in " --cyan --underline "$HOME/.zshrc" --default
    else 

      if [[ -n "$IS_DRY_RUN" ]]; then
        logStdErr "[--dry-run] Would delete PATH lines from " --cyan --underline "$HOME/.zshrc" --default
      else
        sed -i '' -e "${first_line},${second_line}d" ~/.zshrc
        logStdErr "Did delete PATH lines from " --cyan --underline "$HOME/.zshrc" --default
      fi 
    fi
    
    # Refresh PATH
    logdStdErr "PATH before deleting: $PATH"
    # shellcheck disable=SC2001
    PATH=$(echo "$PATH" | sed -e "s|$HATCH_BIN_DIR||g")
    logdStdErr "PATH after deleting: $PATH"

    refresh_environment

  elif [[ "$MODE" == "install" ]]; then
    CONFIRM_PATH=$(echo "$PATH" | grep -o "$HATCH_BIN_DIR")
    if [[ "$CONFIRM_PATH" == "$HATCH_BIN_DIR" ]]; then 
      logStdErr --yellow "$HATCH_BIN_DIR" --default " is already on " --yellow --bold "PATH" --default
    else 
      # shellcheck disable=SC2002
      EXISTING_LINE=$(cat "$HOME/.zshrc" | grep -o "$CRITICAL_LINE")

      if [[ "$EXISTING_LINE" != "" ]]; then
        : # Already exists in . Tell user to source
        logStdErr --yellow "$HOME/.zshrc" --default " is already configured." --default
      else
        if [[ -n "$IS_DRY_RUN" ]]; then
          # Skip cause --dry-run
          logStdErr "[--dry-run] "--cyan --underline "$HATCH_BIN_DIR" --default " would have been added to PATH in " --cyan --underline "$HOME/.zshrc" --default
        else
          echo "$RC_HEADER_LINE" >> "$HOME/.zshrc"
          echo "$CRITICAL_LINE" >> "$HOME/.zshrc"
          logStdErr --cyan --underline "$HATCH_BIN_DIR" --default " has been added to PATH in " --cyan --underline "$HOME/.zshrc" --default
        fi
      fi
      
      refresh_environment
    fi
  fi
}

# Downloads a file, copies it to specified DIR
# 
# 1: Tool name: EX: echo_ansi
#
# 2: Tool source: If URL, download with curl else copy local
#   EX: https://raw.githubusercontent.com/org/repo/main/my_file
#
# 3: Dest dir (where to install the downloaded file)
#   EX: "$HOME/bin"
# 
# 4: (optional) Dry run flag. If present, dry run mode will be used
function configure_tool {
  TOOL_NAME="$1"
  TOOL_SOURCE="$2"
  TOOL_DEST_DIR="$3"
  IS_DRY_RUN="$4"
  TOOL_PATH="$TOOL_DEST_DIR/$TOOL_NAME"

  logdStdErr "configure_tool called with params:"
  logdStdErr "    TOOL_NAME: $TOOL_NAME"
  logdStdErr "    TOOL_SOURCE: $TOOL_SOURCE"
  logdStdErr "    TOOL_DEST_DIR: $TOOL_DEST_DIR"
  logdStdErr "    IS_DRY_RUN: $IS_DRY_RUN"
  logdStdErr "    TOOL_PATH: $TOOL_PATH"

  # TODO: zakkhoyt - Nice2Have: MODE == "reinstall"
  if [[ "$MODE" == "uninstall" ]]; then
    if [[ -n "$IS_DRY_RUN" ]]; then
      logdStdErr "[--dry-run] Would have deleted tool: " --cyan --underline "$TOOL_PATH" --default
    else 
      # Delete the tool
      rm -f "$TOOL_PATH"
      logStdErr "Deleted tool: " --cyan --underline "$TOOL_PATH" --default
    fi
  else
    logdStdErr "Install command: " --yellow --bold "$command" --default

    # TODO: zakkhoyt - Nice2Have: install files from local repo
    
    # # if local file, copy. Else assume it's a URL and use curl. 
    # if ! [[ -f "$TOOL_PATH" ]]; then
    #   command="cp \"$TOOL_SOURCE\" \"${TOOL_DEST_DIR}/$TOOL_NAME\""
    # else
    #   command="curl -L \"$TOOL_SOURCE\" --output \"${TOOL_PATH}\""
    # fi
    command="curl -L \"$TOOL_SOURCE\" --output \"${TOOL_PATH}\""

    # if ls "${TOOL_DEST_DIR}/$TOOL_NAME" > /dev/null 2>&1; then 
    #   logStdErr --yellow "$TOOL_NAME" --default " is already installed: " --cyan --underline "${TOOL_DEST_DIR}" --default
    # else 

    logdStdErr "Will install " --cyan --underline "${TOOL_DEST_DIR}/$TOOL_NAME" --default
    if [[ -n "$IS_DRY_RUN" ]]; then
      logdStdErr "[--dry-run] Skipped install " --cyan --underline "${TOOL_DEST_DIR}/$TOOL_NAME" --default
    else
      eval "$command"

      # set -x
      # Ensure that it's executable
      chmod +x "${TOOL_DEST_DIR}/${TOOL_NAME}"

      if ls "${TOOL_DEST_DIR}/${TOOL_NAME}" > /dev/null 2>&1; then 
        logStdErr "Did install " --cyan --underline "${TOOL_DEST_DIR}/$TOOL_NAME" --default
      else 
        logStdErr --red --bold "[ERROR]" --default ": Failed to install " --cyan --underline "${TOOL_DEST_DIR}/$TOOL_NAME" --default
      fi
      # set +x
    fi
  fi

  logdStdErr ""
  # fi
}

configure_tool "echo_ansi" \
  "https://raw.githubusercontent.com/hatch-mobile/hatch_term_tools/main/tools/echo_ansi" \
  "$HATCH_BIN_DIR" \
  "$IS_DRY_RUN"

configure_tool "hatch_log.sh" \
  "https://raw.githubusercontent.com/hatch-mobile/hatch_term_tools/main/tools/hatch_log.sh" \
  "$HATCH_BIN_DIR" \
  "$IS_DRY_RUN" 

configure_tool "echo_pretty" \
  "https://raw.githubusercontent.com/hatch-mobile/hatch_term_tools/main/tools/echo_pretty" \
  "$HATCH_BIN_DIR" \
  "$IS_DRY_RUN" 

configure_tool "hatch_log" \
  "https://raw.githubusercontent.com/hatch-mobile/hatch_term_tools/main/tools/hatch_log" \
  "$HATCH_BIN_DIR" \
  "$IS_DRY_RUN" 

configure_tool "zing" \
  "https://raw.githubusercontent.com/hatch-mobile/hatch_term_tools/main/tools/zing" \
  "$HATCH_BIN_DIR" \
  "$IS_DRY_RUN" 

configure_path 
