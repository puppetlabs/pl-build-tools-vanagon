project "pl-toolchain" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description "Puppet Labs cmake toolchain files"
  proj.version "2015.11.30"
  proj.license "Puppet Labs"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"

  proj.component "toolchain"
  proj.target_repo ""
end
