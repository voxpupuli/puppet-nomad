# frozen_string_literal: true

require 'puppet/parameter/boolean'
require 'facter'

Puppet::Type.newtype(:nomad_key_value) do
  desc <<-EOD
  Manage Nomad key value objects.
  @example handling keys in the key value store
      nomad_key_value {
        default:
          ensure          => present,
          address         => 'https://127.0.0.1:4646',
          token           => $nomad_token.unwrap,
          tls_server_name => 'nomad.example.org',
          ca_cert         => '/etc/ssl/certs/COMODO_OV.crt',
          require         => Class['nomad'];
        'test/keys':
          value  => {
            'key1' => 'value1',
            'key2' => 'value2',
          };
        'test_again/keys':
          ensure => absent,
          value  => {
            'key1' => 'value13',
            'key2' => 'value21',
          };
      }
  EOD
  ensurable

  newparam(:name, namevar: true) do
    desc 'Name of the path object containing the key/value pairs'
    validate do |value|
      raise ArgumentError, 'Path object name must be a string' unless value.is_a?(String)
    end
  end

  newproperty(:value) do
    desc 'The key-value pairs to set'
    validate do |value|
      raise ArgumentError, 'The key value must be a hash' unless value.is_a?(Hash)
    end
  end

  newparam(:binary_path) do
    desc 'Path to the nomad binary. Can be an absolute path or just "nomad" if it is in the PATH.'
    validate do |value|
      raise ArgumentError, "The binary '#{value}' could not be found." if Facter::Core::Execution.which(value).nil?
    end
    defaultto do
      Facter::Core::Execution.which('nomad')
    end
  end

  newparam(:address) do
    desc 'Nomad URL, with scheme and port number. It defaults to http://127.0.0.1:4646'
    validate do |value|
      raise ArgumentError, 'The url must be a string' unless value.is_a?(String)
    end
    defaultto 'http://127.0.0.1:4646'
  end

  newparam(:token) do
    desc 'Nomad token with read and write access to the variables'
    validate do |value|
      raise ArgumentError, 'Nomad token must be a string' unless value.is_a?(String)
    end
    defaultto ''
  end

  newparam(:region) do
    desc 'Name of the region. It defaults to global'
    validate do |value|
      raise ArgumentError, 'The region must be an string' unless value.is_a?(String)
    end
    defaultto 'global'
  end

  newparam(:namespace) do
    desc 'The namespace to query. If unspecified, it will use the default namespace.'
    validate do |value|
      raise ArgumentError, 'The namespace must be an string' unless value.is_a?(String)
    end
    defaultto ''
  end

  newparam(:tls_server_name) do
    desc 'The server name to use as the SNI host when connecting via TLS.'
    validate do |value|
      raise ArgumentError, 'The server name must be a string' unless value.is_a?(String)
    end
    defaultto ''
  end

  newparam(:skip_verify, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc 'Skip Nomad certificate verification. Defaults to false.'
    defaultto false
  end

  newparam(:client_key) do
    desc 'Path to the client private key file to use to authenticate to the Nomad server.'
    validate do |value|
      raise ArgumentError, 'The client key must be a string' unless value.is_a?(String)
    end
    defaultto ''
  end

  newparam(:client_cert) do
    desc 'Path to the client certificate file to use to authenticate to the Nomad server.'
    validate do |value|
      raise ArgumentError, 'The client certificate must be a string' unless value.is_a?(String)
    end
    defaultto ''
  end

  newparam(:ca_cert) do
    desc 'Path to a PEM-encoded CA certificate file to use to verify the Nomad server SSL certificate.'
    validate do |value|
      raise ArgumentError, 'The CA certificate must be a string' unless value.is_a?(String)
    end
    defaultto ''
  end

  newparam(:ca_path) do
    desc 'Path to a directory of PEM-encoded CA certificate files to verify the Nomad server SSL certificate.'
    validate do |value|
      raise ArgumentError, 'The CA path must be a string' unless value.is_a?(String)
    end
    defaultto ''
  end

  validate do
    raise ArgumentError, "You cannot specify both 'ca_cert' and 'ca_path'. Please provide only one." if !self[:ca_cert].empty? && !self[:ca_path].empty?
  end
end
