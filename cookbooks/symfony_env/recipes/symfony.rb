execute "sylius install" do
  cwd node["app"]["web_path"] + node["app"]["name"]
  command "php app/console sylius:install"
  user "www-data"
  action :run
end