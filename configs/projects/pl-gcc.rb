project 'pl-gcc' do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description 'Puppet Labs GCC'

  if platform.name =~ /el-7-aarch64|el-7-ppc64|sles-12-ppc64le|ubuntu-18\.(04|10)/
    proj.version '6.1.0'
    proj.release '6'
  elsif platform.is_aix? || platform.architecture =~ /arm/
    proj.version '5.2.0'
    proj.release '11'
  else
    proj.version '4.8.2'
    proj.release '10'
  end

  if platform.is_cross_compiled?
    proj.name "pl-gcc-#{platform.architecture}"
    proj.noarch
  end

  proj.license 'Same as GCC'
  proj.vendor 'Puppet Labs <info@puppetlabs.com>'
  proj.homepage 'https://www.puppetlabs.com'

  # Platform specific - these flags do not work on AIX
  unless platform.is_aix?
    proj.setting(:cflags, "-I#{proj.includedir}")
    proj.setting(:ldflags, "-L#{proj.libdir} -Wl,-rpath=#{proj.libdir}")
  end

  # https://gmplib.org
  proj.setting(:gmp_version, '5.1.3')
  proj.setting(:gmp_md5sum, 'e5fe367801ff067b923d1e6a126448aa')
  proj.component 'gmp'

  # https://www.mpfr.org
  proj.setting(:mpfr_version, '3.1.6')
  proj.setting(:mpfr_md5sum, '95dcfd8629937996f826667b9e24f6ff')
  proj.component 'mpfr'

  # https://directory.fsf.org/wiki/Mpc
  proj.setting(:mpc_version, '1.2.0')
  proj.setting(:mpc_md5sum, '2f1ce56ac775f2be090863f364931a03')
  proj.component 'mpc'

  proj.component 'gcc'

  if platform.is_cross_compiled?
    proj.component 'sysroot'
  end

  proj.target_repo ''
end
