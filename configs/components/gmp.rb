# This is here just for the downloading and unpacking
component "gmp" do |pkg, settings, platform|
  pkg.version "4.3.2"
  pkg.md5sum "2a431d487dfd76d0f618d241b1e551cc"
  pkg.url "http://buildsources.delivery.puppetlabs.net/gmp-#{pkg.get_version}.tar.gz"


  pkg.configure do
    #"mkdir -p ../holding; mv ../#{pkg.get_name}-#{pkg.get_version} ../holding"
    ""
  end

  pkg.build do
    ""
  end

  pkg.install do
    ""
  end
end
