project "pl-gcc" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description "Puppet Labs GCC"

  if platform.name =~ /debian-8-armel|debian-9|el-7-aarch64|el-7-ppc64|fedora-f27|fedora-28|sles-12-ppc64le|ubuntu-16\.04-ppc64el|ubuntu-18\.(04|10)/
    proj.version "6.1.0"
    proj.release "6"
  elsif platform.is_aix? || platform.architecture == "s390x" || platform.architecture =~ /arm/
    proj.version "5.2.0"
    proj.release "11"
  else
    proj.version "4.8.2"
    proj.release "9"
  end

  if platform.is_cross_compiled?
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

  if platform.is_cross_compiled?
    proj.component "sysroot"
  end

  proj.target_repo ""
end
