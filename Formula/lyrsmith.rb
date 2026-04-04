class Lyrsmith < Formula
  include Language::Python::Virtualenv

  desc "TUI app for transcribing and editing synced song lyrics"
  homepage "https://github.com/triluch/lyrsmith"
  url "https://files.pythonhosted.org/packages/55/a6/334887b6cdf89fac96db213730936594509412b32313052d58ad9ad9a111/lyrsmith-0.2.0.tar.gz"
  sha256 "069b31f20e27b1734f25f35f7c57793fcbfc34aa776155cbef23025bd3a361db"

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
