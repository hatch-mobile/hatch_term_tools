

# About 

# Installation
To install shell tools, copy / paste this into your terminal

```sh
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/hatch-mobile/hatch_term_tools/main/install_tools.sh)"
```

Then either open a new terminal or reload your environment `source ~/.zshrc`

Test that the tools installed:
```sh
which echo_pretty


echo_pretty "This works just like echo does."
echo_pretty "this works just like echo does." --red --bold "WITH " --italic --YELLOW "COLORS" --default
echo_pretty "    and even some " --blink "blinking urls" --cyan --underline "https://gist.githubusercontent.com/zakkhoyt/c76a013602afded4b5240e6ca457acb0/raw/8764f97ff6bbdd41ca1d4d8290ac051115c91437/shell%2520script%2520arg%2520parsing" --default
```




# Uninstall

```sh
# Use the install script to clean up
./install_tools.sh --mode=uninstall
```

## Manually
```sh
# delete PATH lines from .zshrc
first_line=$(grep -n "# This section added by /bin/zsh" ~/.zshrc | cut -d ":" -f 1 | head -n 1)
second_line=$((first_line+1))
if [[ "$first_line" == "" || "$second_line" == "" ]]; then
  return 1
fi
sed -i '' -e "${first_line},${second_line}d" ~/.zshrc

# Reload env/path
echo "before: $PATH"
export PATH=$(echo "$PATH" | sed -e "s|$HATCH_TOOLS_DIR||g")
echo "after: $PATH"
source ~/.zshrc

# delete hatch tools dir
HATCH_TOOLS_DIR="$HOME/bin/hatch"
rm -rf "$HATCH_TOOLS_DIR"
```
