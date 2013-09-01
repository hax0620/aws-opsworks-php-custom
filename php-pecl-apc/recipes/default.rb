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

# try to install geoip, pecl may return 1 if already installed
bash "install_pecl_geoip" do
  user "root"
  code <<-EOH
    pecl install geoip
    exit 0
  EOH
  returns [0,'1',1]
end

bash "enable_geoip_module_for_php" do
  code <<-EOH
    printf 'extension=geoip.so\n' | tee /etc/php.d/geoip.ini
  EOH
end

include_recipe "php-pecl-apc::configure"

service "apache2" do
  action :restart
end
