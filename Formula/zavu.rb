# Homebrew formula template for the Zavu CLI.
#
# Copy this file into the `zavudev/homebrew-tap` repo as `Formula/zavu.rb`,
# replace the 0.2.5 and {{SHA_*}} placeholders, commit, push. Users get
# the new version on their next `brew update`.
#
# Better yet: let `scripts/update-tap.sh` do it for you on every release.

class Zavu < Formula
  desc "Zavu CLI — deploy Functions, send messages, manage Zavu resources"
  homepage "https://zavu.dev"
  version "0.2.5"
  license "MIT"

  # URLs point at the PUBLIC release repo (zavudev/zavu-cli). The source
  # lives in a private monorepo, but binaries get re-published here so
  # Homebrew (and unauthenticated curl) can download them.
  on_macos do
    on_arm do
      url "https://github.com/zavudev/zavu-cli/releases/download/cli-v#{version}/zavu-macos-arm64"
      sha256 "ab75e712212bc8fe0acc786dd972749b72531e352dd3da4f127966110c1032c0"
    end
    on_intel do
      url "https://github.com/zavudev/zavu-cli/releases/download/cli-v#{version}/zavu-macos-x64"
      sha256 "0a6f4a84428403ed7ff61311a325625488844916a4fa1b081c6de8c8bdf15a37"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/zavudev/zavu-cli/releases/download/cli-v#{version}/zavu-linux-arm64"
      sha256 "2d914b7198166b65796dc1bcc7fa2af5168f0e79820214d5893b3f760e94e0f6"
    end
    on_intel do
      url "https://github.com/zavudev/zavu-cli/releases/download/cli-v#{version}/zavu-linux-x64"
      sha256 "3cc71ca0cb18d8ef0842c8e23c9569c34393640f967ccc1d6a9d98e7717dc20f"
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
