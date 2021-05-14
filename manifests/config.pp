# This class is called from nomad::init to install the config file.
#
# @api private
class nomad::config {
  if $nomad::manage_service_file {
    systemd::unit_file { 'nomad.service':
      content => template('nomad/nomad.systemd.erb'),
    }
  }

  $_config = $nomad::pretty_config ? {
    true    => to_json_pretty($nomad::config_hash_real),
    default => to_json($nomad::config_hash_real),
  }

  file { $nomad::config_dir:
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    purge   => $nomad::purge_config_dir,
    recurse => $nomad::purge_config_dir,
  }
  -> file { 'nomad config.json':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    path    => "${nomad::config_dir}/config.json",
    mode    => $nomad::config_mode,
    content => $_config,
  }
  $content = join(map($nomad::env_vars) |$key, $value| { "${key}=${value}" }, "\n")
  file { "${nomad::config_dir}/nomad.env":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => $nomad::config_mode,
    content => "${content}\n",
    require => File[$nomad::config_dir],
  }
}
