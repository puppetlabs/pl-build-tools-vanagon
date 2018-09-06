# This is here just for the downloading and unpacking
component "mpfr" do |pkg, settings, platform|
  pkg.version "2.4.2"
  pkg.md5sum "0e3dcf9fe2b6656ed417c89aa9159428"
  pkg.url "http://ftp.gnu.org/gnu/mpfr/mpfr-#{pkg.get_version}.tar.gz"
  pkg.mirror "#{settings[:buildsources_url]}/mpfr-#{pkg.get_version}.tar.gz"
end
