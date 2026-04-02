class Lyrsmith < Formula
  include Language::Python::Virtualenv

  desc "TUI app for transcribing and editing synced song lyrics"
  homepage "https://github.com/triluch/lyrsmith"
  url "https://files.pythonhosted.org/packages/d9/f3/14c82999e9afdb1778885bb5adc1d97cd97003473f9f2dd0d5d6a2bb8448/lyrsmith-0.1.0.tar.gz"
  sha256 "0bd8f78b54df20f0df7b02c7cd73124d189ed396d2db983e23deca1b5d0f6051"

  depends_on "ffmpeg"
  depends_on "mpv"
  depends_on "python@3.13"

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
