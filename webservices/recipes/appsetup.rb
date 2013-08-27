node[:deploy].each do |app_name, deploy|

  template "#{deploy[:deploy_to]}/current/.htaccess" do
    source ".htaccess.erb"
    mode 0660
    group deploy[:group]

    if platform?("ubuntu")
      owner "www-data"
    elsif platform?("amazon")   
      owner "apache"
    end

    variables(
      :env =>      (deploy[:webservices][:env] rescue nil)
    )

   only_if do
     File.directory?("#{deploy[:deploy_to]}/current")
   end
  end
end