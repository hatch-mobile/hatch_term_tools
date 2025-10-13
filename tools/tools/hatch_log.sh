#!/bin/bash

# TODO: zakkhoyt. Write up on terms: arguments, flags, params, values, optional args vs mandatory args, etc...
# <> denotes a required field
# [] denotes an optional field
# EX from swift.ArgumentParser: USAGE: echo-swift-parser <files> ... [--count <the amount>] [--index <the amount>] --things <the things that make up the thing> ... [--enable-verbose] [--disable-verbose] [--strip-whitespace]

# TODO: zakkhoyt. Custom time format would be nice (env var)

# TODO: zakkhoyt. Identify convention for help vs man page.
# TODO: zakkhoyt. Add support for a the print_usage.sh functions.

# TODO: zakkhoyt. Add official support for `none` level (-n)
# TODO: zakkhoyt. Add support for a stderr message that you would print before exiting non-0 (bad parm value for example)
# TODO: zakkhoyt. Add support for an empty line on stderr. `hatch_log -d ""` will print leading [DEBUG] etc...

# ------ To test hatch_log in a consumer:
# ```sh
# export HATCH_LOG_MASK="verbose"
# export HATCH_LOG_USE_COLOR="true"
# export HATCH_LOG_USE_TIME="true"
# hatch_log "testing none"
# hatch_log -i "testing info"
# hatch_log -d "testing debug"
# hatch_log -w "testing warning"
# hatch_log -e "testing error"
# hatch_log -v "testing verbose"
# ```



# TODO: zakkhoyt. Move this section to a test file
# # ------ Some test code (move to a test file)
# hatch_log " ---- Testing all log levels"
# hatch_log "testing none"
# hatch_log -i "testing info"
# hatch_log -d "testing debug"
# hatch_log -w "testing warning"
# hatch_log -e "testing error"
# hatch_log -v "testing verbose"

# hatch_log " ---- redirecting stdout to /dev/null"
# hatch_log "testing none" 1> /dev/null
# hatch_log -i "testing info" 1> /dev/null
# hatch_log -d "testing debug" 1> /dev/null
# hatch_log -w "testing warning" 1> /dev/null
# hatch_log -e "testing error" 1> /dev/null
# hatch_log -v "testing verbose" 1> /dev/null

# hatch_log " ---- redirecting stderr to /dev/null"
# hatch_log "testing none" 2> /dev/null
# hatch_log -i "testing info" 2> /dev/null
# hatch_log -d "testing debug" 2> /dev/null
# hatch_log -w "testing warning" 2> /dev/null
# hatch_log -e "testing error" 2> /dev/null
# hatch_log -v "testing verbose" 2> /dev/null




# ------ Set up PATH for consumption of other tools

# Modify PATH for this shell context and descendents only
SCRIPT_DIR=$(dirname "$(realpath "${BASH_SOURCE:0}")")
# echo "SCRIPT_DIR: $SCRIPT_DIR" 1>&2
HATCH_UTILS_BIN_DIR="$SCRIPT_DIR"
export PATH="$HATCH_UTILS_BIN_DIR:$PATH"

# ---- Helper functions for the rest of the script
# TODO: zakkhoyt. Replace these wtih print_usage? or is this acceptable for this script?

# Writes to stderr always
# Useful for invalid input or --help
logStdErr() {
  echo_ansi "$@" 1>&2
}

# Writes to stderr if `--DEBUG` param was specified.
logdStdErr() {
  if [[ -n "$IS_DEBUG" ]]; then
    logStdErr "$@"
  fi
}

# ------ PATH approach
# Modify PATH for this shell context and descendents only
SCRIPT_DIR=$(dirname "$(realpath "${BASH_SOURCE:0}")")
HATCH_UTILS_BIN_DIR="$SCRIPT_DIR"
export PATH="$PATH:$HATCH_UTILS_BIN_DIR"

# shellcheck disable=SC1091
source "${HATCH_UTILS_BIN_DIR}/print_usage.sh"


# Prints the example usage to stderr. Exits code 1
# Call like so: `printUsage`
printUsage () {
  SCRIPT_NAME=./$(basename "$0")

  log_se_h1 "NAME"
  log_se "${TAB}${TAB}" --bold "$SCRIPT_NAME" --default " - An echo like logging utility."
  log_se_empty

  log_se_h1 "SYNOPSIS"
  log_se "${TAB}${TAB}" --bold "$SCRIPT_NAME"  --bold " message" --default " [" --bold "--level" --default "=level" --default "]"
  log_se "${TAB}${TAB}" --bold "$SCRIPT_NAME"  --bold " message" --default " [" --bold "--color" --default "]"
  log_se "${TAB}${TAB}" --bold "$SCRIPT_NAME"  --bold " message" --default " [" --bold "-idewv" --default "]"
  log_se "${TAB}${TAB}" --bold "$SCRIPT_NAME"  --bold " message" --default " [" --bold " -i " --default " | " --bold " -d " --default " | " --bold " -e " --default " | " --bold " -w " --default " | " --bold " -v " --default "] "
  log_se_empty

  log_se_h1 "DESCRIPTION"
  log_se "${TAB}${TAB}This tool is used a lot like " --bold "echo" --default " or " --bold "echo_ansi" --default ". It writes to stdout and stderr depending on the " --bold "level" --default " parameter."
  log_se_empty
  log_se_h2 "LEVEL"
  log_se "${TAB}" --bold "${TAB}--level" --default "${TAB}${TAB}" "Sets the log level of the current command (defaults to none)."
  log_se_h3 "TODO: write about HATCH_LOG_MASK"
  log_se "${TAB}${TAB}If a level is specified then the output will be prefixed with a string equivalent."
  log_se "${TAB}${TAB}No level means no prefix (output = input)."
  log_se_empty
  log_se "${TAB}" --bold "${TAB}-i" --default " | " --bold "--level info    " --default "${TAB}${TAB}[INFO]" --default
  log_se "${TAB}" --bold "${TAB}-d" --default " | " --bold "--level debug   " --default "${TAB}${TAB}[DEBUG]" --default
  log_se "${TAB}" --bold "${TAB}-e" --default " | " --bold "--level error   " --default "${TAB}${TAB}[ERROR]" --default
  log_se "${TAB}" --bold "${TAB}-w" --default " | " --bold "--level warning " --default "${TAB}${TAB}[WARNING]" --default
  log_se "${TAB}" --bold "${TAB}-v" --default " | " --bold "--level verbose " --default "${TAB}${TAB}[VERBOSE]" --default
  log_se "${TAB}" --bold "${TAB}(none)" --default "" --default "${TAB}${TAB}${TAB}${TAB}${TAB}${TAB}${TAB}${TAB}${TAB} " "plain message" --default
  log_se_empty

  log_se_h2 "COLOR"
  log_se "${TAB}" --bold "${TAB}--color" --default "${TAB}${TAB}" "Print each line in color."
  log_se "${TAB}${TAB}Can also be enabled by setting the " --bold "\$HATCH_LOG_USE_COLOR" --default " ENV var."
  log_se "${TAB}${TAB}The color values are derived from " --bold "level" --default "."
  log_se "${TAB}" --bold "${TAB}-i" --default "${TAB}${TAB}${TAB}${TAB}" --white "[INFO] A log message" --default
  log_se "${TAB}" --bold "${TAB}-d" --default "${TAB}${TAB}${TAB}${TAB}" --yellow "[DEBUG] A log message" --default
  log_se "${TAB}" --bold "${TAB}-e" --default "${TAB}${TAB}${TAB}${TAB}" --red "[ERROR] A log message" --default
  log_se "${TAB}" --bold "${TAB}-w" --default "${TAB}${TAB}${TAB}${TAB}" --orange "[WARNING] A log message" --default
  log_se "${TAB}" --bold "${TAB}-v" --default "${TAB}${TAB}${TAB}${TAB}" --cyan "[VERBOSE] A log message" --default
  log_se "${TAB}" --bold "${TAB}(none)" --default "" --default "${TAB}${TAB}" "A log message" --default
  log_se_empty
    
  log_se_h2 "TIME"
  log_se "${TAB}" --bold "${TAB}--time" --default "${TAB}${TAB}" "Prefix line with a timestamp." --default
  log_se "${TAB}${TAB}Can also be enabled by setting the " --bold "\$HATCH_LOG_USE_TIME" --default " ENV var."
  log_se_empty

# TODO: zakkhoyt. Finish this env var section colors using ENV vars
  log_se_h1 "ENV VARS"
  log_se_h2 "LOG LEVEL"
  log_se_h3 "HATCH_LOG_MASK"
  log_se_h3 "HATCH_LOG_USE_COLOR"
  log_se_h3 "HATCH_LOG_USE_TIME"
  log_se_empty

  # log_se "${TAB}${TAB}Until this variable contains a value, only logs with no level set will be output."
  # log_se "${TAB}${TAB}Only logs with no level assigned"
  # log_se "${TAB}${TAB}" --bold "unset -v HATCH_LOG_MASK_NONE" --default
  # log_se "${TAB}${TAB}Only logs with no level assigned"
  # log_se "${TAB}${TAB}" --bold "export HATCH_LOG_MASK_ERROR=error" --default " The above plus error level logs."
  # log_se "${TAB}${TAB}" --bold "export HATCH_LOG_MASK_WARNING=warning" --default " The above plus warning level logs."
  # log_se "${TAB}${TAB}" --bold "export HATCH_LOG_LEVEL=info" --default " The above plus info level logs."
  # log_se "${TAB}${TAB}" --bold "export HATCH_LOG_MASK_DEBUG=debug" --default " The above plus debug level logs."
  # log_se "${TAB}${TAB}" --bold "export HATCH_LOG_MASK_VERBOSE=verbose" --default " The above plus verbose level logs."

  log_se_h1 "EXAMPLES"
  log_se "${TAB}${TAB}" --bold ">" --default ' hatch_log "A log message to stdout"'
  printf "%s" "${TAB}${TAB}"; hatch_log "A log message to stdout"
  log_se_empty
  log_se "${TAB}${TAB}" --bold ">" --default ' hatch_log -i "An info message to stderr"'
  printf "%s" "${TAB}${TAB}"; hatch_log -i "An info message to stderr"
  log_se_empty
  log_se "${TAB}${TAB}" --bold ">" --default ' hatch_log --info "An info message to stderr"'
  printf "%s" "${TAB}${TAB}"; hatch_log --info "An info message to stderr"
  log_se_empty
  log_se "${TAB}${TAB}" --bold ">" --default ' hatch_log --color --info "An info message to stderr w/color"'
  printf "%s" "${TAB}${TAB}"; hatch_log --color --info "An info message to stderr w/color"
  log_se_empty
  log_se "${TAB}${TAB}" --bold ">" --default ' hatch_log --color --error "An error message to stderr w/color"'
  printf "%s" "${TAB}${TAB}"; hatch_log --color --error "An error message to stderr w/color"
  log_se_empty
  log_se "${TAB}${TAB}" --bold ">" --default ' hatch_log --color --warning "An warning message to stderr w/color"'
  printf "%s" "${TAB}${TAB}"; hatch_log --color --warning "An warning message to stderr w/color"
  log_se_empty
  log_se "${TAB}${TAB}" --bold ">" --default ' hatch_log --time --color --warning "An warning message to stderr w/time & color"'
  printf "%s" "${TAB}${TAB}"; hatch_log --time --color --warning "An warning message to stderr w/time & color"
  log_se_empty
}

# Ensure our globals are cleared before populating with args

unset -v IS_DEBUG
unset -v HATCH_LOG_LEVEL
LOG_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      logdStdErr "Found flag arg: '$1'"
      printUsage  
      exit 1
      ;;
    --DEBUG)
      # This arg was processed at the top of the script, so not much to do in this case.
      IS_DEBUG="$1"
      logdStdErr "Found flag arg: '$1'"
      ;;

    --level=*)
      logdStdErr "Found key=value arg: '$1'. Parsing key/value..."
      key=$(echo "$1" | sed -E 's/(.*)(=.*)/\1/g')
      value=$(echo "$1" | sed -E 's/(.*=)(.*)/\2/g')
      logdStdErr "  key: '$key' value: '$value'"
      HATCH_LOG_LEVEL="$value"
      ;;

    --LEVEL)
      logdStdErr "Found arg pair w/key: '$1' Parsing value..."
      if [[ $2 != "info" && $2 != "debug" && $2 != "error" && $2 != "warning" && $2 != "verbose" ]]; then
        logStdErr "[ERROR] Invalid value for '$1': '$2'. Must be > 0."
        printUsage "$0"
        exit 1
      fi
      logdStdErr "  key: '$1' value: '$2'"
      HATCH_LOG_LEVEL="$2"
      shift 1
      ;;
    
    -n|--none)
      logdStdErr "Found flag arg: '$1'"
      HATCH_LOG_LEVEL=""
      ;;
    -i|--info)
      logdStdErr "Found flag arg: '$1'"
      HATCH_LOG_LEVEL="info"
      ;;
    -d|--debug)
      logdStdErr "Found flag arg: '$1'"
      HATCH_LOG_LEVEL="debug"
      ;;
    -w|--warn|--warning)
      logdStdErr "Found flag arg: '$1'"
      HATCH_LOG_LEVEL="warning"
      ;;
    -e|--error)
      logdStdErr "Found flag arg: '$1'"
      HATCH_LOG_LEVEL="error"
      ;;
    -v|--verbose)
      logdStdErr "Found flag arg: '$1'"
      HATCH_LOG_LEVEL="verbose"
      ;;
    -t|--time)
      logdStdErr "Found flag arg: '$1'"
      HATCH_LOG_USE_TIME=true
      ;;
    -c|--color)
      logdStdErr "Found flag arg: '$1'"
      HATCH_LOG_USE_COLOR=true
      ;;
    *)
      echo "$1" | grep -E "^-{1,2}" > /dev/null
      RVAL=$?
      if [[ "$RVAL" -eq 0 ]]; then 
        logStdErr "[ERROR] Found unsupported argument: $1"
        exit 1
      else
        logdStdErr "Found arg flag: '$1'"
        logdStdErr "  Appending to LOG_ARGS"
        LOG_ARGS+=("$1")
      fi
      ;;
  esac
  shift 1
done

# ---- Validate that required args have been passed in.  

# Writes to stderr including file/line if PULL_REQUEST_COUNT is not defined

# : "${HATCH_LOG_LEVEL:?[ERROR] An parameter is required for --level}"
logdStdErr "HATCH_LOG_LEVEL: $HATCH_LOG_LEVEL"
logdStdErr "HATCH_LOG_MASK: $HATCH_LOG_MASK"
logdStdErr "HATCH_LOG_USE_TIME: $HATCH_LOG_USE_TIME"
logdStdErr "HATCH_LOG_USE_COLOR: $HATCH_LOG_USE_COLOR"
logdStdErr "LOG_ARGS: " "${LOG_ARGS[@]}"

COLOR_PREFIX=""
COLOR_POSTFIX=""
if [[ -n "$HATCH_LOG_USE_COLOR" ]]; then
  case ${HATCH_LOG_LEVEL} in
    info) COLOR_PREFIX="--white";;
    debug) COLOR_PREFIX="--yellow";;
    warning) COLOR_PREFIX="--orange";;
    error) COLOR_PREFIX="--red";;
    verbose) COLOR_PREFIX="--cyan";;
    *) COLOR_PREFIX="--default";;
  esac
fi

TIME_PREFIX=""
TIME_POSTFIX=""
if [[ -n "$HATCH_LOG_USE_TIME" ]]; then
  case ${HATCH_LOG_LEVEL} in
    info|debug|warning|error|verbose) TIME_PREFIX=$(date -u -Iseconds); TIME_POSTFIX=" ";;
    *) TIME_PREFIX=""; TIME_POSTFIX="";;
  esac
fi

LEVEL_PREFIX=""
LEVEL_POSTFIX=""
case ${HATCH_LOG_LEVEL} in
  info) LEVEL_PREFIX="[INFO]"; LEVEL_POSTFIX=" ";;
  debug) LEVEL_PREFIX="[DEBUG]"; LEVEL_POSTFIX=" ";;
  warning) LEVEL_PREFIX="[WARNING]"; LEVEL_POSTFIX=" ";;
  error) LEVEL_PREFIX="[ERROR]"; LEVEL_POSTFIX=" ";;
  verbose) LEVEL_PREFIX="[VERBOSE]"; LEVEL_POSTFIX=" ";;
  *) ;;
esac

# Debug print our values
logdStdErr "COLOR_PREFIX: '$COLOR_PREFIX'"
logdStdErr "COLOR_POSTFIX: '$COLOR_POSTFIX'"
logdStdErr "TIME_PREFIX: '$TIME_PREFIX'"
logdStdErr "TIME_POSTFIX: '$TIME_POSTFIX'"
logdStdErr "LEVEL_PREFIX: '$LEVEL_PREFIX'"
logdStdErr "LEVEL_POSTFIX: '$LEVEL_POSTFIX'"

unset -v HATCH_LOG_MASK_VAL
if [[ $HATCH_LOG_MASK == "error" ]]; then
  HATCH_LOG_MASK_VAL=10
elif [[ $HATCH_LOG_MASK == "warning" ]]; then
  HATCH_LOG_MASK_VAL=20
elif [[ $HATCH_LOG_MASK == "info" ]]; then
  HATCH_LOG_MASK_VAL=30
elif [[ $HATCH_LOG_MASK == "debug" ]]; then
  HATCH_LOG_MASK_VAL=40
elif [[ $HATCH_LOG_MASK == "verbose" ]]; then
  HATCH_LOG_MASK_VAL=50
fi


logdStdErr "HATCH_LOG_MASK_VAL: $HATCH_LOG_MASK_VAL"

case ${HATCH_LOG_LEVEL} in
  error)
    if [[ $HATCH_LOG_MASK_VAL -ge 10 ]]; then
      echo_ansi "${COLOR_PREFIX}" "${COLOR_POSTFIX}" "${TIME_PREFIX}" "${TIME_POSTFIX}" "${LEVEL_PREFIX}" "${LEVEL_POSTFIX}" "${LOG_ARGS[*]}" --default 1>&2
    fi
    ;;
  warning)
    if [[ $HATCH_LOG_MASK_VAL -ge 20 ]]; then
      echo_ansi "${COLOR_PREFIX}" "${COLOR_POSTFIX}" "${TIME_PREFIX}" "${TIME_POSTFIX}" "${LEVEL_PREFIX}" "${LEVEL_POSTFIX}" "${LOG_ARGS[*]}" --default 1>&2
    fi
    ;;
  info)
    if [[ $HATCH_LOG_MASK_VAL -ge 30 ]]; then
      echo_ansi "${COLOR_PREFIX}" "${COLOR_POSTFIX}" "${TIME_PREFIX}" "${TIME_POSTFIX}" "${LEVEL_PREFIX}" "${LEVEL_POSTFIX}" "${LOG_ARGS[*]}" --default 1>&2
    fi
    ;;
  debug)
    if [[ $HATCH_LOG_MASK_VAL -ge 40 ]]; then
      echo_ansi "${COLOR_PREFIX}" "${COLOR_POSTFIX}" "${TIME_PREFIX}" "${TIME_POSTFIX}" "${LEVEL_PREFIX}" "${LEVEL_POSTFIX}" "${LOG_ARGS[*]}" --default 1>&2
    fi
    ;;
  verbose)
    if [[ $HATCH_LOG_MASK_VAL -ge 50 ]]; then
      echo_ansi "${COLOR_PREFIX}" "${COLOR_POSTFIX}" "${TIME_PREFIX}" "${TIME_POSTFIX}" "${LEVEL_PREFIX}" "${LEVEL_POSTFIX}" "${LOG_ARGS[*]}" --default 1>&2
    fi
    ;;
  *) 
    echo_ansi "${COLOR_PREFIX}" "${COLOR_POSTFIX}" "${TIME_PREFIX}" "${TIME_POSTFIX}" "${LEVEL_PREFIX}" "${LEVEL_POSTFIX}" "${LOG_ARGS[*]}" --default
    ;;
esac




