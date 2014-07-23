#platform=x86, AMD64, or Intel EM64T
# System authorization information
auth  --useshadow  --enablemd5
# System bootloader configuration
bootloader --location=mbr
unsupported_hardware
# Partition clearing information
clearpart --all --initlabel
# Use text mode install
text
# Firewall configuration
firewall --enabled
# Run the Setup Agent on first boot
firstboot --disable
# System keyboard
keyboard us
# System language
lang en_US
# Use network installation
url --url=$tree
# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
$yum_repo_stanza
# Network information
$SNIPPET('network_config')
# Reboot after installation
reboot

#Root password
rootpw --iscrypted $default_password_crypted
# SELinux configuration
selinux --disabled
# Do not configure the X Window System
skipx
# System timezone
timezone --utc Asia/Shanghai
# Install OS instead of upgrade
install
# Clear the Master Boot Record
zerombr
# Allow anaconda to partition the system as needed
#autopart
%include /tmp/partition.ks


%pre
$SNIPPET('log_ks_pre')
$SNIPPET('kickstart_start')
$SNIPPET('pre_install_network_config')
# Enable installation monitoring
$SNIPPET('pre_anamon')

#!/bin/sh
act_mem=`cat /proc/meminfo | grep MemTotal | awk '{printf("%d",$2/1024)}'`
echo "" > /tmp/partition.ks
echo "clearpart --all --initlabel" >> /tmp/partition.ks
echo "part /boot --fstype=ext4 --asprimary --size=500" >> /tmp/partition.ks
echo "part swap --fstype=swap --size=${act_mem}" >> /tmp/partition.ks
echo "part / --fstype=ext4 --grow --size=1" >> /tmp/partition.ks

%packages
$SNIPPET('func_install_if_enabled')
git
wget
vim
dstat
gcc
gcc-c++
libffi-devel
python-devel
openssl-devel
make
libtool
mysql
patch
automake
libxslt-devel
MySQL-python

%post
echo "$http_server $puppet_server" >> /etc/hosts
$SNIPPET('log_ks_post')
# Start yum configuration 
$yum_config_stanza
### Repo Setup ###
mkdir /etc/yum.repos.d/CentOS-Repos
mv /etc/yum.repos.d/CentOS* /etc/yum.repos.d/CentOS-Repos 
cat >> /etc/yum.repos.d/cobbler-config.repo << _Longgeek_
[core-1]
name=core-1
baseurl=http://$http_server/cobbler/repo_mirror/rpm-requirements
gpgcheck=0
priority=1
_Longgeek_

yum -y install yum-plugin-priorities python-pip puppet
sed -i "s/enabled = 1/enabled = 0/"  /etc/yum/pluginconf.d/priorities.conf
sed -i "s/\[main\]/\[main\]\n    server = $puppet_server/g" /etc/puppet/puppet.conf
echo '    runinterval = 60' >> /etc/puppet/puppet.conf
/etc/init.d/puppet start
chkconfig puppet on

# End yum configuration
$SNIPPET('post_install_kernel_options')
$SNIPPET('post_install_network_config')
$SNIPPET('func_register_if_enabled')
$SNIPPET('puppet_install_if_enabled')
$SNIPPET('puppet_register_if_enabled')
$SNIPPET('download_config_files')
$SNIPPET('koan_environment')
$SNIPPET('redhat_register')
$SNIPPET('cobbler_register')
# Enable post-install boot notification
$SNIPPET('post_anamon')
# Start final steps
$SNIPPET('kickstart_done')
# End final steps


### clean root directory ###
rm -f /root/{*.cfg,*log,*ks}

### Sync Time ###
chkconfig ntpd on
ntpdate $http_server
sed -i "s/0\.centos\.pool\.ntp\.org/$http_server/" /etc/ntp.conf

### PIP Config ###
mkdir /root/.pip
cat > /root/.pip/pip.conf << _Longgeek_
[global]
find-links = http://$http_server/cobbler/repo_mirror/pip-requirements
no-index = true
_Longgeek_

cat > /root/.pydistutils.cfg << _Longgeek_
[easy_install]
index-url = http://$http_server/cobbler/repo_mirror/pip-requirements
_Longgeek_

pip install pbr six cffi

### SSH Config ###
echo 'StrictHostKeyChecking  no' >> etc/ssh/ssh_config

chkconfig kdump off
