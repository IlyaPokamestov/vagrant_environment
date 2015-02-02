# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "trusty64"
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

  config.vm.define "symfony" do |symfony|
  end

  # config.vm.box_check_update = false
  config.vm.network "private_network", ip: "192.168.33.12"
  config.vm.synced_folder "./../../", "/var/www/vhosts"
  #, type: "smb", id: "vagrant-root", mount_options: ["dmode=777","fmode=777"]

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--memory", 1024]
    v.customize ["modifyvm", :id, "--name", "symfony"]
    v.gui = true
  end

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.roles_path = "roles"
    chef.add_role "web"

    chef.json = {
     "app" => {
      "name" => "flat",
      "web_path" => "/var/www/vhosts/"
     }
   }
  end

end