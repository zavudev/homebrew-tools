# Homebrew formula template for the Zavu CLI.
#
# Copy this file into the `zavudev/homebrew-tap` repo as `Formula/zavu.rb`,
# replace the 0.2.6 and {{SHA_*}} placeholders, commit, push. Users get
# the new version on their next `brew update`.
#
# Better yet: let `scripts/update-tap.sh` do it for you on every release.

class Zavu < Formula
  desc "Zavu CLI — deploy Functions, send messages, manage Zavu resources"
  homepage "https://zavu.dev"
  version "0.2.6"
  license "MIT"

  # URLs point at the PUBLIC release repo (zavudev/zavu-cli). The source
  # lives in a private monorepo, but binaries get re-published here so
  # Homebrew (and unauthenticated curl) can download them.
  on_macos do
    on_arm do
      url "https://github.com/zavudev/zavu-cli/releases/download/cli-v#{version}/zavu-macos-arm64"
      sha256 "c2e0b74c2128de5b6dc7db373721d4fdee6d6958cf33975bbf112956e28dbced"
    end
    on_intel do
      url "https://github.com/zavudev/zavu-cli/releases/download/cli-v#{version}/zavu-macos-x64"
      sha256 "3ab12537a275fc182fc792e4eed1c131e76e7f8dd499810fc7d46001c816707e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/zavudev/zavu-cli/releases/download/cli-v#{version}/zavu-linux-arm64"
      sha256 "3bd9df45fe71abbc033f23ed4128c79977f67995137a4e9bc804be3738282fd6"
    end
    on_intel do
      url "https://github.com/zavudev/zavu-cli/releases/download/cli-v#{version}/zavu-linux-x64"
      sha256 "347d30b2268b9416844e452629db9b8c271b7706a976f8c54c6d53287af6f928"
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
