# https://directory.fsf.org/wiki/Mpc
component 'mpc' do |pkg, settings, _platform|
  pkg.version settings[:mpc_version]
  pkg.md5sum '2f1ce56ac775f2be090863f364931a03'
  pkg.url "http://ftp.gnu.org/gnu/mpc/mpc-#{pkg.get_version}.tar.gz"
end
