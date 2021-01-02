# == Class nomad::params
#
# This class is meant to be called from nomad
# It sets variables according to platform
#
class nomad::params {
  case $facts['os']['architecture'] {
    'x86_64', 'amd64': { $arch = 'amd64' }
    'i386':            { $arch = '386' }
    'armv7l':          { $arch = 'arm' }
    default:           {
      fail("Unsupported kernel architecture: ${facts['os']['architecture']}")
    }
  }

  $os = downcase($facts['kernel'])

  $init_style = $facts['service_provider']
}
