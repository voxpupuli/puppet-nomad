# == Class nomad::config
#
# This class is called from nomad::init to install the config file.
#
# == Parameters
#
# [*config_hash*]
#   Hash for nomad to be deployed as JSON
#
# [*purge*]
#   Bool. If set will make puppet remove stale config files.
#
class nomad::config(
  $config_hash,
  $purge = true,
) {

  if $nomad::init_style {

    case $nomad::init_style {
      'upstart' : {
        file { '/etc/init/nomad.conf':
          mode    => '0444',
          owner   => 'root',
          group   => 'root',
          content => template('nomad/nomad.upstart.erb'),
        }
        file { '/etc/init.d/nomad':
          ensure => link,
          target => '/lib/init/upstart-job',
          owner  => 'root',
          group  => 'root',
          mode   => '0755',
        }
      }
      'systemd' : {
        file { '/lib/systemd/system/nomad.service':
          mode    => '0644',
          owner   => 'root',
          group   => 'root',
          content => template('nomad/nomad.systemd.erb'),
        }~>
        exec { 'nomad-systemd-reload':
          command     => 'systemctl daemon-reload',
          path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
          refreshonly => true,
        }
      }
      'sysv' : {
        file { '/etc/init.d/nomad':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('nomad/nomad.sysv.erb')
        }
      }
      'debian' : {
        file { '/etc/init.d/nomad':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('nomad/nomad.debian.erb')
        }
      }
      'sles' : {
        file { '/etc/init.d/nomad':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('nomad/nomad.sles.erb')
        }
      }
      'launchd' : {
        file { '/Library/LaunchDaemons/io.nomad.daemon.plist':
          mode    => '0644',
          owner   => 'root',
          group   => 'wheel',
          content => template('nomad/nomad.launchd.erb')
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
    purge   => $purge,
    recurse => $purge,
  } ->
  file { 'nomad config.json':
    ensure  => present,
    path    => "${nomad::config_dir}/config.json",
    owner   => $nomad::user,
    group   => $nomad::group,
    mode    => $nomad::config_mode,
    content => nomad_sorted_json($config_hash, $nomad::pretty_config, $nomad::pretty_config_indent),
  }

}
