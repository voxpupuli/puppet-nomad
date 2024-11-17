# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'nomad class' do
  context 'server with nomad_key_value declarations' do
    # failing on purpose on missing directories
    pp = <<-MANIFEST
      class { 'nomad':
        config_hash => {
        datacenter => 'ptk',
        data_dir   => "/var/lib/nomad",
        extra_options => '-dev',
        server     => {
            enabled          => false,
            bootstrap_expect => 1,
          }
        },
        'acl' => {
          'enabled' => false
        },
        'client' => {
          'enabled' => false,
        }
      }
      nomad_key_value { 'test/foo':
        require => Class['nomad'],
        value   => {
          'key1' => 'value1',
          'key2' => 'value2',
        },
      }
      nomad_key_value { 'test/bar':
        ensure  => absent;
        require => Class['nomad'],
        value   => {
          'key1' => 'value10',
        },
      }
    MANIFEST

    # Run it twice and test for idempotency
    apply_manifest(pp, expect_failures: true)
    apply_manifest(pp, catch_changes: true)

    describe file('/etc/nomad.d/config.json') do
      it { is_expected.to be_file }
    end
  end
end
