#
# Cookbook Name:: php-fpm
# Recipe:: default
#
# Copyright 2012, Benedict Steele
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package "php5-fpm" do
	action :install
end


directory node['php-fpm']['conf_dir'] do
  owner "root"
  group "root"
  mode "0755"
  recursive true
end

directory "#{node['php-fpm']['conf_dir']}/pool.d" do
  owner "root"
  group "root"
  mode "0755"
  recursive true
end

directory "/var/log/php-fpm" do
  owner "www-data"
  group "www-data"
  mode "0755"
  recursive true
end

template "#{node['php-fpm']['conf_dir']}/php.ini" do
  source "php.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[php5-fpm]"
end

template "#{node['php-fpm']['conf_dir']}/php-fpm.conf" do
  source "php-fpm.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[php5-fpm]"
end

template "#{node['php-fpm']['conf_dir']}/pool.d/www.conf" do
  source "pool.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[php5-fpm]"
end

service "php5-fpm" do
  supports :restart => true, :reload => true
  action [ :enable, :start ]
end