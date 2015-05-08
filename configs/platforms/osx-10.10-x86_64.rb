platform "osx-10.10-x86_64" do |plat|
  plat.servicetype 'launchd'
  plat.servicedir '/Library/LaunchDaemons'
  plat.provision_with 'mkdir /usr/local; cd /usr/local; git clone https://github.com/Homebrew/homebrew.git .'
  plat.provision_with 'curl -o /usr/local/bin/osx-deps http://pl-build-tools.delivery.puppetlabs.net/osx/osx-deps; chmod 755 /usr/local/bin/osx-deps'
  plat.install_build_dependencies_with "/usr/local/bin/osx-deps "
  plat.vcloud_name "osx-1010-x86_64"
end
