require 'puppet/parameter/boolean'

Puppet::Type.newtype(:nomad_key_value) do
  desc <<-EOD
  Manage Nomad key value objects.
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
    desc 'Path to the nomad binary'
    validate do |value|
      raise ArgumentError, "The binary path must be an absolute path to nomad, or the string nomad if it's included in PATH" unless value.is_a?(String)
    end
    defaultto 'nomad'
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
    if !self[:ca_cert].empty? && !self[:ca_path].empty?
      raise ArgumentError, "You cannot specify both 'ca_cert' and 'ca_path'. Please provide only one."
    end
  end
end
