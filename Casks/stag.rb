cask "stag" do
  version "1.0.0"
  sha256 "8e4ed25754dbb27d8cfffc6cb76235f54e5343dc6fca05816072ef03cdd8e8d0"

  url "https://github.com/quietkit/Stag/releases/download/v#{version}/Stag-#{version}.tar.gz"
  name "Stag"
  desc "macOS screenshot and screen recording app"
  homepage "https://github.com/quietkit/Stag"

  depends_on macos: :sonoma
  depends_on arch: :arm64

  app "Stag.app"

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
