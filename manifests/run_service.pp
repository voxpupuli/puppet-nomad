# This class is meant to be called from nomad
# It ensure the service is running
#
# @api private
class nomad::run_service {
  if $nomad::manage_service == true {
    service { 'nomad':
      ensure => $nomad::service_ensure,
      enable => $nomad::service_enable,
    }
  }

  if $nomad::join_wan {
    exec { 'join nomad wan':
      cwd       => $nomad::config_dir,
      path      => [$nomad::bin_dir,'/bin','/usr/bin'],
      command   => "nomad join -wan ${nomad::join_wan}",
      unless    => "nomad members -wan -detailed | grep -vP \"dc=${nomad::config_hash_real['datacenter']}\" | grep -P 'alive'",
      subscribe => Service['nomad'],
    }
  }
}
