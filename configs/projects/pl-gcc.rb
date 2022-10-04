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
  proj.setting(:gmp_version, '4.3.2')
  proj.setting(:gmp_md5sum, '2a431d487dfd76d0f618d241b1e551cc')
  proj.component 'gmp'

  # https://www.mpfr.org
  proj.setting(:mpfr_version, '2.4.2')
  proj.setting(:mpfr_md5sum, '0e3dcf9fe2b6656ed417c89aa9159428')
  proj.component 'mpfr'

  # https://directory.fsf.org/wiki/Mpc
  proj.setting(:mpc_version, '1.0.3')
  proj.setting(:mpc_md5sum, 'd6a1d5f8ddea3abd2cc3e98f58352d26')
  proj.component 'mpc'

  proj.component 'gcc'

  if platform.is_cross_compiled?
    proj.component 'sysroot'
  end

  proj.target_repo ''
end
