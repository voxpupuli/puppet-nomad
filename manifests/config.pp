# This class is called from nomad::init to install the config file.
#
class nomad::config {
  if $nomad::init_style {
    case $nomad::init_style {
      'systemd' : {
        systemd::unit_file { 'nomad.service':
          content => template('nomad/nomad.systemd.erb'),
        }
        # cleaning up legacy service file created before PR #13
        file { '/lib/systemd/system/nomad.service':
          ensure => absent,
        }
      }
      'launchd' : {
        file { '/Library/LaunchDaemons/io.nomad.daemon.plist':
          mode    => '0644',
          owner   => 'root',
          group   => 'wheel',
          content => template('nomad/nomad.launchd.erb'),
        }
      }
      default : {
        fail("I don't know how to create an init script for style ${nomad::init_style}")
      }
    }
  }

  file { $nomad::config_dir:
    ensure  => 'directory',
    owner   => $nomad::user,
    group   => $nomad::group,
    purge   => $nomad::purge_config_dir,
    recurse => $nomad::purge_config_dir,
  }
  -> file { 'nomad config.json':
    ensure  => file,
    path    => "${nomad::config_dir}/config.json",
    owner   => $nomad::user,
    group   => $nomad::group,
    mode    => $nomad::config_mode,
    content => nomad::sorted_json($nomad::config_hash_real, $nomad::pretty_config, $nomad::pretty_config_indent),
  }
}
