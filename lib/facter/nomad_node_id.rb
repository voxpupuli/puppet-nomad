# frozen_string_literal: true

# nomad_node_id.rb
#
Facter.add(:nomad_node_id) do
  confine do
    File.readable?('/var/lib/nomad/server/node-id')
  end
  setcode do
    File.read('/var/lib/nomad/server/node-id').chomp
  rescue StandardError
    nil
  end
end
