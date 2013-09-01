include_recipe "apache2::service"

packages = []

# install necessary packages: memcached, apc, geoip-devel
packages = [
  'php-pecl-memcached',
  'php-pecl-apc'
]

packages.each do |pkg|
  package pkg do
    action :install
  end
end

execute "install geoip-devel" do
  command "yum install geoip-devel -y"
  action :run
end

execute "install pecl geoip" do
  command "sudo pecl install geoip"
  action :run
end

include_recipe "php-pecl-apc::configure"

service "apache2" do
  action :restart
end
