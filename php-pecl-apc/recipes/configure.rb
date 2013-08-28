etc_dir = "/etc/php.d/"
conf_apc    = "apc.ini"

template "#{etc_dir}/#{conf_apc}" do
  
  owner 'root'
  group 'root'
  mode     "0755"
  source   "apc.ini.erb"
  
  variables(
    :enabled        => (node["php-pecl-apc"]["enabled"]  rescue '1'),
    :shm_size       => (node["php-pecl-apc"]["shm_size"] rescue '128M'),
    :gc_ttl         => (node["php-pecl-apc"]["gc_ttl"]   rescue '900')
  )
  
end