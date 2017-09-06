project "pl-curl" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description "Puppet CURL"
  proj.version "7.46.0"
  proj.license "CURL"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"

  if platform.is_windows?
    # Explicitly add mingw headers for OpenSSL's makedepend
    arch = platform.architecture == "x64" ? "64" : "32"
    proj.setting(:cflags, "-I#{platform.convert_to_windows_path(proj.includedir)} -IC:/tools/mingw#{arch}/include")
    proj.setting(:ldflags, "-L#{platform.convert_to_windows_path(proj.libdir)} -LC:/tools/mingw#{arch}/lib")
  else
    proj.setting(:cflags, "-I#{proj.includedir}")
    proj.setting(:ldflags, "-L#{proj.libdir} -Wl,-rpath=#{proj.libdir}")
  end

  proj.component "curl"
  proj.target_repo ""
end
