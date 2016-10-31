#
# Builds a Mesos node on Ubuntu14.04
#

sudo apt-get update
sudo apt-get install -y tar python-dev wget


cd

wget http://www.apache.org/dist/mesos/0.28.2/mesos-0.28.2.tar.gz
tar xzf mesos-0.28.2.tar.gz

sudo apt-get install -y openjdk-7-jdk
sudo apt-get -y install build-essential python-dev libcurl4-nss-dev libsasl2-dev libsasl2-modules maven libapr1-dev libsvn-dev

cd mesos-0.28.2
mkdir build
cd  build
../configure
make

# Docker

sudo apt-get install -y apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get install -y docker-engine

