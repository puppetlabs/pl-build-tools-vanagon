project "pl-gettext" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description "Puppet gettext"
  # Windows rejects a 4-number version, because adding the release makes it 5.
  proj.version "0.19.8"
  proj.license "GPLv3+"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"

  proj.component "gettext"
  proj.target_repo ""

end

