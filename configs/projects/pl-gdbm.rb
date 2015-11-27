project "pl-gdbm" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description "Puppet gdbm"
  proj.version "1.10"
  proj.license "gdbm"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"

  proj.component "gdbm"
  proj.target_repo ""
end
