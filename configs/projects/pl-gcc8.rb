project 'pl-gcc8' do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description 'Puppet Labs GCC 8'
  gcc_version = '8.4.0'

  proj.version gcc_version
  proj.release '1'

  proj.setting(:gcc_version, gcc_version)
  proj.setting(:gcc_md5sum, '732a4fd69c36c0a12ee2b43368ccf3c9')

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
  proj.setting(:mpfr_version, '3.1.6')
  proj.setting(:mpfr_md5sum, '95dcfd8629937996f826667b9e24f6ff')
  proj.component 'mpfr'

  # https://directory.fsf.org/wiki/Mpc
  proj.setting(:mpc_version, '1.0.3')
  proj.setting(:mpc_md5sum, 'd6a1d5f8ddea3abd2cc3e98f58352d26')
  proj.component 'mpc'

  proj.component 'gcc8'

  if platform.is_cross_compiled?
    proj.component 'sysroot'
  end

  proj.target_repo ''
end
