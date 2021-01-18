require 'spec_helper_acceptance'

describe 'nomad class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors based on the example' do
      pp = <<-EOS
        class { 'nomad':
          config_hash => {
            "region"     => 'us-west',
            "datacenter" => 'ptk',
            "log_level"  => 'INFO',
            "bind_addr"  => "0.0.0.0",
            "data_dir"   => "/var/lib/nomad",
            "server" => {
              "enabled"          => true,
              "bootstrap_expect" => 1
            }
          }
        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/var/lib/nomad') do
      it { should be_directory }
    end

    describe file('/opt/puppet-archive/nomad-1.0.2') do
      it { should be_directory }
    end

    describe file('/opt/puppet-archive/nomad-1.0.2/nomad') do
      it { should be_file }
    end

    describe file('/usr/local/bin/nomad') do
      it { should be_symlink }
      it { should be_linked_to '/opt/puppet-archive/nomad-1.0.2/nomad' }
    end

    describe service('nomad') do
      it { should be_enabled }
    end

    describe command('nomad version') do
      its(:stdout) { should match(/Nomad v1\.0\.2/) }
    end

  end
end
