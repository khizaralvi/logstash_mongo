#
# Cookbook Name:: logstash_mongo
# Recipe:: default
#
# Copyright 2016, The Walt Disney Company
#
# All rights reserved - Do Not Redistribute
#


case node ['platform family']
when 'windows' 
package_name = 
	if node['logstash']['version'] == "2.3.2"
		package_name = "logstash-#{node['nxlog']['version']}.zip"
		link = "https://download.elastic.co/logstash/logstash"
	elsif node['logstash']['version'] =~ /5./
		package_name = "logstash-#{node['nxlog']['version']}.zip"
		link = "https://artifacts.elastic.co/downloads/logstash"
    end

  remote_file 'logstash' do
    #path "#{Chef::Config[:file_cache_path]}/#{package_name}"
	path "#{node['logstash']['root_dir']}"
    source "#{link}/#{package_name}"
    mode 755
	action :create_if_missing
	not_if {::File.exists?("#{node['logstash']['root_dir']}/#{package_name}")}
  end

windows_zipfile 'unzip logstash zip package' do
  source "#{node['logstash']['root_dir']}/#{package_name}"
  path "#{node['logstash']['root_dir']}"
  action :unzip
  not_if {::File.exists?("#{node['logstash']['root_dir']}/#{node['logstash']['version']}")}
end

directory 'logstash_conf_dir' do
  path "#{node['logstash']['conf_dir']}"
  rights :full_control, 'Everyone'
  action :create
end

['a_inputs.conf', 'b_filters.conf', 'c_outputs.conf'].each do |file|
  cookbook_file "#{node['logstash']['conf_dir']}" do
    source "default/#{file}"
    rights :full_control, 'Everyone'
    action :create
  end
end

batch 'start logstash agent' do
  cwd "#{node['logstash']['root_dir']}/logstash-#{node['nxlog']['version']}/bin"
  code <<-EOH
   logstash -f \"#{node['logstash']['conf_dir']}/*conf\"
   EOH
end


when 'rhel', 'centos' 
	if node['logstash']['version'] == "2.3.2"
		package_name = "logstash-#{node['logstash']['version']}-1.noarch.rpm"
		link = "https://download.elastic.co/logstash/logstash/packages/centos"
	elsif node['logstash']['version'] =~ /5./
		package_name = "logstash-#{node['logstash']['version']}.rpm"
		link = "https://artifacts.elastic.co/downloads/logstash"
    end

bash 'download/install logstash' do
  cwd "#{node['logstash']['root_dir']}"
  user 'root'
  code <<-EOH
    wget #{link}/#{package_name}
    rpm -ivh #{package_name}
    EOH
  not_if { ::File.exist?("#{package_name}") }
end

service 'logstash' do
  action [:enable, :start]
end

['a_inputs.conf', 'b_filters.conf', 'c_outputs.conf'].each do |file|
  cookbook_file "#{node['logstash']['conf_dir']}" do
    source "default/#{file}"
	owner 'logstash'
	group 'logstash' 
    mode '0755'
    action :create
	notifies :restart, 'service[logstash]', :delayed
  end
end

end


