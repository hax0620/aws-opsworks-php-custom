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

  if platform?("ubuntu")
    web_owner = "www-data"
  elsif platform?("amazon")   
    web_owner "apache"
  end
  
  if node.chef_environment == "QA"
     branch_name = "staging"
  else
     branch_name = "master"
  end
  
  # create themes folder if not exist
  directory "#{deploy[:deploy_to]}/current/themes" do
    user web_owner
    group deploy[:group]
    mode 0775
    action :create
  end
  
  # Custom theme will be pulled and synced from remote repository
  theme = {}
  theme[:name] = (node[:webservices][:theme] rescue 'one')
  theme[:git]  = (node[:webservices][:git] rescue 'git@github.com:jpaljasma/test-opsworks-chef-git-deploy.git')
  theme[:branch] = branch_name
  
  git "#{deploy[:deploy_to]}/current/themes/#{theme[:name]}" do
     repository theme[:git]
     revision theme[:branch]
     action :sync
     user web_owner
     group deploy[:group]
   only_if do
     File.directory?("#{deploy[:deploy_to]}/current")
   end
  end
  
  # create theme.php from template
  template "#{deploy[:deploy_to]}/current/theme.php" do
    source "theme.php.erb"
    mode 0644
    group deploy[:group]
    owner web_owner

    variables(
      :theme => theme[:name]   
    )

   only_if do
     File.directory?("#{deploy[:deploy_to]}/current")
   end
  end
  
  # create production .htaccess file
  template "#{deploy[:deploy_to]}/current/.htaccess" do
    source ".htaccess.erb"
    mode 0644
    group deploy[:group]
    owner web_owner

    variables(
      :env =>    (node[:webservices][:env] rescue nil)
    )

   only_if do
     File.directory?("#{deploy[:deploy_to]}/current")
   end
  end
end
