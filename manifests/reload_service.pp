# == Class nomad::reload_service
#
# This class is meant to be called from certain
# configuration changes that support reload.
#
# https://www.nomad.io/docs/agent/options.html#reloadable-configuration
#
class nomad::reload_service {
  # Don't attempt to reload if we're not supposed to be running.
  # This can happen during pre-provisioning of a node.
  if $nomad::manage_service == true and $nomad::service_ensure == 'running' {
    # Make sure we don't try to connect to 0.0.0.0, use 127.0.0.1 instead
    # This can happen if the nomad agent RPC port is bound to 0.0.0.0
    if $nomad::rpc_addr == '0.0.0.0' {
      $rpc_addr = '127.0.0.1'
    } else {
      $rpc_addr = $nomad::rpc_addr
    }

    exec { 'reload nomad service':
      path        => [$nomad::bin_dir,'/bin','/usr/bin'],
      command     => "nomad reload -rpc-addr=${rpc_addr}:${nomad::rpc_port}",
      refreshonly => true,
    }
  }
}
