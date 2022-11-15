Vagrant.configure("2") do |config|
  # Define the base OS
  config.vm.box = "ubuntu/xenial64"  
  # mounting the cache file with /vagrant/cache 
  # so that files replacement shall be easier
  config.vm.synced_folder "cache", "/vagrant/cache" 

  config.vm.define :master, primary: true do |master|
    master.vm.provider "virtualbox" do |v|
      # Setup 512 MB for Master 
      v.customize ["modifyvm", :id, "--name", "master", "--memory", "512"] 
    end
    master.vm.hostname = "master"
    # Setup static IP for Master in Private Network
    master.vm.network :private_network, ip: "192.168.56.10" 
    master.vm.provision "shell", inline: "sudo echo 'master' > /etc/hostname"
  end

  (1..2).each do |i|
    config.vm.define "slave#{i}" do |node|
      node.vm.hostname = "slave#{i}"
      # Setup static IP for both slaves:
      # slave1: 192.168.56.11
      # slave2: 192.168.56.12
      node.vm.network :private_network, ip: "192.168.56.1#{i}"
      node.vm.provider "virtualbox" do |vb|
        # Setup 1024 MB for each Slave
        vb.memory = "1024"  
      end
      node.vm.provision "shell", inline: "sudo echo 'slave#{i}' > /etc/hostname"
    end
  end

  # Run init.sh scripts for all vms -- including master, slave1, slave2
  config.vm.provision "shell", path: "init.sh" 

  # Extra scripts for setting up Cluster in master 
  config.vm.define :master, primary: true do |master|
    $script = <<-SCRIPT
    source /etc/profile
    ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
    cp ~/.ssh/id_rsa.pub /vagrant/cache/master.pub
    cat ~/.ssh/id_rsa.pub > /vagrant/cache/authorized_keys
    SCRIPT
    master.vm.provision "shell", inline: "sudo echo 'slave1' > /usr/local/hadoop/etc/hadoop/slaves"
    master.vm.provision "shell", inline: "sudo echo 'slave2' >> /usr/local/hadoop/etc/hadoop/slaves"
    master.vm.provision "shell", inline: $script, privileged: false
  end

  # Extra scripts for setting up Cluster in slaves
  (1..2).each do |i|
    config.vm.define "slave#{i}" do |node|
      $script = <<-SCRIPT
    source /etc/profile
    ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
    cp ~/.ssh/id_rsa.pub /vagrant/cache/slave#{i}.pub
    cat ~/.ssh/id_rsa.pub >> /vagrant/cache/authorized_keys
      SCRIPT
      node.vm.provision "shell", inline: $script, privileged: false
    end
  end
end
