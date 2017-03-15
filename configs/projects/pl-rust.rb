project "pl-rust" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description "Puppet Labs Rust"
  proj.version "1.16.0"
  proj.release "1"
  proj.license "Apache 2.0 and MIT"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"
  proj.component "rust"
  proj.target_repo ""

  proj.register_rewrite_rule 'http', 'http://buildsources.delivery.puppetlabs.net'
end
