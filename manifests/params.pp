# == Class nomad::params
#
# This class is meant to be called from nomad
# It sets variables according to platform
#
class nomad::params {
  $install_method        = 'url'
  $package_name          = 'nomad'
  $package_ensure        = 'installed'
  $download_url_base     = 'https://releases.hashicorp.com/nomad/'
  $download_extension    = 'zip'
  $version               = '1.0.1'
  $config_mode           = '0660'

  case $facts['os']['architecture'] {
    'x86_64', 'amd64': { $arch = 'amd64' }
    'i386':            { $arch = '386' }
    'armv7l':          { $arch = 'arm' }
    default:           {
      fail("Unsupported kernel architecture: ${facts['os']['architecture']}")
    }
  }

  $os = downcase($facts['kernel'])

  if $facts['os']['name'] == 'Ubuntu' {
    if versioncmp($facts['os']['release']['full'], '8.04') < 1 {
      $init_style = 'debian'
    } elsif versioncmp($facts['os']['release']['full'], '15.04') < 0 {
      $init_style = 'upstart'
    } else {
      $init_style = 'systemd'
    }
  } elsif $facts['os']['name'] =~ /Scientific|CentOS|RedHat|OracleLinux/ {
    if versioncmp($facts['os']['release']['full'], '7.0') < 0 {
      $init_style = 'sysv'
    } else {
      $init_style  = 'systemd'
    }
  } elsif $facts['os']['name'] == 'Fedora' {
    if versioncmp($facts['os']['release']['full'], '12') < 0 {
      $init_style = 'sysv'
    } else {
      $init_style = 'systemd'
    }
  } elsif $facts['os']['name'] == 'Debian' {
    if versioncmp($facts['os']['release']['full'], '8.0') < 0 {
      $init_style = 'debian'
    } else {
      $init_style = 'systemd'
    }
  } elsif $facts['os']['name'] == 'Archlinux' {
    $init_style = 'systemd'
  } elsif $facts['os']['name'] == 'OpenSuSE' {
    $init_style = 'systemd'
  } elsif $facts['os']['name'] =~ /SLE[SD]/ {
    if versioncmp($facts['os']['release']['full'], '12.0') < 0 {
      $init_style = 'sles'
    } else {
      $init_style = 'systemd'
    }
  } elsif $facts['os']['name'] == 'Darwin' {
    $init_style = 'launchd'
  } elsif $facts['os']['name'] == 'Amazon' {
    $init_style = 'sysv'
  } else {
    $init_style = undef
  }
  if $init_style == undef {
    fail('Unsupported OS')
  }
}
