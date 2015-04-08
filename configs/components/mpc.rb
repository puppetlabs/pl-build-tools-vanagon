# This is here just for the downloading and unpacking
component "mpc" do |pkg, settings, platform|
  pkg.version "0.8.1"
  pkg.md5sum "5b34aa804d514cc295414a963aedb6bf"
  pkg.url "http://buildsources.delivery.puppetlabs.net/mpc-#{pkg.get_version}.tar.gz"
end
