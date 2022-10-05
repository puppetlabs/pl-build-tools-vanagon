# https://gmplib.org
component 'gmp' do |pkg, settings, _platform|
  gmp_version = settings[:gmp_version]
  pkg.version gmp_version 
  pkg.md5sum settings[:gmp_md5sum]
  final_tar_gz_version = Gem::Version.new('5.0.2')
  if Gem::Version.new(gmp_version) > final_tar_gz_version
    pkg.url "http://ftp.gnu.org/gnu/gmp/gmp-#{gmp_version}.tar.xz"
  else
    pkg.url "http://ftp.gnu.org/gnu/gmp/gmp-#{gmp_version}.tar.gz"
  end
end
