# This class is called from nomad::init to install the config file.
#
# @api private
class nomad::config {
  systemd::unit_file { 'nomad.service':
    content => template('nomad/nomad.systemd.erb'),
  }
  # cleaning up legacy service file created before PR #13
  file { '/lib/systemd/system/nomad.service':
    ensure => absent,
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
    content => nomad::sorted_json($nomad::config_hash_real, $nomad::pretty_config, $nomad::pretty_config_indent),
  }
}
