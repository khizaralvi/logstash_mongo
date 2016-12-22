default['logstash']['version'] = '2.3.2'
version = "#{default['logstash']['version']}"

default['logstash']['log_level'] = 'INFO'
default['logstash']['user'] = 'logstash'
default['logstash']['group'] = 'logstash'

case node['platform_family']
when 'rhel', 'centos' 
  default ['logstash']['root_dir'] = "/opt"
  default['logstash']['conf_dir'] = "/etc/logstash/conf.d"
when 'windows'
  if node['kernel']['machine'] == 'x86_64'
    root_dir = "c:/Program Files (x86)"
  else
    root_dir = "c:/Program Files"
  end
  default['logstash']['root_dir'] = root_dir
  default['logstash']['conf_dir'] = "c:/conf/mongo_logstash"
else
  Chef::Application.fatal!('Attempted to install on an unsupported platform')
end
