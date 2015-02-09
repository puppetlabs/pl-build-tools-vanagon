component "make" do |pkg, settings, platform|
  pkg.version "4.1"
  pkg.md5sum "654f9117957e6fa6a1c49a8f08270ec9"
  pkg.url "http://buildsources.delivery.puppetlabs.net/#{pkg.get_name}-#{pkg.get_version}.tar.gz"

  pkg.build_requires "gcc"
  pkg.build_requires "gcc-c++"
  pkg.build_requires "make"

  pkg.configure do
    [ "./configure --prefix=#{settings[:prefix]}" ]
  end

  pkg.build do
    [ platform[:make] ]
  end

  pkg.install do
    [ "#{platform[:make]} install" ]
  end

end
