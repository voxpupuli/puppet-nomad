require 'spec_helper_acceptance'

describe 'nomad class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors based on the example' do
      pp = <<-EOS
        class { 'nomad':
          version     => '0.5.2',
          config_hash => {
              'datacenter' => 'east-aws',
              'data_dir'   => '/opt/nomad',
              'log_level'  => 'INFO',
              'node_name'  => 'foobar',
              'server'     => true
          }
        }
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe file('/opt/nomad') do
      it { should be_directory }
    end

    describe service('nomad') do
      it { should be_enabled }
    end

    describe command('nomad version') do
      its(:stdout) { should match /Consul v0\.5\.2/ }
    end

  end
end
