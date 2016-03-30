# == Class nomad::service
#
# This class is meant to be called from nomad
# It ensure the service is running
#
class nomad::run_service {

  $init_selector = $nomad::init_style ? {
    'launchd' => 'io.nomad.daemon',
    default   => 'nomad',
  }

  if $nomad::manage_service == true {
    service { 'nomad':
      ensure   => $nomad::service_ensure,
      name     => $init_selector,
      enable   => $nomad::service_enable,
      provider => $nomad::init_style,
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
