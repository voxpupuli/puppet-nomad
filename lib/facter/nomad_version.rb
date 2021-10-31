# frozen_string_literal: true

# nomad_version.rb
#
Facter.add(:nomad_version) do
  confine kernel: 'Linux'
  setcode do
    Facter::Util::Resolution.exec('nomad --version 2> /dev/null').lines.first.split[1].tr('v', '')
  rescue StandardError
    nil
  end
end
