class Composeup < Formula
  desc "Interactive CLI that scaffolds backing-service Docker Compose stacks (databases + admin UIs) in seconds."
  homepage "https://github.com/seifkhaled123/composeup"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/seifkhaled123/composeup/releases/download/v0.1.0/composeup-aarch64-apple-darwin.tar.xz"
      sha256 "41120a56f95f0e531ae11e87a1c8e797b0240b2cb2a22592297ca62539a6801c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/seifkhaled123/composeup/releases/download/v0.1.0/composeup-x86_64-apple-darwin.tar.xz"
      sha256 "f98553f20c63428837b86ab2fcf44e5fbc09830ddd9d06127cfd3a530dfd4bef"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/seifkhaled123/composeup/releases/download/v0.1.0/composeup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "853f1569b91a7b119da79055252970fb9e12e734da6f5399da59ed039d7f85af"
    end
    if Hardware::CPU.intel?
      url "https://github.com/seifkhaled123/composeup/releases/download/v0.1.0/composeup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fa080cd4bacd024028ebb918e6f498c938a563a23f9a671b146db9f6629d0441"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "composeup" if OS.mac? && Hardware::CPU.arm?
    bin.install "composeup" if OS.mac? && Hardware::CPU.intel?
    bin.install "composeup" if OS.linux? && Hardware::CPU.arm?
    bin.install "composeup" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
