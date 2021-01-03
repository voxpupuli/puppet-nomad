# == Class nomad::install
#
# Installs nomad based on the parameters from init
#
class nomad::install {
  if $nomad::data_dir {
    file { $nomad::data_dir:
      ensure => 'directory',
      owner  => $nomad::user,
      group  => $nomad::group,
      mode   => '0755',
    }
  }

  case $nomad::install_method {
    'url': {
      $install_path = '/opt/puppet-archive'

      include 'archive'
      file { [$install_path, "${install_path}/nomad-${nomad::version}"]:
        ensure => directory,
      }
      -> archive { "${install_path}/nomad-${nomad::version}.${nomad::download_extension}":
        ensure       => present,
        source       => $nomad::real_download_url,
        extract      => true,
        extract_path => "${install_path}/nomad-${nomad::version}",
        creates      => "${install_path}/nomad-${nomad::version}/nomad",
      }
      -> file {
        "${install_path}/nomad-${nomad::version}/nomad":
          owner => 'root',
          group => 0, # 0 instead of root because OS X uses "wheel".
          mode  => '0555';
        "${nomad::bin_dir}/nomad":
          ensure => link,
          notify => $nomad::notify_service,
          target => "${install_path}/nomad-${nomad::version}/nomad";
      }
    }
    'package': {
      package { $nomad::package_name:
        ensure => $nomad::package_ensure,
      }

      if $nomad::manage_user {
        User[$nomad::user] -> Package[$nomad::package_name]
      }

      if $nomad::data_dir {
        Package[$nomad::package_name] -> File[$nomad::data_dir]
      }
    }
    'none': {}
    default: {
      fail("The provided install method ${nomad::install_method} is invalid")
    }
  }

  if $nomad::manage_user {
    user { $nomad::user:
      ensure => 'present',
      system => true,
      groups => $nomad::extra_groups,
    }

    if $nomad::manage_group {
      Group[$nomad::group] -> User[$nomad::user]
    }
  }
  if $nomad::manage_group {
    group { $nomad::group:
      ensure => 'present',
      system => true,
    }
  }
}
