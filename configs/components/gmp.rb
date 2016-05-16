# This is here just for the downloading and unpacking
component "gmp" do |pkg, settings, platform|
  pkg.version "4.3.2"
  pkg.md5sum "2a431d487dfd76d0f618d241b1e551cc"
  pkg.url "http://ftp.gnu.org/gnu/gmp/gmp-#{pkg.get_version}.tar.gz"

  if platform.name =~ /el-4/
    pkg.build_requires "pl-tar"
  end
end
