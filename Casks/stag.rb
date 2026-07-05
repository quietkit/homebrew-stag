cask "stag" do
  version "1.1.0"
  sha256 "ef4d2fcc1dae27606c33c1bbf01f5a0dd48e39651b37e6174bf41bf326a19946"

  url "https://github.com/quietkit/Stag/releases/download/v#{version}/Stag-#{version}.tar.gz"
  name "Stag"
  desc "macOS screenshot and screen recording app"
  homepage "https://github.com/quietkit/Stag"

  depends_on macos: :sonoma
  depends_on arch: :arm64

  app "Stag.app"
  binary "Stag.app/Contents/MacOS/stag-cli", target: "stag"

  # The app is self-signed (no Apple notarization yet), so Gatekeeper would
  # block it with "app is damaged". Strip the quarantine flag after install.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/Stag.app"],
                   sudo: false
  end

  uninstall quit: "com.ganwar.Stag"

  zap trash: [
    "~/Library/Preferences/com.ganwar.Stag.plist",
    "~/Library/Caches/com.ganwar.Stag",
    "~/Library/Saved Application State/com.ganwar.Stag.savedState",
  ]

  caveats <<~EOS
    Stag needs Screen Recording permission.
    Grant it in System Settings > Privacy & Security > Screen Recording.
  EOS
end
