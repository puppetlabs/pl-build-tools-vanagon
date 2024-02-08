project "pl-cmake" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description "Puppet Labs cmake"
  cmake_version = '3.28.0'
  proj.setting(:cmake_source_md5sum, 'a28e9df8b4903c72f05122e8a088acc7')
  proj.setting(:cmake_version, cmake_version)
  proj.version cmake_version
  proj.release '1'

  cmake_major_minor = cmake_version.split('.')[0..1].join('.')
  cmake_tarball_name = "cmake-#{cmake_version}.tar.gz"

  proj.setting(
    :cmake_download_url,
    "https://cmake.org/files/v#{cmake_major_minor}/#{cmake_tarball_name}"
  )
  proj.setting(:cmake_tarball_name, cmake_tarball_name)

  proj.license 'BSD 3-clause'
  proj.vendor 'Puppet By Perforce <release@puppet.com>'
  proj.homepage 'https://www.puppet.com'

  # Platform specific
  proj.setting(:cflags, "-I#{proj.includedir}")
  proj.setting(:ldflags, "-L#{proj.libdir} -Wl,-rpath=#{proj.libdir}")

  proj.component 'toolchain'
  proj.component 'cmake'
  proj.target_repo ''
end
