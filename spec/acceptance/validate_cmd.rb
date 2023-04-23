# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'nomad class' do
  context 'agent host_volume fails with non-existent path' do
    pp = <<-MANIFEST
      class { 'nomad':
        config_hash => {
        region     => 'us-west',
        datacenter => 'ptk',
        log_level  => 'INFO',
        bind_addr  => "0.0.0.0",
        data_dir   => "/var/lib/nomad",
        server     => {
            enabled => false,
          }
        },
        'client' => {
          'enabled' => true,
          'host_volume' => [
            {
              'test_application' => {
                'path' => '/data/dir1',
              },
            }
          ],
        },
      }
    MANIFEST

    apply_manifest(pp, expect_failures: true)
  end

  context 'agent host_volume fails with missing key path' do
    pp = <<-MANIFEST
      class { 'nomad':
        config_hash => {
        region     => 'us-west',
        datacenter => 'ptk',
        log_level  => 'INFO',
        bind_addr  => "0.0.0.0",
        data_dir   => "/var/lib/nomad",
        server     => {
            enabled => false,
          }
        },
        'client' => {
          'enabled' => true,
          'host_volume' => [
            {
              'test_application' => {
                'read_only' => true,
              },
            }
          ],
        },
      }
    MANIFEST

    apply_manifest(pp, expect_failures: true)
  end

  context 'agent_host_volume_succeed' do
    pp = <<-MANIFEST
      file { ['/data', '/data/dir1']:
      ensure => directory;
      }
      -> class { 'nomad':
        config_hash => {
        region     => 'us-west',
        datacenter => 'ptk',
        log_level  => 'INFO',
        bind_addr  => "0.0.0.0",
        data_dir   => "/var/lib/nomad",
        server     => {
            enabled => false,
          }
        },
        'client' => {
          'enabled' => true,
          'host_volume' => [
            {
              'test_application' => {
                'path' => '/data/dir1',
              },
            }
          ],
        },
      }
    MANIFEST

    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)

    describe file('/data/dir') do
      it { is_expected.to be_directory }
      it { is_expected.to contain '"host_volume": [' }
      it { is_expected.to contain '"path": "/data/dir1"' }
    end
  end
end
