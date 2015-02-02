#
# Cookbook Name:: symfony_env
# Recipe:: default
#
# Copyright (c) 2015 Ilya Pokamestov, All Rights Reserved

include_recipe "nginx::server"

directory node["app"]["web_path"] + node["app"]["name"] do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

include_recipe "symfony_env::php"

include_recipe "composer"

composer node["app"]["web_path"] + node["app"]["name"] do
  action :update
end

nginx_site node["app"]["name"] do
  host node["app"]["name"] + " www." + node["app"]["name"]
  root node["app"]["web_path"] + node["app"]["name"]
  template_cookbook 'symfony_env'
  template_source 'nginx_site.erb'
  action [:create, :enable]
end