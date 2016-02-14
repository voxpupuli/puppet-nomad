# == Define nomad::service
#
# Sets up a Consul service definition
# http://www.nomad.io/docs/agent/services.html
#
# == Parameters
#
# [*ensure*]
#   Define availability of service. Use 'absent' to remove existing services.
#   Defaults to 'present'
#
# [*service_name*]
#   Name of the service. Defaults to title.
#
# [*id*]
#   The unique ID of the service on the node. Defaults to title.
#
# [*tags*]
#   Array of strings.
#
# [*address*]
#   IP address the service is running at.
#
# [*port*]
#   TCP port the service runs on.
#
# [*checks*]
#   If provided an array of checks that will be added to this service
#
# [*token*]
#   ACL token for interacting with the catalog (must be 'management' type)
#
define nomad::service(
  $ensure         = present,
  $service_name   = $title,
  $id             = $title,
  $tags           = [],
  $address        = undef,
  $port           = undef,
  $checks         = [],
  $token          = undef,
) {
  include nomad

  nomad_validate_checks($checks)

  $basic_hash = {
    'id'      => $id,
    'name'    => $service_name,
    'address' => $address,
    'port'    => $port,
    'tags'    => $tags,
    'checks'  => $checks,
    'token'   => $token,
  }

  $service_hash = {
    service => delete_undef_values($basic_hash)
  }

  $escaped_id = regsubst($id,'\/','_','G')
  file { "${nomad::config_dir}/service_${escaped_id}.json":
    ensure  => $ensure,
    owner   => $nomad::user,
    group   => $nomad::group,
    mode    => $nomad::config_mode,
    content => nomad_sorted_json($service_hash, $nomad::pretty_config, $nomad::pretty_config_indent),
    require => File[$nomad::config_dir],
  } ~> Class['nomad::reload_service']
}
