#!/bin/bash

# This script function (`echo_ansi`) can be used just like `echo`, 
# but allows adds a bunch of arguments to make using ANSI codes easier. 

# TODO: zakkhoyt. ENV var support or auto inclusion of --default at the end of every call
# TODO: zakkhoyt. implmement 38;2;R;G;B
# TODO: zakkhoyt. Support for hex colors (EX: 0xFF)

# set -x
# set -e

# Looks for the presencse of a `--debug` argument. Sets env var. 
unset -v ANSI_DEBUG
for i in "$@"; do
  if [[ "$i" == "--debug" ]]; then
    ANSI_DEBUG="true"
  fi
done

# ---- Set up our functions

# log to stderr
ansi_log_se() {
  # FIXME: zakkhoyt. Deal with leading space when $@ begins with a '--'
  
  # shellcheck disable=SC2059
  printf " $@" 1>&2
  printf "\n" 1>&2
}

# log to stderr if ANSI_DEBUG is set
ansi_log_se_d() {
  if [[ -n "$ANSI_DEBUG" ]]; then
    ansi_log_se "$@"
  fi
}

# logs an H1 line (bold, no indent) to stderr 
ansi_log_se_h1() {
  ansi_log_se "$(ansi_code "$ANSI_FONT_BOLD")$1$(ansi_code "$ANSI_DEFAULT")"
}

# logs an H2 line (bold, indented 2 spaces) to stderr 
ansi_log_se_h2() {
  ansi_log_se "  $(ansi_code "$ANSI_FONT_BOLD")$1$(ansi_code "$ANSI_DEFAULT")"
}

# logs an H2 line (bold/italic, indented 4 spaces) to stderr 
ansi_log_se_h3() {
  ansi_log_se "    $(ansi_code "$ANSI_FONT_BOLD")$(ansi_code "$ANSI_FONT_ITALIC")$1$(ansi_code "$ANSI_DEFAULT")"
}

# logs an empty line to stderr
ansi_log_se_empty() {
  ansi_log_se ""
}

# Call like so: `printUsage`
printUsage() {
  SCRIPT_NAME=./$(basename "$0")

  ansi_log_se_h1 "NAME"
  ansi_log_se "  $SCRIPT_NAME - An echo like utility with support for colors, blinking, fonts, cursor navitation, and more."
  ansi_log_se_empty
  
  ansi_log_se_h1 "SYNOPSIS"
  ansi_log_se "  $SCRIPT_NAME [flags] <text> [flags] <text>"
  ansi_log_se_empty
  
  ansi_log_se_h1 "DESCRIPTION"
  ansi_log_se "  Like the echo command, but with support for ANSI codes through command line arguments"
  ansi_log_se_empty
    
  ansi_log_se_h1 "DESCRIPTION"
  ansi_log_se_h2 "Resetting to Defaults"
  ansi_log_se "      --|--default: Reset everything (foreground, background, bold, blink, etc...) back to defaults."
  ansi_log_se_empty

  ansi_log_se_h2 "Foreground Colors"
  ansi_log_se_h3 "3-Bit/4-Bit"
  ansi_log_se "      -b|-black: $(ansi_code "$ANSI_FG_BLACK")Foreground color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      -r|-red: $(ansi_code "$ANSI_FG_RED")Foreground color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      -g|-green: $(ansi_code "$ANSI_FG_GREEN")Foreground color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      -y|-yellow: $(ansi_code "$ANSI_FG_YELLOW")Foreground color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      -b|-blue: $(ansi_code "$ANSI_FG_BLUE")Foreground color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      -m|-magenta: $(ansi_code "$ANSI_FG_MAGENTA")Foreground color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      -c|-cyan: $(ansi_code "$ANSI_FG_CYAN")Foreground color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      -w|-white: $(ansi_code "$ANSI_FG_WHITE")Foreground color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se_empty
  ansi_log_se "      --b|--black: $(ansi_code "$ANSI_FG_BRIGHT_BLACK")Foreground color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --r|--red: $(ansi_code "$ANSI_FG_BRIGHT_RED")Foreground color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --g|--green: $(ansi_code "$ANSI_FG_BRIGHT_GREEN")Foreground color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --y|--yellow: $(ansi_code "$ANSI_FG_BRIGHT_YELLOW")Foreground color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --b|--blue: $(ansi_code "$ANSI_FG_BRIGHT_BLUE")Foreground color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --m|--magenta: $(ansi_code "$ANSI_FG_BRIGHT_MAGENTA")Foreground color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --c|--cyan: $(ansi_code "$ANSI_FG_BRIGHT_CYAN")Foreground color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --w|--white: $(ansi_code "$ANSI_FG_BRIGHT_WHITE")Foreground color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se_empty
  ansi_log_se_h3 "8-Bit"
  ansi_log_se "      --o|--orange: $(ansi_code "$ANSI_FG_8_BIT_ORANGE")Foreground color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se_empty
  ansi_log_se_h3 "Reset/Defaults"
  ansi_log_se "      -d|--d: $(ansi_code "$ANSI_FG_DEFAULT")Default foreground color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se_empty

  ansi_log_se_h2 "Background Colors"
  ansi_log_se_h3 "3-Bit/4-Bit"
  ansi_log_se "      -BL|-BLACK: $(ansi_code "$ANSI_BG_BLACK")Background color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      -R|-RED: $(ansi_code "$ANSI_BG_RED")Background color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      -G|-GREEN: $(ansi_code "$ANSI_BG_GREEN")Background color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      -Y|-YELLOW: $(ansi_code "$ANSI_BG_YELLOW")Background color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      -B|-BLUE: $(ansi_code "$ANSI_BG_BLUE")Background color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      -M|-MAGENTA: $(ansi_code "$ANSI_BG_MAGENTA")Background color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      -C|-CYAN: $(ansi_code "$ANSI_BG_CYAN")Background color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      -W|-WHITE: $(ansi_code "$ANSI_BG_WHITE")Background color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se_empty
  ansi_log_se "      --BL|--BLACK: $(ansi_code "$ANSI_BG_BRIGHT_BLACK")Background color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --R|--RED: $(ansi_code "$ANSI_BG_BRIGHT_RED")Background color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --G|--GREEN: $(ansi_code "$ANSI_BG_BRIGHT_GREEN")Background color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --Y|--YELLOW: $(ansi_code "$ANSI_BG_BRIGHT_YELLOW")Background color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --B|--BLUE: $(ansi_code "$ANSI_BG_BRIGHT_BLUE")Background color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --M|--MAGENTA: $(ansi_code "$ANSI_BG_BRIGHT_MAGENTA")Background color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --C|--CYAN: $(ansi_code "$ANSI_BG_BRIGHT_CYAN")Background color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --W|--WHITE: $(ansi_code "$ANSI_BG_BRIGHT_WHITE")Background color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se_empty

  ansi_log_se_h3 "8-Bit"
  ansi_log_se "      --O|--ORANGE: $(ansi_code "$ANSI_BG_8_BIT_ORANGE")Background color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se_empty

  ansi_log_se_h2 "Swap FG/BG Colors"
  ansi_log_se "      --swap: $(ansi_code "$ANSI_FG_BG_SWAP")swap foreground and background colors$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se_empty  

  ansi_log_se_h2 "Font Properties"
  ansi_log_se "      --W|--WHITE: $(ansi_code "$ANSI_BG_BRIGHT_WHITE")Background color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --bold: $(ansi_code "$ANSI_FONT_BOLD")Bold font$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --faint: $(ansi_code "$ANSI_FONT_FAINT")Faint font$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --italic: $(ansi_code "$ANSI_FONT_ITALIC")Italic font$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --underline: $(ansi_code "$ANSI_FONT_UNDERLINE")Underline$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --invert: $(ansi_code "$ANSI_FONT_INVERT")Invert foreground and background colors$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --hide: $(ansi_code "$ANSI_FONT_HIDE")Hide$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se_empty

  ansi_log_se_h2 "Blink"
  ansi_log_se "      --blink|--blink-slow: $(ansi_code "$ANSI_BLINK")A slow blink$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --blink-none: $(ansi_code "$ANSI_BLINK_NONE")Stop blinking$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se_empty  

  ansi_log_se_h2 "Cursor"
  ansi_log_se "      --up|--cursor-up|-cu: $(ansi_code "$ANSI_DEFAULT")Move cursor up 1 line$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --right|--cursor-right|-cr: $(ansi_code "$ANSI_DEFAULT")Move cursor right 1 space$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --down|--cursor-down|-cd: $(ansi_code "$ANSI_DEFAULT")Move cursor down 1 line$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "      --left|--cursor-left|-cl: $(ansi_code "$ANSI_DEFAULT")Move cursor left 1 space$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se_empty

  ansi_log_se_h2 "Reset All to Defaults"
  ansi_log_se "      -D|--D: $(ansi_code "$ANSI_BG_DEFAULT")Default background color$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se_empty
  
  ansi_log_se_h1 "EXAMPLES"
  ansi_log_se "  $ $SCRIPT_NAME \"some string\""
  ansi_log_se "  some string"
  ansi_log_se_empty  
  ansi_log_se "  $ $SCRIPT_NAME # empty line"
  ansi_log_se "  # empty line is printed"
  ansi_log_se_empty  
  ansi_log_se "  $ $SCRIPT_NAME -red \"red text\" --default"
  ansi_log_se "  $(ansi_code "$ANSI_FG_RED")red text$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se_empty  
  ansi_log_se "  $ $SCRIPT_NAME -WHITE \"white background\" --default"
  ansi_log_se "  $(ansi_code "$ANSI_BG_WHITE")white background$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se_empty  
  ansi_log_se "  $ $SCRIPT_NAME --red \"bright red text\" --default \" then default text and \" --GREEN \"bright green background\" --default"
  ansi_log_se "  $(ansi_code "$ANSI_FG_BRIGHT_RED")bright red text$(ansi_code "$ANSI_DEFAULT") then default text and $(ansi_code "$ANSI_BG_BRIGHT_GREEN")bright green background$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se_empty  
  ansi_log_se "  $ $SCRIPT_NAME --red --GREEN \"bright red text and bright green background\" --default"
  ansi_log_se "  $(ansi_code "$ANSI_FG_BRIGHT_RED")$(ansi_code "$ANSI_BG_BRIGHT_GREEN")bright red text and bright green background$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se_empty  
  ansi_log_se "  $ $SCRIPT_NAME -yellow --italic \"italic yellow text\" --default \" some default colors \" --RED \"and bright red background\" --default"
  ansi_log_se "  $(ansi_code "$ANSI_FG_YELLOW")$(ansi_code "$ANSI_FONT_ITALIC")italic yellow text$(ansi_code "$ANSI_DEFAULT") some default colors $(ansi_code "$ANSI_BG_BRIGHT_RED")and bright red background$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se_empty  
  ansi_log_se "  $ $SCRIPT_NAME --blink -red \"ALERT:\" --default \" Eat Lunch\" --default"
  ansi_log_se "  $(ansi_code "$ANSI_BLINK")$(ansi_code "$ANSI_FG_RED")ALERT:$(ansi_code "$ANSI_DEFAULT") Eat Lunch"
  ansi_log_se_empty  
  ansi_log_se "  $ $SCRIPT_NAME --red --underline \"REMINDER:\" --default \" Eat Lunch\" --default"
  ansi_log_se "  $(ansi_code "$ANSI_FG_RED")$(ansi_code "$ANSI_FONT_UNDERLINE")REMINDER:$(ansi_code "$ANSI_DEFAULT") Eat Lunch"
  ansi_log_se_empty  
  ansi_log_se "  $ $SCRIPT_NAME --bold --cyan \"TITLE\" --default \": \" --italic --orange \"How to use this utility\" --default"
  ansi_log_se "  $(ansi_code "$ANSI_FONT_BOLD")$(ansi_code "$ANSI_FG_BRIGHT_CYAN")TITLE$(ansi_code "$ANSI_DEFAULT"): $(ansi_code "$ANSI_FONT_ITALIC")$(ansi_code "$ANSI_FG_8_BIT_ORANGE")How to use utility$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se_empty
  ansi_log_se "  $ $SCRIPT_NAME \"How about a hyperlink: \" --cyan --underline \"https://www.mydomain.yep\" --default"
  ansi_log_se "  How about a hyperlink: $(ansi_code "$ANSI_FG_BRIGHT_CYAN")$(ansi_code "$ANSI_FONT_UNDERLINE")https://www.mydomain.yep$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se_empty
  
  ansi_log_se_h1 "NOTES"
  ansi_log_se "  Some codes are supported by some terminals (bash, zshell, VSCode, etc...) and some not."
  ansi_log_se "  For example, the terminal in Visual Studio Code on MacOS does not support blinking, while a zshell in Terminal.app does."
  ansi_log_se "  Colors seem to be widely supported. The fringe codes (with low support) have generally been ommitted from this tool."
  ansi_log_se_empty  
 
  ansi_log_se_h1 "REFERENCES"
  ansi_log_se "  8-bit codes: $(ansi_code "$ANSI_FG_BRIGHT_CYAN")$(ansi_code "$ANSI_FONT_UNDERLINE")https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "  3-bit / 4-bit color: $(ansi_code "$ANSI_FG_BRIGHT_CYAN")$(ansi_code "$ANSI_FONT_UNDERLINE")https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "  24-bit (RGB) color: $(ansi_code "$ANSI_FG_BRIGHT_CYAN")$(ansi_code "$ANSI_FONT_UNDERLINE")https://en.wikipedia.org/wiki/ANSI_escape_code#24-bit$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se "  Cursor movement: $(ansi_code "$ANSI_FG_BRIGHT_CYAN")$(ansi_code "$ANSI_FONT_UNDERLINE")https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x361.html$(ansi_code "$ANSI_DEFAULT")"
  ansi_log_se_empty
}

joinArray() {
  args=("$@") 
  WORKING_STRING=""
  for arg in "${args[@]}"; do
    WORKING_STRING="$WORKING_STRING$arg"
  done
  echo "$WORKING_STRING"
}


# Parses script arguments which take the form of:
#   * --key=value
#   * --key value
# return: Additional number of positions to shift the arguments.
# (0 for "key=value", 1 for "key value"). EX:
#
# ```sh
# --type*)
#   KEY_VALUE=$(parse_key_value_argument "--type" "$@")
#   VALUE=$(echo "$KEY_VALUE" | cut -d "," -f 1);
#   TO_SHIFT=$(echo "$KEY_VALUE" | cut -d "," -f 2);
#   shift $TO_SHIFT
# ```
#
# stdout: The parsed argument value if found. Otherwise nil.
parse_key_value_argument() {
  validate_arg "${1}" "${2}"

  local suffix
  local key
  local value

  suffix=${2//${1}/} # $(echo "${2}" | sed "s/${1}//g")
  if [[ -n "$suffix" ]]; then
    ansi_log_se_d "    Found argument (key=value): ${2}"
    key=$(echo "${2}" | sed -E 's/(.*)(=.*)/\1/g')
    value=$(echo "${2}" | sed -E 's/(.*=)(.*)/\2/g')
    ansi_log_se_d "      key: $key value: $value"
    echo "$value,0," # return value, 0 shift
  else
    ansi_log_se_d "    Found argument pair (key value): ${2} ${3}"
    key="${2}"
    PEEK_VALUE=$(echo "$3" | grep -E "^--")
    if [[ "$PEEK_VALUE" != "" ]]; then
      ansi_log_se_d "      Value for argument (${2} ${3}) appears to be another argument and is invalid: Defaulting to value of 1"
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
    ansi_log_se_d "[WARNING] Expected argument: '$2' to begin with '$1', but does not."  
  fi
}

# inputs: ARG_MASK ANSI_MOVE_CODE remaining_args
#   ARG_MASK: the "root" of the argument like "--up", "--down", etc...
#   ANSI_MOVE_CODE: A, B, C, or D 
#   remaining_args: what ever is left of script args as they are shifted over.
#   EX: --up A $@
# returns: A comma delimited string:CODE,SUFFIX,TO_SHIFT
#   EX: 
parse_cursor_movement() {
  # Pass ARG_MASK and remaining_args (leaving out MOVE_CODE)
  # MOVE_COUNT=$(parse_key_value_argument "$1" "${@:3}")
  out=$(parse_key_value_argument "$1" "${@:3}"); 
  MOVE_COUNT=$(echo "$out" | cut -d "," -f 1);
  TO_SHIFT=$(echo "$out" | cut -d "," -f 2);
  CODE="${MOVE_COUNT}${2}"
  SUFFIX="" 
  echo "${CODE},${SUFFIX},${TO_SHIFT},"
}

ANSI_PREFIX="\033["
ANSI_SUFFIX="m"

ansi_code() {
  if [[ -z "$1" ]]; then 
    ansi_log_se "ansi_code() requires an ansi color argument"
    exit 1
  fi
  CODE="${ANSI_PREFIX}${1}${ANSI_SUFFIX}"  
  echo "$CODE"
}

# Default (all)
ANSI_DEFAULT="0"

# ---- Foreground Colors

# Foreground Colors (3-bit 4-bit)
ANSI_FG_BLACK="30"
ANSI_FG_RED="31"
ANSI_FG_GREEN="32"
ANSI_FG_YELLOW="33"
ANSI_FG_BLUE="34"
ANSI_FG_MAGENTA="35"
ANSI_FG_CYAN="36"
ANSI_FG_WHITE="37"

# Foreground Colors, Bright (3-bit 4-bit)
ANSI_FG_BRIGHT_BLACK="90"
ANSI_FG_BRIGHT_RED="91"
ANSI_FG_BRIGHT_GREEN="92"
ANSI_FG_BRIGHT_YELLOW="93"
ANSI_FG_BRIGHT_BLUE="94"
ANSI_FG_BRIGHT_MAGENTA="95"
ANSI_FG_BRIGHT_CYAN="96"
ANSI_FG_BRIGHT_WHITE="97"

# Foreground Colors (8-bit)
# Look up the number for desired color in the 8-bit table
# https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit
#
# Code will be:
# 38;5;${NUM_FROM_TABLE}
#
# Note: This works in VSCode's terminal, but not in Terminal.app
ANSI_FG_8_BIT_PREFIX="38;5;"
ANSI_FG_8_BIT_ORANGE="${ANSI_FG_8_BIT_PREFIX}208" 

# Foreground Colors, Bright (3-bit 4-bit)
ANSI_FG_DEFAULT="39"

# ---- Background Colors

# Background Colors (3-bit 4-bit)
ANSI_BG_BLACK="40"
ANSI_BG_RED="41"
ANSI_BG_GREEN="42"
ANSI_BG_YELLOW="43"
ANSI_BG_BLUE="44"
ANSI_BG_MAGENTA="45"
ANSI_BG_CYAN="46"
ANSI_BG_WHITE="47"

# Background Colors, Bright (3-bit 4-bit)
ANSI_BG_BRIGHT_BLACK="100"
ANSI_BG_BRIGHT_RED="101"
ANSI_BG_BRIGHT_GREEN="102"
ANSI_BG_BRIGHT_YELLOW="103"
ANSI_BG_BRIGHT_BLUE="104"
ANSI_BG_BRIGHT_MAGENTA="105"
ANSI_BG_BRIGHT_CYAN="106"
ANSI_BG_BRIGHT_WHITE="107"

# Background Colors (8-bit)
# Look up the number for desired color in the 8-bit table
# https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit
#
# Code will be:
# 38;5;${NUM_FROM_TABLE}
#
# Note: This works in VSCode's terminal, but not in Terminal.app
ANSI_BG_8_BIT_PREFIX="48;5;"
ANSI_BG_8_BIT_ORANGE="${ANSI_BG_8_BIT_PREFIX}208" 

# Background Colors, Default (3-bit 4-bit)
ANSI_BG_DEFAULT="49"

# ---- Fonts

# Font properties
ANSI_FONT_BOLD="1"
ANSI_FONT_FAINT="2"
ANSI_FONT_ITALIC="3"
ANSI_FONT_UNDERLINE="4"
ANSI_FONT_INVERT="7"
ANSI_FONT_HIDE="8"

# ---- Blinking

ANSI_BLINK="5"
# ANSI_BLINK_RAPID="6" # Not supported on Mac
ANSI_BLINK_NONE="25"

# ---- Misc

ANSI_FG_BG_SWAP="7"

# ---- End defines

DEBUG_ARG=$(ansi_code "$ANSI_FG_BRIGHT_WHITE")
DEBUG_ARG_ANSI_CODE=$(ansi_code "$ANSI_FG_8_BIT_ORANGE")
DEBUG_ARG_TEXT=$(ansi_code "$ANSI_FG_BRIGHT_YELLOW")
DEBUG_WORKING_STR=$(ansi_code "$ANSI_FG_BRIGHT_CYAN")
DEBUG_EXAMPLE=$(ansi_code "$ANSI_FG_BRIGHT_MAGENTA")
DEBUG_DEFAULT_FG=$(ansi_code "$ANSI_DEFAULT")
DEBUG_ECHO="echo -e"
DEBUG_PRINTF="printf"

ARGS_COUNT="$#"
ansi_log_se_d "Will inspect $ARGS_COUNT arguments"
CODES=()
counter=0
# for arg in "${@}"; do
#   echo "$counter: $arg"
#   counter=$((counter+1))
# done
while [[ $# -gt 0 ]]; do
  ansi_log_se_d "  Inspecting args[$counter]: $DEBUG_ARG%s$DEBUG_DEFAULT_FG" "$1"
  
  PREFIX="$ANSI_PREFIX"
  SUFFIX="$ANSI_SUFFIX"

  unset -v CODE
  unset -v TEXT

  case $1 in
    --debug) ;; # This arg was processed at the top of the script, so not much to do in this case.
    --help|help) ansi_log_se_d "Found $1 arg"; printUsage;;

    # Default (all)
    --|--default) CODE="0";;

    # Foreground Colors (3-bit 4-bit)
    -b|-black) CODE="$ANSI_FG_BLACK";;
    -r|-red) CODE="$ANSI_FG_RED";;
    -g|-green) CODE="$ANSI_FG_GREEN";;
    -y|-yellow) CODE="$ANSI_FG_YELLOW";;
    -blue) CODE="$ANSI_FG_BLUE";;
    -m|-magenta) CODE="$ANSI_FG_MAGENTA";;
    -c|-cyan) CODE="$ANSI_FG_CYAN";;
    -w|-white) CODE="$ANSI_FG_WHITE";;

    # Foreground Colors, Bright (3-bit 4-bit)
    --b|--black) CODE="$ANSI_FG_BRIGHT_BLACK";;
    --r|--red) CODE="$ANSI_FG_BRIGHT_RED";;
    --g|--green) CODE="$ANSI_FG_BRIGHT_GREEN";;
    --y|--yellow) CODE="$ANSI_FG_BRIGHT_YELLOW";;
    --blue) CODE="$ANSI_FG_BRIGHT_BLUE";;
    --m|--magenta) CODE="$ANSI_FG_BRIGHT_MAGENTA";;
    --c|--cyan) CODE="$ANSI_FG_BRIGHT_CYAN";;
    --w|--white) CODE="$ANSI_FG_BRIGHT_WHITE";;

    # Foreground Colors (8-bit)
    # Note: This works in VSCode's terminal, but not in Terminal.app
    --o|--orange) CODE="$ANSI_FG_8_BIT_ORANGE";;

    
    # Foreground Colors, Default (3-bit 4-bit)
    -d|--d) CODE="$ANSI_FG_DEFAULT";;

    # Background Colors (3-bit 4-bit)
    -B|-BLACK) CODE="$ANSI_BG_BLACK";;
    -R|-RED) CODE="$ANSI_BG_RED";;
    -G|-GREEN) CODE="$ANSI_BG_GREEN";;
    -Y|-YELLOW) CODE="$ANSI_BG_YELLOW";;
    -BLUE) CODE="$ANSI_BG_BLUE";;
    -M|-MAGENTA) CODE="$ANSI_BG_MAGENTA";;
    -C|-CYAN) CODE="$ANSI_BG_CYAN";;
    -W|-WHITE) CODE="$ANSI_BG_WHITE";;

    # Background Colors, Bright (3-bit 4-bit)
    --BL|--BLACK) CODE="$ANSI_BG_BRIGHT_BLACK";;
    --R|--RED) CODE="$ANSI_BG_BRIGHT_RED";;
    --G|--GREEN) CODE="$ANSI_BG_BRIGHT_GREEN";;
    --Y|--YELLOW) CODE="$ANSI_BG_BRIGHT_YELLOW";;
    --BLUE) CODE="$ANSI_BG_BRIGHT_BLUE";;
    --M|--MAGENTA) CODE="$ANSI_BG_BRIGHT_MAGENTA";;
    --C|--CYAN) CODE="$ANSI_BG_BRIGHT_CYAN";;
    --W|--WHITE) CODE="$ANSI_BG_BRIGHT_WHITE";;

    # Foreground Colors (8-bit)
    # Note: This works in VSCode's terminal, but not in Terminal.app
    --O|--ORANGE) CODE="$ANSI_BG_8_BIT_ORANGE";; # 8 bit. Works in VSCode, not in terminal.
    # --o|--orange) CODE="$ANSI_FG_8_BIT_ORANGE";;

    # Background Colors, Default (3-bit 4-bit)
    -D|--D) CODE="$ANSI_BG_DEFAULT";;

    # Font properties
    --bold) CODE="$ANSI_FONT_BOLD";;
    --faint) CODE="$ANSI_FONT_FAINT";;
    --italic) CODE="$ANSI_FONT_ITALIC";;
    --underline) CODE="$ANSI_FONT_UNDERLINE";;
    --invert) CODE="$ANSI_FONT_INVERT";;
    --hide) CODE="$ANSI_FONT_HIDE";;

    # Blinking
    --blink|--blink-slow) CODE="$ANSI_BLINK";;
    # --blink-rapid) CODE="$ANSI_BLINK_RAPID";;
    --blink-none) CODE="$ANSI_BLINK_NONE";;

    # Misc
    --swap) CODE="$ANSI_FG_BG_SWAP";;

    # Cursor
    --up*)
      out=$(parse_cursor_movement "--up" "A" "$@"); 
      CODE=$(echo "$out" | cut -d "," -f 1);
      SUFFIX=$(echo "$out" | cut -d "," -f 2);
      TO_SHIFT=$(echo "$out" | cut -d "," -f 3);
      shift "$TO_SHIFT"
      ;;
    --down*)
      out=$(parse_cursor_movement "--down" "B" "$@"); 
      CODE=$(echo "$out" | cut -d "," -f 1);
      SUFFIX=$(echo "$out" | cut -d "," -f 2);
      TO_SHIFT=$(echo "$out" | cut -d "," -f 3);
      shift "$TO_SHIFT"
      ;;
    --right*)
      out=$(parse_cursor_movement "--right" "C" "$@"); 
      CODE=$(echo "$out" | cut -d "," -f 1);
      SUFFIX=$(echo "$out" | cut -d "," -f 2);
      TO_SHIFT=$(echo "$out" | cut -d "," -f 3);
      shift "$TO_SHIFT"
      ;;
    --left*)
      out=$(parse_cursor_movement "--left" "D" "$@"); 
      CODE=$(echo "$out" | cut -d "," -f 1);
      SUFFIX=$(echo "$out" | cut -d "," -f 2);
      TO_SHIFT=$(echo "$out" | cut -d "," -f 3);
      shift "$TO_SHIFT"
      ;;
    # - Clear the screen, move to (0,0). EX: '\033[2J'
    # https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x361.html
    --clear-screen) CODE="2J"; SUFFIX="";;
  
    # - Erase to end of line. EX: '\033[K'
    # Move Cursor / Erase to end of line:
    # https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x361.html
    --erase-line) CODE="K"; SUFFIX="";;

    # - Position the Cursor:
    #   \033[<L>;<C>H
    #     Or
    #   \033[<L>;<C>f
    #   puts the cursor at line L and column C.



    # --save-cursor) CODE="s"; SUFFIX="";;
    # --restore-cursor) CODE="u"; SUFFIX="";;
    # --clear-screen) CODE="2J"; SUFFIX="";;
    # --cursor-move) 
    #   CODE="${Y}{X}"; SUFFIX="H";;
    #   CODE="${Y}{X}"; SUFFIX="f";;

    # --rgb) 
    #   ;;
    *) TEXT=$1
  esac

  shift 1
  counter=$((counter+1))

  unset -v ARG_HANDLED
  if [[ -n "$CODE" ]]; then
    ANSI_CODE_FRAGMENT="${PREFIX}${CODE}${SUFFIX}"
    ansi_log_se_d "    Converted to ANSI code: $DEBUG_ARG_ANSI_CODE%s$DEBUG_DEFAULT_FG" "$ANSI_CODE_FRAGMENT"
    CODES+=("$ANSI_CODE_FRAGMENT")
    WORKING_STR=$(joinArray "${CODES[@]}" )
    ansi_log_se_d "    Appended to WORKING_STR: $DEBUG_WORKING_STR%s$DEBUG_DEFAULT_FG" "$WORKING_STR"
    ARG_HANDLED=true
  fi
  if [[ -n "$TEXT" ]]; then
    ansi_log_se_d "    Converted to plain text: $DEBUG_ARG_TEXT%s$DEBUG_DEFAULT_FG" "$TEXT"
    CODES+=("$TEXT")  
    WORKING_STR=$(joinArray "${CODES[@]}" )
    ansi_log_se_d "    Appended text to WORKING_STR: $DEBUG_WORKING_STR%s$DEBUG_DEFAULT_FG" "$WORKING_STR"
    ARG_HANDLED=true
  fi

  if [[ -z $ARG_HANDLED ]]; then
    ansi_log_se_d "    nothing to do"
  fi
  ansi_log_se_d "" 
done

ansi_log_se_d "Did inspect $ARGS_COUNT arguments"
ansi_log_se_d "" 

if [[ -n "$ANSI_DEBUG" ]]; then
  ansi_log_se_d "Final WORKING_STR: '$DEBUG_WORKING_STR%s$DEBUG_DEFAULT_FG'" "$WORKING_STR"
  ansi_log_se_d "" 
  ansi_log_se_d "to replicate:"
  ansi_log_se_d "    $DEBUG_EXAMPLE%s \"%s\"$DEBUG_DEFAULT_FG" "$DEBUG_ECHO" "$WORKING_STR"
  ansi_log_se_d "    $DEBUG_EXAMPLE%s \"%s\\\\n\"$DEBUG_DEFAULT_FG" "$DEBUG_PRINTF" "$WORKING_STR"
  ansi_log_se_d "" 
fi  

echo -e "$WORKING_STR"
