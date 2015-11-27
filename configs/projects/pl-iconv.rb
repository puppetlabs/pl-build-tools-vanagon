project "pl-iconv" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description "Puppet iconv"
  proj.version "1.14"
  proj.license "iconv"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"

  proj.component "iconv"
  proj.target_repo ""

end
