project "pl-libffi" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description "Puppet lib ffi"
  proj.version "3.0.13"
  proj.license "MIT"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"

  proj.component "libffi"
  proj.target_repo ""

end
