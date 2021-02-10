require 'spec_helper_acceptance'

describe 'nomad class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors based on the example' do
      pp = <<-EOS
        class { 'nomad':
          install_method => 'url',
          version        => '1.0.3',
          config_hash    => {
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
      it { should be_directory }
    end

    describe file('/opt/puppet-archive/nomad-1.0.3') do
      it { should be_directory }
    end

    describe file('/opt/puppet-archive/nomad-1.0.3/nomad') do
      it { should be_file }
    end

    case os[:family]
    when 'Debian'
      describe file('/usr/bin/nomad') do
        it { should be_symlink }
        it { should be_linked_to '/opt/puppet-archive/nomad-1.0.3/nomad' }
      end
    when 'RedHat'
      describe file('/usr/bin/nomad') do
        it { should be_symlink }
        it { should be_linked_to '/opt/puppet-archive/nomad-1.0.3/nomad' }
      end
    end

    describe service('nomad') do
      it { should be_enabled }
    end

    describe command('nomad version') do
      its(:stdout) { should match(/Nomad v1\.0\.3/) }
    end

  end
end
