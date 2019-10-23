# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|

  config.vm.box = "hashicorp/bionic64"
  # config.vm.network "private_network", ip: "10.0.2.15"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Nginx
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # Consul UI
  config.vm.network "forwarded_port", guest: 8500, host: 8500

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # This is required for the consul UI to be visible from your host machine
  # config.vm.network "public_network"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y nginx unzip wget
    mkdir -p /etc/consul

    systemctl start nginx

    wget -O /tmp/consul.zip https://releases.hashicorp.com/consul/1.6.1/consul_1.6.1_linux_amd64.zip
    unzip /tmp/consul.zip -d /usr/local/bin/
  SHELL

  # Add our config files
  config.vm.provision "file", source: "./config/nginx_killswitch_watch.json", destination: "/tmp/nginx_killswitch_watch.json"
  config.vm.provision "file", source: "./config/nginx_killswitch_handler.sh", destination: "/tmp/nginx_killswitch_handler.sh"
  config.vm.provision "file", source: "./config/consul-server.json", destination: "/tmp/server.json"


  # Start Consul and add the 'enabled' key
  config.vm.provision "shell", inline: <<-SHELL
    # Place config files
    chown root:root /tmp/nginx_killswitch_watch.json
    chown root:root /tmp/server.json
    chown root:root /tmp/nginx_killswitch_handler.sh

    mv /tmp/nginx_killswitch_watch.json /etc/consul/nginx_killswitch_watch.json
    mv /tmp/server.json /etc/consul/server.json
    mv /tmp/nginx_killswitch_handler.sh /usr/local/bin/nginx_killswitch_handler.sh

    chmod +x /usr/local/bin/nginx_killswitch_handler.sh

    # Start consul and wait for it to come up
    consul agent -config-dir /etc/consul -bootstrap -bind '{{ GetInterfaceIP "eth0" }}' -client 0.0.0.0 &
    sleep 5

    # Add the appropriate key
    consul kv put service/nginx/enabled "true"
  SHELL
end
