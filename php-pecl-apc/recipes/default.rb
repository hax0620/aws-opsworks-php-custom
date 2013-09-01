include_recipe "apache2::service"

packages = []

# install necessary packages: memcached, apc, geoip-devel
packages = [
  'php-pecl-memcached',
  'php-pecl-apc',
  'geoip-devel'
]

packages.each do |pkg|
  package pkg do
    action :install
  end
end

include_recipe "php-pecl-apc::configure"

service "apache2" do
  action :restart
end
