include_recipe "apache2::service"
include_recipe "php-pecl-apc::configure"

service "apache2" do
  action :reload
end