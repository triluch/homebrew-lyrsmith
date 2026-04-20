class Lyrsmith < Formula
  include Language::Python::Virtualenv

  desc "TUI app for transcribing and editing synced song lyrics"
  homepage "https://github.com/triluch/lyrsmith"
  url "https://files.pythonhosted.org/packages/5f/10/e31df56e309f5d96fd2341914e5261abb6db8c0617f7a00794b52ec30ccf/lyrsmith-0.2.1.tar.gz"
  sha256 "69e832b632ed98b0ab670a021d6ed79e120bf581c90681a5de1869cc92d51842"

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
