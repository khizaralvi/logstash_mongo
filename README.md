logstash_mongo Cookbook
=======================
This cookbook installs Logstash on a Linux or Windows host and sets up configuration files for parsing and transporting MongoDB server logs.

Supported Platforms
------------
Windows Server 2008r2-2012r2

RHEL/Centos Linux

Requirements
------------
TODO: List your cookbook requirements. Be sure to include any requirements this cookbook has on platforms, libraries, other cookbooks, packages, operating systems, etc.

Attributes
----------
default['logstash']['version'] = '2.3.0'
version = "#{default['logstash']['version']}"

default['logstash']['log_level'] = 'INFO'
default['logstash']['user'] = 'logstash'
default['logstash']['group'] = 'logstash'

default['logstash']['package_source'] = "https://nexus.disney.com/nexus/content/repositories/ops-global-sedds-yum/disney/dds/misc/logstash-agent"

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


Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Khizar Alvi
