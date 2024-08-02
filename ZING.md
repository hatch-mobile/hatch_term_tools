
# About

* [ ] What is HatchModules
* [ ] What is Zing?
  * [ ] Why v2?




# Installation 

There are two way to install `zing`: 
* Installer (pre-compiled)
* From Source


## Pre-compiled

To install compiled binaries, paste this into your terminal. 
```sh
# Downloads the `Hatch Terminal Tools` and installs them under `~/.hatch/bin`.
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/hatch-mobile/hatch_term_tools/main/install_tools.sh)"
```

Refresh your environment
```sh
# Open a new terminal or refresh your instance
source ~/.zshrc`
```

Verify your install
```sh
zing  --version
# 2.0.2
```

## Compile from Source

If you wish to compile/install yourself, see [HatchTerminal](https://github.com/hatch-mobile/HatchTerminal). 

# Usage

## Help and Subcommands

Show help and subcommands
```sh
zing --help
```

Show help for the `create` subcommand
```sh
zing create --help
```

## Creating a Module
```sh
# Try creating a package
zing create \
--name "HatchExampleClient" \
--package-dir "/Users/zakkhoyt/code/repositories/hatch/hatch_sleep/2/HatchModules" \
--debug --dry-run
```

# References
* [HatchTerminal](https://github.com/hatch-mobile/HatchTerminal): Shell utilities written in Swift (including Zing v2)
* [HatchTermTools](https://github.com/hatch-mobile/hatch_term_tools): Pre-compiled binaries (from HatchTerminal) and installer.
