# -*- mode: ruby -*-
# vi: set ft=ruby :

#####################################################################
# Checks

keybase_root = nil
if File.directory?("/keybase/team")
  keybase_root = "/keybase"
elsif File.directory?("k:/team")
  keybase_root = "k:"
else
  puts "WARNING: Required keybase.io VirtualFS is not present"
  puts "  On Linux and OSX, KeybaseFS would be mounted under /keybase"
  puts "  On Windows, KeybaseFS would be mounted under k:"
  puts "This Vagrant automation as well as virtual machine configuration"
  puts "  depend on the secrets in keybase.io"
  exit 1
end

#####################################################################
# Enviroment Configuration Settings
#   These settings may be overriden via Environment Variables

KDK_VERSION = "v0.1.0"
KDK_NAME = "k8s-devkit-#{KDK_VERSION}"

def env(name)
   # Returns string from enviroment first, otherwise the variable value
   return ENV[name] || eval("#{name}")
end

#####################################################################
# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  # Install Vagrant plugins if they are NOT already installed.
  install_plugins = %w( vagrant-disksize vagrant-proxyconf )
  _retry = false
  install_plugins.each do |plugin|
    unless Vagrant.has_plugin? plugin
      system "vagrant plugin install #{plugin}"
      _retry=true
    end
  end
  if (_retry)
    exec "vagrant " + ARGV.join(' ')
  end

  # Remove Vagrant plugins if they ARE already installed.
  #   Force uninstall of vagrant-vbguest.  On vbox 5.2.12 working on the bento
  #     centos7 image, it uninstalls the existing vbox-additions 5.2.6 and then
  #     fails to install vbox-additions 5.2.12 because it fails to install
  #     kernel-devel package most likely becuase of lack of yum update.
  #     Re-enable once re-tested in a few months.
  remove_plugins = %w( vagrant-vbguest )
  _retry = false
  remove_plugins.each do |plugin|
    if Vagrant.has_plugin? plugin
      system "vagrant plugin uninstall #{plugin}"
      _retry=true
    end
  end
  if (_retry)
    exec "vagrant " + ARGV.join(' ')
  end

  # Set box disk size.
  config.disksize.size = '64GB'

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "bento/centos-7.4"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Mount some directories from host in guest if they exist.
  ## Place to store your "Dev" stuff.
  require 'yaml'

  config_file = File.dirname(File.expand_path(__FILE__)) + "/config.yaml"

  if File.exist?(config_file)
    kdk_dev_folder = YAML.load_file(config_file)['kdk_dev_folder']
  else
    kdk_dev_folder = "Dev"
  end

  if File.directory?(File.expand_path("~/" + kdk_dev_folder))
    config.vm.synced_folder "~/" + kdk_dev_folder, "/home/vagrant/Dev"
  end

  ## Place to store secrets.
  ## ATTENTION: Requires Keybase client activation/sign-in on host OS.
  require 'pathname'
  keybase_dirs = [ "private", "public", "team" ]
  keybase_dirs.each { |dir|
    guest_path = "/keybase/" + dir
    host_path = String(Pathname.new(keybase_root + "/" + dir).realpath)

    if File.directory?(host_path)
      # parent dirs to be auto-created by synced_folder mount
      config.vm.synced_folder host_path, guest_path
    else
      puts "WARNING: Failed to mount keybase.io VirtualFS"
      puts "  host_path: " + host_path
      puts "  guest_path: " + guest_path
    end
  }

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 4000   # Megabytes
    vb.cpus = 2        # CPU Cores
    vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
  end

  # Enable ssh-agent forwarding.
  config.ssh.forward_agent = true

  # Enable SSH X11 forwarding.
  config.ssh.forward_x11 = true

  # Run shell script to prepare Vagrant VM.
  config.vm.provision "shell" do |shell|
    shell.privileged = false
    shell.path = "provision.sh"
    shell.env = {
      "KDK_NAME"      => env('KDK_NAME'),
      "KDK_VERSION"   => env('KDK_VERSION'),
      "SSH_AUTH_SOCK" => "${SSH_AUTH_SOCK}"
    }
  end

  # If host OS has proxy variables set, configure guest accordingly.
  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = ENV['HTTP_PROXY']
    config.proxy.https    = ENV['HTTPS_PROXY']
    config.proxy.no_proxy = ENV['NO_PROXY']
  end

end
