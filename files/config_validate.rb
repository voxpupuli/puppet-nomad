#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'
# "nomad config validate" does not check for all possible errors
# We added a custom script to check for the following:
#
# - if the key "host_volume" exist, extract the subkeys "path"
# - check if the paths are valid
# - exit with error if any of the paths are not valid and print the paths
#
# This script is called from the nomad::config class
#
# The script is called with the following arguments:
#
# - the path to the JSON file
#
# The script will exit with the following exit codes:
#
# - 0: validation successful
# - 1: validation failed
#

# no need to check if the file exists or the argument
# was not supplied, nomad validate will do that
config_file = ARGV[0]

# Run the nomad validate command
#
`nomad config validate #{config_file}`

unless $?.success? # rubocop:disable Style/SpecialGlobalVars
  puts 'Validation failed (according to nomad config validate)'
  exit 1
end

# now check if this an Agent configuratin stanza and ensure that the paths under each host_volume are valid
#
json_data = JSON.parse(File.read(config_file))

missing_paths = []
status_paths = []

if json_data['client'] && json_data['client']['host_volume']
  # check if the key "host_volume" is an array
  unless json_data['client']['host_volume'].is_a?(Array)
    puts 'The key "host_volume" must be an array of hashes'
    exit 1
  end

  # check if the key "path" is present in each hash
  json_data['client']['host_volume'][0]&.each do |obj|
    missing_paths.push(obj[0]) unless json_data['client']['host_volume'][0][obj[0]].key?('path')
  end

  # extract the paths
  volume_paths = json_data['client']['host_volume'].map do |item|
    item.values.map { |v| v['path'] }.compact
  end.flatten
end

unless missing_paths.empty?
  puts "The key \"path\" is missing from the following host_volume(s): #{missing_paths.join(', ')}"
  exit 1
end

volume_paths&.each do |path|
  status_paths.push(path) unless File.directory?(path) || File.file?(path)
end

unless status_paths.empty?
  puts "The following paths are not valid: #{status_paths.join(', ')}"
  exit 1
end

puts 'Validation successful'
