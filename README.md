# Homebrew tap

One cask, for [ccwidget](https://github.com/davidkremlev/ccwidget) — a macOS
desktop widget showing how much of a Claude Code subscription has been spent.

```sh
brew install --cask davidkremlev/tap/ccwidget
```

Uninstalling undoes the configuration as well as removing the app: the widget
writes an exporter into `~/.claude` and points the Claude Code `statusLine` at
it, and a cask that deleted only the bundle would leave that line running a file
that no longer exists.

```sh
brew uninstall --cask ccwidget          # app and configuration
brew uninstall --zap --cask ccwidget    # and the collected history
```
