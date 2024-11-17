require 'json'
require 'tempfile'

Puppet::Type.type(:nomad_key_value).provide(:cli) do
  desc 'Provider to manage Nomad variables using `nomad var put`.'

  def nomad_command
    resource[:binary_path]
  end

  def build_command_args
    raise Puppet::Error, "Nomad binary at #{resource[:binary_path]} is not executable or not found." unless File.executable?(resource[:binary_path])

    args = []
    args << "-token=#{resource[:token]}" unless resource[:token].to_s.empty?
    args << "-address=#{resource[:address]}"
    args << "-region=#{resource[:region]}"
    args << "-namespace=#{resource[:namespace]}" unless resource[:namespace].to_s.empty?
    args << "-tls-server-name=#{resource[:tls_server_name]}" unless resource[:tls_server_name].to_s.empty?
    args << '-tls-skip-verify' if resource[:skip_verify] == true
    args << "-client-key=#{resource[:client_key]}" unless resource[:client_key].to_s.empty?
    args << "-client-cert=#{resource[:client_cert]}" unless resource[:client_cert].to_s.empty?
    args << "-ca-cert=#{resource[:ca_cert]}" unless resource[:ca_cert].to_s.empty?
    args << "-ca-path=#{resource[:ca_path]}" unless resource[:ca_path].to_s.empty?
    args
  end

  def fetch_existing
    command = [nomad_command, 'var', 'get', '-out', 'json'] + build_command_args + [resource[:name]]
    output = execute(command, failonfail: false)
    JSON.parse(output)
  rescue JSON::ParserError, Puppet::ExecutionFailure
    nil
  end

  def exists?
    result = fetch_existing
    return false if result.nil?

    @modify_index = result['ModifyIndex']
    @existing_items = result['Items']

    if @existing_items == resource[:value]
      true
    else
      false
    end
  end

  def create
    json_value = { 'Items' => resource[:value] }.to_json
    command = [nomad_command, 'var', 'put', '-in', 'json'] + build_command_args
    command += ['-check-index', @modify_index.to_s] if @modify_index

    Tempfile.open('nomad_var') do |tempfile|
      tempfile.write(json_value)
      tempfile.flush
      execute(command + [resource[:name], '-'], stdinfile: tempfile.path)
    end
  end

  def destroy
    command = [nomad_command, 'var', 'delete'] + build_command_args + [resource[:name]]
    execute(command)
  end

  def value
    resource[:value]
  end
end
