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

bash "download_geoip_db" do
  not_if do
    File.exists?("/usr/share/GeoIP/GeoIP.dat") &&
    File.mtime("/usr/share/GeoIP/GeoIP.dat") > Time.now - 86400
  end
  user "root"
  code <<-EOH
    cd /tmp
    rm -f /tmp/GeoIP.dat.gz
    wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
    gunzip GeoIP.dat.gz
    sudo mv -f GeoIP.dat /usr/share/GeoIP/GeoIP.dat
  EOH
end

bash "download_geolite_city_db" do
  not_if do
    File.exists?("/usr/share/GeoIP/GeoIPCity.dat") &&
    File.mtime("/usr/share/GeoIP/GeoIPCity.dat") > Time.now - 86400
  end
  user "root"
  code <<-EOH
    cd /tmp
    rm -f /tmp/GeoLiteCity.dat.gz
    wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
    gunzip GeoLiteCity.dat.gz
    sudo mv -f GeoLiteCity.dat /usr/share/GeoIP/GeoIPCity.dat
  EOH
end

include_recipe "php-pecl-apc::configure"

service "apache2" do
  action :restart
end
