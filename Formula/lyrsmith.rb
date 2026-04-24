class Lyrsmith < Formula
  include Language::Python::Virtualenv

  desc "TUI app for transcribing and editing synced song lyrics"
  homepage "https://github.com/triluch/lyrsmith"
  url "https://files.pythonhosted.org/packages/87/10/9d45c80590aee70f5ded8bbeec1cba9ef3a7cb96a308257e0ff2f41edc0c/lyrsmith-0.3.0.tar.gz"
  sha256 "e68273034ad54b8d1caf9e9374e3ef4af8d4fa6ac7ffd723bd2023a4b1f9f185"

  depends_on "ffmpeg"
  depends_on "mpv"
  depends_on "python@3.13"
  depends_on "pkg-config" => :build

  skip_clean "libexec"

  def install
    python = Formula["python@3.13"].opt_bin/"python3.13"
    system python, "-m", "venv", libexec
    system libexec/"bin/pip", "install", "--upgrade", "pip"
    # Build av from source against Homebrew ffmpeg so it links to managed dylibs
    # rather than bundled wheels whose Mach-O headers are too short to relocate.
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["ffmpeg"].opt_lib/"pkgconfig"
    system libexec/"bin/pip", "install", "--prefer-binary", "--no-binary=av",
           "lyrsmith==#{version}"
    bin.install_symlink Dir["#{libexec}/bin/lyrsmith"]
  end

  test do
    false
  end
end
