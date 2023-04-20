#!/opt/puppetlabs/puppet/bin/ruby
require 'json'

# supply the path to the JSON file as an argument
config_file = ARGV[0]

# Load the JSON file
data = JSON.parse(File.read(config_file))

# Check if "host_volume" exists and extract all "path" keys
if data['client'] && data['client']['host_volume']
  volume_paths = data['client']['host_volume'].map { |item|
    item.values.map { |v| v['path'] if v['path'] }.compact
  }.flatten
end

# check if the paths are valid
status_paths = []
volume_paths.each do |path|
  status_paths.push(path) unless File.directory?(path) || File.file?(path)
end

# exit with error if any of the paths are not valid
unless status_paths.empty?
  puts "The following paths are not valid: #{status_paths.join(', ')}"
  exit 1
end
