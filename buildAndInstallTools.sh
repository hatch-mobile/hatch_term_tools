#!/bin/zsh
# shellcheck shell=bash
# ---- ---- ----  About this Script  ---- ---- ----
#
# Compiles all binaries in 'HatchTerminal' repo. 
# Copies binaries from 'HatchTerminal' build dir into `hatch_term_tools/tools` before finally comitting/pushing
#
# ---- ---- ---- ----  Imports  ---- ---- ---- ----

# ---- ---- ----   Argument Parsing   ---- ---- ----

# ---- ---- ----     Script Work     ---- ---- ----

SCRIPT_DIR=$(realpath "$(dirname "$0")")
LOGS_DIR="$SCRIPT_DIR/.gitignored/install_logs"
LOG_FILE="$LOGS_DIR/installer.log"
HATCH_TERMINAL_DIR="$SCRIPT_DIR/../HatchTerminal"
HATCH_TERM_TOOLS_DIR="$SCRIPT_DIR"

if ! [[ -d "$HATCH_TERM_TOOLS_DIR" ]]; then 
  echo -e "\x1B[91m[ERROR]\x1B[0m Could not find hatch_term_tools repository at: \x1B[96m\x1B[4m__${HATCH_TERM_TOOLS_DIR}\x1B[0m
* \x1B[1m[INFO]\x1B[0m: This script currently hard codes the path to \x1B[93m\x1B[1mhatch_term_tools\x1B[0m. 
* \x1B[38;5;208m[TODO]\x1B[0m: Add script argument to specify path to \x1B[93m\x1B[1mhatch_term_tools directory\x1B[0m
* \x1B[92m[WORKAROUND]\x1B[0m Until then here are some workarounds:
  * Clone the repository into \x1B[96m\x1B[4m${HATCH_TERM_TOOLS_DIR}\x1B[0m
  * Create a symbolic link from your cloned location to \x1B[96m\x1B[4m${HATCH_TERM_TOOLS_DIR}\x1B[0m"
  return 1
fi

# set -e

echo -e "\x1B[1m**** Logging to file: \x1B[0m\x1B[96m\x1B[4m${LOG_FILE}\x1B[0m"
mkdir_command="mkdir -p \"$LOGS_DIR\""
eval "$mkdir_command"
echo "$mkdir_command" &> "$LOG_FILE"


# Compiles all binaries in 'HatchTerminal' repo. 
echo -e "\x1B[1m**** Compiling CLI tools under \x1B[0m\x1B[96m\x1B[4m${HATCH_TERMINAL_DIR}\x1B[0m. This may take a few minutes..."
"$HATCH_TERMINAL_DIR/scripts/install.sh" &>> "$LOG_FILE"

# Copies tools from 'HatchTerminal' build dir into `hatch_term_tools/tools` before finally comitting/pushing
echo -e "\x1B[1m**** Copying compiled CLI tools\x1B[0m
  from: \x1B[96m\x1B[4m${HATCH_TERMINAL_DIR}\x1B[0m 
  to: \x1B[0m\x1B[96m\x1B[4m${HATCH_TERM_TOOLS_DIR}/tools\x1B[0m"
"$HATCH_TERM_TOOLS_DIR/push_hatch_terminal.sh" &>> "$LOG_FILE"

echo -e "\x1B[1m**** Finished\x1B[0m. 
  log file: \x1B[96m\x1B[4m$LOG_FILE\x1B[0m
  dump: \x1B[93m\x1B[1mcat \"$LOG_FILE\"\x1B[0m"