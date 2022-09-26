# https://directory.fsf.org/wiki/Mpc
component 'mpc' do |pkg, settings, _platform|
  pkg.version settings[:mpc_version]
  pkg.md5sum settings[:mpc_md5sum]
  pkg.url "http://ftp.gnu.org/gnu/mpc/mpc-#{pkg.get_version}.tar.gz"
end
