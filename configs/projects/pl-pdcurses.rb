project "pl-pdcurses" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description "Puppet zlib"
  proj.version "3.4"
  proj.license "pdcurses"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"

  proj.component "pdcurses"
  proj.target_repo ""
end
