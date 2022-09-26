project 'pl-gcc12' do |proj|
    # Project level settings our components will care about
    instance_eval File.read('configs/projects/pl-build-tools.rb')
  
    proj.description 'Puppet Labs GCC'

    platform_name = platform.name
    unless platform_name == 'el-7-x86_64' or platform_name == 'sles-12-x86_64'
      raise 'pl-gcc12 is currently only built for el-7-x86_64 and sles-12-x86_64'
    end

    gcc_version = '12.2.0'
    proj.release '0'
  
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
      libdir =  '/opt/pl-build-tools/lib64'
      proj.setting(:libdir, libdir)
      proj.setting(:cflags, "-I#{proj.includedir}")
      proj.setting(:ldflags, "-L#{libdir} -Wl,-rpath=#{libdir}")
    end
  
    # https://gmplib.org
    proj.setting(:gmp_version, '6.2.1')
    proj.setting(:gmp_md5sum, '0b82665c4a92fd2ade7440c13fcaa42b')
    proj.component 'gmp'
  
    # https://www.mpfr.org
    proj.setting(:mpfr_version, '4.1.0')
    proj.setting(:mpfr_md5sum, '81a97a9ba03590f83a30d26d4400ce39')
    proj.component 'mpfr'
  
    # https://directory.fsf.org/wiki/Mpc
    proj.setting(:mpc_version, '1.2.0')
    proj.setting(:mpc_md5sum, '2f1ce56ac775f2be090863f364931a03')
    proj.component 'mpc'
  
    proj.component 'gcc12'
  
    if platform.is_cross_compiled?
      proj.component 'sysroot'
    end
  
    proj.target_repo ''
  end
