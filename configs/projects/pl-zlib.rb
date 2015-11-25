project "pl-zlib" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description "Puppet zlib"
  proj.version "1.2.8"
  proj.license "Zlib"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"

  proj.component "zlib"
  proj.target_repo ""
end
