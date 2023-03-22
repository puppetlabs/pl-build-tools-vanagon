project "pl-cmake" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description "Puppet Labs cmake"
  proj.setting(:cmake_version, '3.26.0')
  proj.version settings[:cmake_version]
  proj.release '1'

  proj.license 'BSD 3-clause'
  proj.vendor 'Puppet By Perforce <release@puppet.com>'
  proj.homepage 'https://www.puppet.com'

  # Platform specific
  proj.setting(:cflags, "-I#{proj.includedir}")
  proj.setting(:ldflags, "-L#{proj.libdir} -Wl,-rpath=#{proj.libdir}")

  proj.component 'toolchain'
  proj.component 'cmake'
  proj.target_repo ""
end
