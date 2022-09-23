# https://gmplib.org
component 'gmp' do |pkg, settings, _platform|
  pkg.version settings[:gmp_version]
  pkg.md5sum settings[:gmp_md5sum]
  pkg.url "http://ftp.gnu.org/gnu/gmp/gmp-#{pkg.get_version}.tar.xz"
end
