component "perl" do |pkg, settings, platform|
  pkg.version "5.26.2"
  pkg.md5sum "dc0fea097f3992a8cd53f8ac0810d523"
  pkg.url "https://www.cpan.org/src/5.0/perl-#{pkg.get_version}.tar.gz"
  pkg.mirror "https://artifactory.delivery.puppetlabs.net/artifactory/generic__buildsources/buildsources/perl-#{pkg.get_version}.tar.gz"

  pkg.configure do
    [ "sh Configure -de -Dprefix=#{settings[:prefix]}" ]
  end

  pkg.build do
    [ platform[:make] ]
  end

  pkg.install do
    [ "#{platform[:make]} install" ]
  end
end
