# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'nomad class' do
  context 'server_recovery' do
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
        },
        server_recovery => true,
        recovery_nomad_server_hash => {
          '192.168.1.10' => 'a1b2c3d4-1234-5678-9012-3456789abcde',
          '192.168.1.11' => 'b2c3d4a1-5678-9012-1234-56789abcde12',
        },
      }
    EOS

    fact_notices = <<-EOS
      notify{"nomad_node_id: ${facts['nomad_node_id']}":}
      notify{"nomad_version: ${facts['nomad_version']}":}
    EOS

    it 'outputs nomad facts when not installed' do
      apply_manifest(fact_notices, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{nomad_node_id: \S+})
        expect(r.stdout).to match(%r{nomad_version: \S+})
      end
    end

    it 'sets up nomad' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file('/tmp/peers.json') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'a1b2c3d4-1234-5678-9012-3456789abcde' }
      it { is_expected.to contain '192.168.1.10' }
      it { is_expected.to contain 'b2c3d4a1-5678-9012-1234-56789abcde12' }
      it { is_expected.to contain '192.168.1.11' }
    end

    it 'outputs nomad facts when installed' do
      apply_manifest(fact_notices, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{nomad_node_id: [0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}})
        expect(r.stdout).to match(%r{nomad_version: \S+})
      end
    end
  end
end
