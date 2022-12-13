# This class is called from nomad::init to install the config file.
#
# @api private
class nomad::install {
  if $nomad::data_dir {
    file { $nomad::data_dir:
      ensure => 'directory',
      owner  => $nomad::user,
      group  => $nomad::group,
      mode   => $nomad::data_dir_mode,
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
      if $nomad::manage_repo {
        include hashi_stack::repo
        Class['hashi_stack::repo'] -> Package[$nomad::package_name]
      }
      package { $nomad::package_name:
        ensure => $nomad::version,
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
}
