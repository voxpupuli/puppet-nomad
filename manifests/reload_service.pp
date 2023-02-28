# This class is meant to be called from certain
# configuration changes that support reload.
#
# @see https://developer.hashicorp.com/nomad/docs/configuration#configuration-reload
#
# @api private
class nomad::reload_service {
  # Don't attempt to reload if we're not supposed to be running.
  # This can happen during pre-provisioning of a node.
  if $nomad::manage_service == true and $nomad::service_ensure == 'running' {
    exec { 'reload nomad service':
      path        => ['/bin', '/usr/bin'],
      command     => 'systemctl reload nomad',
      refreshonly => true,
    }
  }
}
