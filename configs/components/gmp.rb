# https://gmplib.org
component 'gmp' do |pkg, settings, _platform|
  pkg.version settings[:gmp_version]
  pkg.md5sum '0b82665c4a92fd2ade7440c13fcaa42b'
  pkg.url "http://ftp.gnu.org/gnu/gmp/gmp-#{pkg.get_version}.tar.xz"
end
