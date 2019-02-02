#!/bin/bash

apt-get update
wget https://pm.puppet.com/pe-client-tools/2019.0.1/19.0.1/repos/deb/bionic/PC1/pe-client-tools_19.0.1-1bionic_amd64.deb -O pe-client-tools.deb
dpkg -i pe-client-tools.deb
echo "export PATH=$PATH:/opt/puppetlabs/bin" >> /home/vagrant/.profile

pip install --user awscli

wget https://releases.hashicorp.com/packer/1.3.4/packer_1.3.4_linux_amd64.zip -O packer.zip
unzip packer.zip
mv packer /usr/local/bin/

wget https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip -O terraform.zip
unzip terraform.zip
mv terraform /usr/local/bin/

cd /home/vagrant
chown vagrant:vagrant ~/.ssh/id_rsa
chown vagrant:vagrant ~/.ssh/id_rsa.pub
chmod 400 ~/.ssh/id_rsa
ssh-keyscan -H gitlab.com >> ~/.ssh/known_hosts
ssh -T git@gitlab.com
git clone git@gitlab.com:spitfyre/packer
git clone git@gitlab.com:spitfyre/pinhead
git clone git@gitlab.com:spitfyre/puppet-master
git clone git@gitlab.com:spitfyre/infected-machine