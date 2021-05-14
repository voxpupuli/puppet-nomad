require 'spec_helper_acceptance'

describe 'nomad class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'works with no errors based on the example' do
      pp = <<-EOS
        class { 'nomad':
          config_hash => {
            region     => 'us-west',
            datacenter => 'ptk',
            log_level  => 'INFO',
            bind_addr  => "0.0.0.0",
            data_dir   => "/var/lib/nomad",
            server     => {
              enabled          => true,
              bootstrap_expect => 1
            }
          }
        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/var/lib/nomad') do
      it { is_expected.to be_directory }
    end

    describe service('nomad') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
