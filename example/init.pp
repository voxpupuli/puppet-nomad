# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#
class { 'nomad':
  config_hash => {
    'region'     => 'us-west',
    'datacenter' => 'ptk',
    'log_level'  => 'INFO',
    'bind_addr'  => '0.0.0.0',
    'data_dir'   => '/var/lib/nomad',
    'server'     => {
      'enabled'          => true,
      'bootstrap_expect' => 1,
    },
  },
}
