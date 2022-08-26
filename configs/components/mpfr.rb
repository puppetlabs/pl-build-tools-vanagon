##
# GNU MPFR (https://www.mpfr.org) C library for multiple-precision floating-point computations

# This is here just for the downloading and unpacking
component 'mpfr' do |pkg, settings, _platform|
  pkg.version settings[:mpfr_version]
  pkg.md5sum '81a97a9ba03590f83a30d26d4400ce39'
  pkg.url "http://ftp.gnu.org/gnu/mpfr/mpfr-#{pkg.get_version}.tar.gz"
end
