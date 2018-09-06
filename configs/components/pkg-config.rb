component "pkg-config" do |pkg, settings, platform|
  pkg.version "0.28"
  pkg.md5sum "aa3c86e67551adc3ac865160e34a2a0d"
  pkg.url "http://pkgconfig.freedesktop.org/releases/pkg-config-#{pkg.get_version}.tar.gz"
  pkg.mirror "#{settings[:buildsources_url]}/pkg-config-#{pkg.get_version}.tar.gz"

  if platform.is_solaris?
    pkg.environment "PATH" => "#{settings[:bindir]}:/usr/ccs/bin:/usr/sfw/bin:/opt/csw/bin:$$PATH"
  else
    pkg.environment "PATH" => "#{settings[:bindir]}:$$PATH"
  end

  pkg.configure do
    "./configure --prefix=#{settings[:basedir]} --with-internal-glib"
  end

  pkg.build do
    "#{platform[:make]}"
  end

  pkg.install do
    "#{platform[:make]} install"
  end
end
