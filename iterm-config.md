# iTerm2 custom settings

## General

Closing -> Only 'Quit when all windows are closed' is checked
Selection -> Applications in terminal may access clipboard

## Appearance

General -> Theme -> Minimal
Windows -> Uncheck 'Show window number in title bar'
Panes -> Top & bottom margins -> 5

## Profiles (Default)

- General -> Working Directory -> Reuse previous session's directory
- Colors -> Color Presets -> Catpuccin Mocha (Download it here https://github.com/catppuccin/iterm)
- Text -> Font -> Use built-in Powerline glyphs
- Text -> Font -> SF Mono / Regular / 13 / 100 / 104
- Window -> Settings for New Windows -> Columns: 200 / Rows: 62
- Keys -> General -> Left Option key -> Esc+

## Advanced

Tab bar height (points) for the Minimal theme. -> 28

---

To delete all settings, run: `defaults delete com.googlecode.iterm2` and `rm -rf ~/Library/Preferences/com.googlecode.iterm2.plist` (source: https://iterm2.com/faq.html)
