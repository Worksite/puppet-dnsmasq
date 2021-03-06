require 'formula'

class Dnsmasq < Formula
  homepage 'http://www.thekelleys.org.uk/dnsmasq/doc.html'
  url 'http://www.thekelleys.org.uk/dnsmasq/dnsmasq-2.71.tar.gz'
  sha256 '7d8c64f66a396442e01b639df3ea6b4e02ba88cbe206c80be8de68b6841634c4'
  version '2.71-boxen1'

  def options
    [['--with-idn', "Compile with IDN support"]]
  end

  depends_on "libidn" if ARGV.include? '--with-idn'
  depends_on 'pkg-config' => :build

  def install
    ENV.deparallelize

    # Fix etc location
    inreplace "src/config.h", "/etc/dnsmasq.conf",
      "/opt/boxen/config/dnsmasq/dnsmasq.conf"

    # Optional IDN support
    if ARGV.include? '--with-idn'
      inreplace "src/config.h", "/* #define HAVE_IDN */", "#define HAVE_IDN"
    end

    # Fix compilation on Lion
    ENV.append_to_cflags "-D__APPLE_USE_RFC_3542" if 10.7 <= MACOS_VERSION.to_f
    inreplace "Makefile" do |s|
      s.change_make_var! "CFLAGS", ENV.cflags
    end

    system "make install PREFIX=#{prefix}"
  end
end
