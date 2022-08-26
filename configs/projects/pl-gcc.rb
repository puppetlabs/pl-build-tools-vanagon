project 'pl-gcc' do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description 'Puppet Labs GCC'

  if platform.is_aix? || platform.architecture =~ /arm/
    gcc_version = '5.2.0'
    proj.release '11'
  else
    gcc_version = '12.2.0'
    proj.release '0'
  end

  proj.version gcc_version
  proj.setting(:gcc_version, gcc_version)

  if platform.is_cross_compiled?
    proj.name "pl-gcc-#{platform.architecture}"
    proj.noarch
  end

  proj.license 'Same as GCC'
  proj.vendor 'Puppet Labs <info@puppet.com>'
  proj.homepage 'https://www.puppet.com'

  # Platform specific - these flags do not work on AIX
  unless platform.is_aix?
    proj.setting(:cflags, "-I#{proj.includedir}")
    proj.setting(:ldflags, "-L#{proj.libdir} -Wl,-rpath=#{proj.libdir}")
  end

  # https://gmplib.org
  proj.setting(:gmp_version, '6.2.1')
  proj.component 'gmp'

  # https://www.mpfr.org
  proj.setting(:mpfr_version, '4.1.0')
  proj.component 'mpfr'

  # https://directory.fsf.org/wiki/Mpc
  proj.setting(:mpc_version, '1.2.0')
  proj.component 'mpc'

  proj.component 'gcc'

  if platform.is_cross_compiled?
    proj.component 'sysroot'
  end

  proj.target_repo ''
end
