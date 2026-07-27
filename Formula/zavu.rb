# Homebrew formula template for the Zavu CLI.
#
# Copy this file into the `zavudev/homebrew-tap` repo as `Formula/zavu.rb`,
# replace the 0.9.0 and {{SHA_*}} placeholders, commit, push. Users get
# the new version on their next `brew update`.
#
# Better yet: let `scripts/update-tap.sh` do it for you on every release.

class Zavu < Formula
  desc "Zavu CLI — deploy Functions, send messages, manage Zavu resources"
  homepage "https://zavu.dev"
  version "0.9.0"
  license "MIT"

  # URLs point at the PUBLIC release repo (zavudev/zavu-cli). The source
  # lives in a private monorepo, but binaries get re-published here so
  # Homebrew (and unauthenticated curl) can download them.
  on_macos do
    on_arm do
      url "https://github.com/zavudev/zavu-cli/releases/download/cli-v#{version}/zavu-macos-arm64"
      sha256 "0c431da4756729362958742fd9d304a21860103aef5a6706304f5602b4837eed"
    end
    on_intel do
      url "https://github.com/zavudev/zavu-cli/releases/download/cli-v#{version}/zavu-macos-x64"
      sha256 "e3a0f97eeeaa7f8ac278643cc0737a0bbf89e1433bf72674038dfb3997e06bec"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/zavudev/zavu-cli/releases/download/cli-v#{version}/zavu-linux-arm64"
      sha256 "fc5653ba639fe803af67f258faf62c901f7d43d03859a887ee5e4533534749d6"
    end
    on_intel do
      url "https://github.com/zavudev/zavu-cli/releases/download/cli-v#{version}/zavu-linux-x64"
      sha256 "3f73aa0486c84d9465649f28c5aae12754cc00f8e4cacedf0a6316dd7533ede0"
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
