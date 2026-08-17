cask "ccwidget" do
  version "0.3.3"
  sha256 "9a18c524652d2ee7998cd02639df5393332de8933364bbad035bbf34df5ed1b4"

  url "https://github.com/davidkremlev/ccwidget/releases/download/v#{version}/CCWidget-#{version}.dmg"
  name "Usage Widget for Claude Code"
  desc "Desktop widget for Claude Code limits, context window and quota estimate"
  homepage "https://github.com/davidkremlev/ccwidget"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "CCWidget.app"

  # Deleting the app is not enough. The app writes an exporter into
  # ~/.claude/ccwidget-export.py and points the Claude Code statusLine at it, so
  # removing only the bundle leaves that line running a file that is gone: a
  # broken prompt on every redraw, caused by uninstalling. The uninstaller ships
  # inside the bundle for exactly this, and it puts back whatever status line was
  # there before the widget was installed.
  uninstall script: {
    executable:   "#{appdir}/CCWidget.app/Contents/Resources/uninstall.sh",
    args:         ["--yes"],
    must_succeed: false,
  }

  # The history the estimate is built from, and the exchange directory the
  # widget extension owns. Left alone by a plain uninstall on purpose: reinstalling
  # keeps the forecast rather than starting it over.
  zap trash: [
    "~/.claude/.ccwidget-export.sha256",
    "~/Library/Containers/dev.illvminat.ccwidget.widget",
  ]

  caveats <<~EOS
    Two things this widget cannot do for you:

      1. Add it to your desktop. Right-click the desktop, Edit Widgets, and find
         "Usage Widget for Claude Code". Do this first — the system creates the
         directory the data goes through, and the app deliberately refuses to
         create it itself.

      2. Configure the status line. Open the app and press "Set up
         automatically". It writes ~/.claude/ccwidget-export.py and points
         statusLine at it, after backing up your settings. If you already have a
         status line, it keeps working: the exporter calls it and prints its
         output.

    It reads the Claude Code status line, which exists only in the terminal
    version. Through the desktop app or the web, the widget stays empty.
  EOS
end
