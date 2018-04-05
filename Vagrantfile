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
KDK_FILENAME = "#{KDK_NAME}.box"
KDK_BASE_VERSION = "v0.1.0"
KDK_BASE_NAME = "k8s-devkit-base-#{KDK_BASE_VERSION}"
KDK_BASE_FILENAME = "#{KDK_BASE_NAME}.box"
KDK_BASE_TOKEN = File.read("#{keybase_root}/team/***REMOVED***/minio-basic-auth/non-prod/pass").strip
KDK_BASE_URL = "https://token:#{KDK_BASE_TOKEN}@minio.platform.csco.cloud/platform-public/vbox/#{KDK_BASE_FILENAME}"
KDK_BASE_SHA256 = "5ac30bb2a0dd939f466984cd2952572bccbf3c45fc9c90baa0b5099c1f682129"

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

  # Install Vagrant plugins if they are not already installed.
  required_plugins = %w( vagrant-vbguest vagrant-disksize vagrant-proxyconf )
  _retry = false
  required_plugins.each do |plugin|
    unless Vagrant.has_plugin? plugin
      system "vagrant plugin install #{plugin}"
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
  config.vm.box = env('KDK_BASE_NAME')
  config.vm.box_download_checksum = env('KDK_BASE_SHA256')
  config.vm.box_download_checksum_type = "sha256"
  config.vm.box_download_insecure = true
  config.vm.box_url = env('KDK_BASE_URL')

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
  if File.directory?(File.expand_path("~/Dev"))
    config.vm.synced_folder "~/Dev", "/home/vagrant/Dev"
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
      "KDK_FILENAME"  => env('KDK_FILENAME'),
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
