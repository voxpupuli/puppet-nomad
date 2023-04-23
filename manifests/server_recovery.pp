# This class is used to generate a peers.json and a recovery script file for Nomad servers.
# It is used to recover from a Nomad server outage.
#
# @example using PuppetDB
#  class { 'nomad':
#    config_hash                 => {
#      'region'     => 'us-west',
#      'datacenter' => 'ptk',
#      'bind_addr'  => '0.0.0.0',
#      'data_dir'   => '/opt/nomad',
#      'server'     => {
#        'enabled'          => true,
#        'bootstrap_expect' => 3,
#      },
#    },
#    server_recovery             => true,
#    recovery_nomad_server_regex => 'nomad-server0',
#    recovery_network_interface  => 'eth0',
#  }
#
# @param nomad_server_regex
#  Regex to match Nomad server hostnames within the same puppet environment. It's mutually exclusive with nomad_server_hash.
# @param nomad_server_hash
#  If you don't have the PuppetDB you can supply a Hash with server IPs and corresponding node-ids. It's mutually exclusive with nomad_server_regex.
# @param network_interface
#  NIC where Nomad server IP is configured
# @param rpc_port
#  Nomad server RPC port
#
class nomad::server_recovery (
  Optional[String] $network_interface  = undef,
  Optional[String] $nomad_server_regex = undef,
  Optional[Hash] $nomad_server_hash    = undef,
  Stdlib::Port $rpc_port               = 4647,
) {
  if ($facts['nomad_node_id']) {
    if ($nomad_server_regex) {
      $nomad_server_inventory = puppetdb_query(
        "inventory[facts.networking.hostname, facts.networking.interfaces.${network_interface}.ip, facts.nomad_node_id] {
          facts.networking.hostname ~ '${nomad_server_regex}' and facts.agent_specified_environment = '${facts['agent_specified_environment']}'
        }"
      )
      $nomad_server_pretty_inventory = $nomad_server_inventory.map |$item| {
        {
          'id' => $item['facts.nomad_node_id'],
          'address' => "${item["facts.networking.interfaces.${network_interface}.ip"]}:${rpc_port}",
          'non_voter' => false
        }
      }
    } else {
      if $nomad_server_hash.keys() !~ Array[Stdlib::IP::Address::Nosubnet] {
        fail('The keys of the nomad_server_hash parameter must be valid IP addresses')
      }
      $nomad_server_pretty_inventory = $nomad_server_hash.map |$key, $value| {
        {
          'id' => $value,
          'address' => "${key}:${rpc_port}",
          'non_voter' => false
        }
      }
    }

    file {
      default:
        owner => 'root',
        group => 'root';
      '/tmp/peers.json':
        mode    => '0640',
        content => to_json_pretty($nomad_server_pretty_inventory);
      '/usr/local/bin/nomad-server-outage-recovery.sh':
        mode   => '0750',
        source => 'puppet:///modules/nomad/nomad-server-outage-recovery.sh';
    }
  }
}
