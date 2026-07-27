# Homebrew formula template for the Zavu CLI.
#
# Copy this file into the `zavudev/homebrew-tap` repo as `Formula/zavu.rb`,
# replace the 0.8.0 and {{SHA_*}} placeholders, commit, push. Users get
# the new version on their next `brew update`.
#
# Better yet: let `scripts/update-tap.sh` do it for you on every release.

class Zavu < Formula
  desc "Zavu CLI — deploy Functions, send messages, manage Zavu resources"
  homepage "https://zavu.dev"
  version "0.8.0"
  license "MIT"

  # URLs point at the PUBLIC release repo (zavudev/zavu-cli). The source
  # lives in a private monorepo, but binaries get re-published here so
  # Homebrew (and unauthenticated curl) can download them.
  on_macos do
    on_arm do
      url "https://github.com/zavudev/zavu-cli/releases/download/cli-v#{version}/zavu-macos-arm64"
      sha256 "a7e35510fbbaede5e0205f3350e4472003ebbf618ea36b92fee24f87f06d2a52"
    end
    on_intel do
      url "https://github.com/zavudev/zavu-cli/releases/download/cli-v#{version}/zavu-macos-x64"
      sha256 "f2914da3966dd7091e60415246e0c2ee2c3e2a68b4e66d3d55aef90e951f2630"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/zavudev/zavu-cli/releases/download/cli-v#{version}/zavu-linux-arm64"
      sha256 "52f8356756b75ff2039967c96a402e226ca50b2dbd5e2dee6e2606db669a774c"
    end
    on_intel do
      url "https://github.com/zavudev/zavu-cli/releases/download/cli-v#{version}/zavu-linux-x64"
      sha256 "5b7d59105026f84bf2b9678353bae7406ca68d5fd2b85b764472a33ee43a31d9"
    end
  end

  # Bun-compiled binaries are renamed to `zavu` on install so users invoke
  # them as `zavu …` instead of `zavu-macos-arm64 …`. The platform-specific
  # filename in dist/ is determined by the on_macos / on_linux + on_arm /
  # on_intel blocks above; Homebrew downloads the correct one for the host.
  def install
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.mac? ? "macos" : "linux"
    bin.install "zavu-#{os}-#{arch}" => "zavu"
  end

  test do
    # Smoke test — `brew test zavu` verifies the binary starts.
    assert_match "zavu", shell_output("#{bin}/zavu --version")
  end
end
