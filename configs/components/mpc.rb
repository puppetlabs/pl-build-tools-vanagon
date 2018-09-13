# This is here just for the downloading and unpacking
component "mpc" do |pkg, settings, platform|
  pkg.version "1.0.3"
  pkg.md5sum "d6a1d5f8ddea3abd2cc3e98f58352d26"
  pkg.url "http://ftp.gnu.org/gnu/mpc/mpc-#{pkg.get_version}.tar.gz"
  pkg.mirror "#{settings[:buildsources_url]}/mpc-#{pkg.get_version}.tar.gz"
end
