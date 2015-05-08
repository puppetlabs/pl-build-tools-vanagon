platform "osx-10.9-x86_64" do |plat|
  plat.servicetype 'launchd'
  plat.servicedir '/Library/LaunchDaemons'
  plat.provision_with 'mkdir /usr/local; cd /usr/local; git clone https://github.com/Homebrew/homebrew.git .'
  plat.install_build_dependencies_with "#"
  plat.vcloud_name "osx-109-x86_64"
end
