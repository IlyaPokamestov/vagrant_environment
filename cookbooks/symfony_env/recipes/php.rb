apt_package "php5-cli" do
  action [:install, :upgrade]
end

apt_package "php5-fpm" do
  action [:install, :upgrade]
end

apt_package "php5-intl" do
  action [:install, :upgrade]
end

apt_package "php5-xdebug" do
  action [:install, :upgrade]
end

apt_package "php5-mcrypt" do
  action [:install, :upgrade]
end

apt_package "php5-gd" do
  action [:install, :upgrade]
end

apt_package "php5-curl" do
  action [:install, :upgrade]
end