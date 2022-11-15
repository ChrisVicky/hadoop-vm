#!/bin/bash
# Get Privileges
sudo su

# Improve apt-get Speed with Tsinghua Source
mv /etc/apt/sources.list /etc/apt/sources.list.back
cp /vagrant/cache/sources.list /etc/apt/sources.list

# apt-get update -y
# apt-get install openssh-client openssh-server rsync vim -y
# According to Experience, ssh, rsync, vim are perfectly Settled

# Disable Firewall
ufw disable

# Java1.8 Configuration
cd /usr/local
mkdir java
tar -zxf /vagrant/cache/jdk-8u161-linux-x64.tar.gz -C /usr/local/java
echo "export JAVA_HOME=/usr/local/java/jdk1.8.0_161" >> /etc/profile
echo "export CLASSPATH=.:\$JAVA_HOME/lib:\$JAVA_HOME/jre/lib:\$CLASSPATH" >> /etc/profile
echo "export PATH=\$JAVA_HOME/bin:\$JAVA_HOME/jre/bin:\$PATH" >> /etc/profile

# Scala Configuration
cd /usr/local
tar -zxf /vagrant/cache/scala-2.11.8.tgz -C /usr/local
mv ./scala-2.11.8 ./scala
echo "export SCALA_HOME=/usr/local/scala" >> /etc/profile
source /etc/profile
echo "export PATH=\$SCALA_HOME/bin:\$PATH" >> /etc/profile

# Hadoop configuration
cd /usr/local
tar -zxf /vagrant/cache/hadoop-2.9.0.tar.gz -C /usr/local
mv ./hadoop-2.9.0 ./hadoop
echo "export HADOOP_HOME=/usr/local/hadoop" >> /etc/profile
source /etc/profile
echo "export PATH=\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin:\$JAVA_HOME/bin:\$PATH" >> /etc/profile
source /etc/profile

# hadoop slaves  -- should not be in Slaves machines, but no big deals
echo "slave1" > /usr/local/hadoop/etc/hadoop/slaves
echo "slave2" >> /usr/local/hadoop/etc/hadoop/slaves

cd /usr/local/hadoop
mkdir ./dfs
mkdir ./dfs/name ./dfs/data 
mkdir ./tmp

# User Interfaces -- Ports can be found in those files
cp /vagrant/cache/core-site.xml /usr/local/hadoop/etc/hadoop/core-site.xml
cp /vagrant/cache/hdfs-site.xml /usr/local/hadoop/etc/hadoop/hdfs-site.xml
cp /vagrant/cache/mapred-site.xml /usr/local/hadoop/etc/hadoop/mapred-site.xml
cp /vagrant/cache/yarn-site.xml /usr/local/hadoop/etc/hadoop/yarn-site.xml

# Hosts name Setup
sudo cp /vagrant/cache/hosts /etc/hosts

# make sure user 'vagrant' has the privilege
sudo chown vagrant:vagrant -R /usr/local/hadoop
sudo chown vagrant:vagrant -R /usr/local/java
sudo chown vagrant:vagrant -R /usr/local/scala
# sudo chown vagrant:vagrant -R /usr/local/spark

# we put 7 export commands in /etc/profile according to the instructions
# However they should also be put in hadoop-env.sh 
tail -7 /etc/profile >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh

