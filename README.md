

# About 

To install shell tools, copy / paste this into your terminal

```sh
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/hatch-mobile/hatch_term_tools/main/install_tools.sh)"
```

Then either open a new terminal or reload your environment `source ~/.zshrc`

Test that the tools installed:
```sh
which echo_ansi
```




# Uninstall
```sh

# delete PATH lines from .zshrc
first_line=$(grep -n "# This section added by /bin/zsh" ~/.zshrc | cut -d ":" -f 1 | head -n 1)
second_line=$((first_line+1))
if [[ "$first_line" == "" || "$second_line" == "" ]]; then
  return 1
fi
sed -i '' -e "${first_line},${second_line}d" ~/.zshrc


# delete hatch tools dir
HATCH_TOOLS_DIR="$HOME/bin/hatch"
rm -rf "$HATCH_TOOLS_DIR"
echo "before: $PATH"
export PATH=$(echo "$PATH" | sed -e "s|$HATCH_TOOLS_DIR||g")
echo "after: $PATH"
```
<!-- export PATH=$(echo "$PATH" | sed -e "s|$HOME/bin/hatch||g")


/Users/zakkhoyt/.rbenv/shims:/Users/zakkhoyt/.fastlane/bin:/opt/homebrew/bin:/usr/local/bin:/opt/local/bin:/opt/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications:/usr/libexec/:/Users/zakkhoyt/.platformio/penv/bin:/Users/zakkhoyt/.mint/bin:/Users/zakkhoyt/.zsh_home/scripts:/Users/zakkhoyt/code/repositories/hatch-baby/HatchSleep/scripts:/Users/zakkhoyt/code/repositories/hatch/hatch_sleep/scripts/shell:/Users/zakkhoyt/.zsh_home/scripts/shell:/Users/zakkhoyt/vscode:/Users/zakkhoyt/applications/objc-dependency-visualizer:/Users/zakkhoyt/.rvm/bin:/Users/zakkhoyt/code/repositories/hatch/hatch_sleep/scripts/shell/bin
/Users/zakkhoyt/.rbenv/shims:/Users/zakkhoyt/.fastlane/bin:/opt/homebrew/bin:/usr/local/bin:/opt/local/bin:/opt/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications:/usr/libexec/:/Users/zakkhoyt/.platformio/penv/bin:/Users/zakkhoyt/.mint/bin:/Users/zakkhoyt/.zsh_home/scripts:/Users/zakkhoyt/code/repositories/hatch-baby/HatchSleep/scripts:/Users/zakkhoyt/code/repositories/hatch/hatch_sleep/scripts/shell:/Users/zakkhoyt/.zsh_home/scripts/shell:/Users/zakkhoyt/vscode:/Users/zakkhoyt/applications/objc-dependency-visualizer:/Users/zakkhoyt/.rvm/bin:/Users/zakkhoyt/code/repositories/hatch/hatch_sleep/scripts/s



/Users/zakkhoyt/.rbenv/shims:/Users/zakkhoyt/.fastlane/bin:/opt/homebrew/bin:/usr/local/bin:/opt/local/bin:/opt/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications:/usr/libexec/:/Users/zakkhoyt/.platformio/penv/bin:/Users/zakkhoyt/.mint/bin:/Users/zakkhoyt/.zsh_home/scripts:/Users/zakkhoyt/code/repositories/hatch-baby/HatchSleep/scripts:/Users/zakkhoyt/code/repositories/hatch/hatch_sleep/scripts/shell:/Users/zakkhoyt/.zsh_home/scripts/shell:/Users/zakkhoyt/vscode:/Users/zakkhoyt/applications/objc-dependency-visualizer:/Users/zakkhoyt/.rvm/bin:/Users/zakkhoyt/code/repositories/hatch/hatch_sleep/scripts/shell/bin -->
