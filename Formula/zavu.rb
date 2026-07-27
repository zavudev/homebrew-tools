# Homebrew formula template for the Zavu CLI.
#
# Copy this file into the `zavudev/homebrew-tap` repo as `Formula/zavu.rb`,
# replace the 0.9.5 and {{SHA_*}} placeholders, commit, push. Users get
# the new version on their next `brew update`.
#
# Better yet: let `scripts/update-tap.sh` do it for you on every release.

class Zavu < Formula
  desc "Zavu CLI — deploy Functions, send messages, manage Zavu resources"
  homepage "https://zavu.dev"
  version "0.9.5"
  license "MIT"

  # URLs point at the PUBLIC release repo (zavudev/zavu-cli). The source
  # lives in a private monorepo, but binaries get re-published here so
  # Homebrew (and unauthenticated curl) can download them.
  on_macos do
    on_arm do
      url "https://github.com/zavudev/zavu-cli/releases/download/cli-v#{version}/zavu-macos-arm64"
      sha256 "931f4bcf171d399c9cebd08d2f06083a6c1ae73641dda204360e09ffa14807ce"
    end
    on_intel do
      url "https://github.com/zavudev/zavu-cli/releases/download/cli-v#{version}/zavu-macos-x64"
      sha256 "133664bbd3de428b0cd545f9092096df04daa833f4064f80511c9868a6383cd0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/zavudev/zavu-cli/releases/download/cli-v#{version}/zavu-linux-arm64"
      sha256 "79bf7e6b5f5c296b1c74564415ad6c3dcc8ab17d052289fe1e6720208d170c52"
    end
    on_intel do
      url "https://github.com/zavudev/zavu-cli/releases/download/cli-v#{version}/zavu-linux-x64"
      sha256 "d51b0e7f2b01031ccbfa727cd99752621d3d322294c3a318e7f07efbad1fafbe"
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
