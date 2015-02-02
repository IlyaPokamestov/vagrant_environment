# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "trusty64"
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
  
  # config.vm.box_check_update = false
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.synced_folder "./", "/var/www/vhosts/new_app", type: "smb"

  config.vm.provider :virtualbox do |vb|
    vb.gui = true
  end

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.roles_path = "roles"
    chef.add_role "web"

    chef.json = {
     "app" => {
      "name" => "new_app",
      "web_path" => "/var/www/vhosts/"
     }
   }
  end

end