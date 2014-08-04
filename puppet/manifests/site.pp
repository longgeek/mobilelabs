#node 'control1' {
#    Class['bases'] -> Class['mysql'] -> Class['rabbitmq'] -> Class['keystone'] -> Class['glance'] -> Class['nova-control'] -> Class['horizon'] -> Class['neutron-control']
#    include bases, mysql, rabbitmq, keystone, glance, nova-control, horizon, neutron-control
#}
#
#node 'network1' {
#    include bases, neutron-network
#}
#
#node 'compute1' {
#    include bases, nova-compute, neutron-compute
#}

$command_path                       = '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/bin/bash'
$sources_dir                        = '/thstack'
$root_password                      = 'thstack.com'


$mysql_host                         = '192.168.3.40'
$mysql_root_pass                    = 'thstack.com'
$rabbit_host                        = '192.168.3.40'
$rabbit_password                    = 'thstack.com'

$keystone_host                      = '192.168.3.40'
$keystone_db_name                   = 'keystone'
$keystone_db_user                   = 'keystone'
$keystone_db_password               = 'keystone'
$memcache_host                      = '192.168.3.40'

$os_tenant_name                     = 'admin'
$os_username                        = 'admin'
$os_password                        = 'password'
$os_auth_url                        = "http://$keystone_host:5000/v2.0/"
$os_region_name                     = 'RegionOne'
$service_token                      = 'ADMIN'
$service_tenant_name                = 'service'
$service_endpoint                   = "http://$keystone_host:35357/v2.0/"
$admin_user                         = 'admin'
$admin_password                     = 'password'
$admin_tenant_name                  = 'admin'
$service_password                   = 'password'

$glance_host                        = '192.168.3.40'
$glance_user                        = 'glance'
$glance_password                    = 'password'
$glance_db_name                     = 'glance'
$glance_db_user                     = 'glance'
$glance_db_password                 = 'glance'
$glance_api_workers                 = '1'

$nova_db_name                       = 'nova'
$nova_db_user                       = 'nova'
$nova_db_password                   = 'nova'
$nova_user                          = 'nova'
$nova_password                      = 'password'
$nova_host                          = '192.168.3.40'
$nova_novncproxy_host               = '192.168.3.40'
$nova_compute_host                  = '192.168.3.42'
$nova_compute_workers               = '1'
$nova_metadata_workers              = '1'
$nova_conductor_workers             = '1'

$neutron_host                       = '192.168.3.40'
$neutron_db_name                    = 'neutron'
$neutron_db_user                    = 'neutron'
$neutron_db_password                = 'neutron'
$neutron_user                       = 'neutron'
$neutron_password                   = 'password'
$neutron_api_workers                = '1'
$br_ex                              = 'eth0'
$br_int                             = 'eth1'
$network_vlan_ranges                = '1:100'
