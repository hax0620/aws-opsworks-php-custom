node[:deploy].each do |app_name, deploy|

  script "install_composer" do
    interpreter "bash"
    user "root"
    cwd "#{deploy[:deploy_to]}/current"
    code <<-EOH
    curl -sS https://getcomposer.org/installer | php
    php composer.phar install
    EOH
  end

  template "#{deploy[:deploy_to]}/current/.htaccess" do
    source ".htaccess.erb"
    mode 0644
    group deploy[:group]

    if platform?("ubuntu")
      owner "www-data"
    elsif platform?("amazon")   
      owner "apache"
    end

    variables(
      :env =>    (node[:webservices][:env] rescue nil)
    )

   only_if do
     File.directory?("#{deploy[:deploy_to]}/current")
   end
  end
end