source ENV['GEM_SOURCE'] || "https://rubygems.org"

def location_for(place)
  if place =~ /^(git[:@][^#]*)#(.*)/
    [{ :git => $1, :branch => $2, :require => false }]
  elsif place =~ /^file:\/\/(.*)/
    ['>= 0', { :path => File.expand_path($1), :require => false }]
  elsif place =~ /(\d+\.\d+\.\d+)/
    [place, { :require => false }]
  end
end

gem 'vanagon', *location_for(ENV['VANAGON_LOCATION'] || '~> 0.15')
gem 'packaging', *location_for(ENV['PACKAGING_LOCATION'] || '~> 0.99')
gem 'artifactory'
gem 'json'
gem 'rake'
