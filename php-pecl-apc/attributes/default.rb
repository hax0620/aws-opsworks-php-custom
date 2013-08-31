default["php-pecl-apc"] = {}
default["php-pecl-apc"]["enabled"] = '1'
default["php-pecl-apc"]["shm_size"] = '256M'
default["php-pecl-apc"]["gc_ttl"] = '600'

default["php-pecl-apc"]['geoip'] = {}
default["php-pecl-apc"]['geoip']['path'] = "/usr/share/GeoIP/"
default["php-pecl-apc"]['geoip']['country_dat_url'] = "http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz"
default["php-pecl-apc"]['geoip']['city_dat_url']    = "http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz"
