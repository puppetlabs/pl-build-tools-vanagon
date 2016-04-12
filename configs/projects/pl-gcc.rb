project "pl-gcc" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description "Puppet Labs GCC"

  if platform.is_aix? or platform.architecture == "s390x"
    proj.version "5.2.0"
  else
    proj.version "4.8.2"
  end
  proj.release "4"

  if platform.name =~ /huaweios|solaris-11/ or platform.architecture == "s390x"
    proj.name "pl-gcc-#{platform.architecture}"
    proj.noarch
  end

  proj.license "Same as GCC"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"

  # Platform specific - these flags do not work on AIX
  unless platform.is_aix?
    proj.setting(:cflags, "-I#{proj.includedir}")
    proj.setting(:ldflags, "-L#{proj.libdir} -Wl,-rpath=#{proj.libdir}")
  end

  proj.component "gmp"
  proj.component "mpfr"
  proj.component "mpc"
  proj.component "gcc"

  if platform.is_huaweios? or platform.architecture == "s390x"
    proj.component "sysroot"
  end

  if platform.is_solaris? && platform.architecture.downcase == 'sparc'
    proj.component "sysroot"
  end

  proj.target_repo ""
end
