# frozen_string_literal: true

# nomad_version.rb
#
Facter.add(:nomad_version) do
  confine kernel: 'Linux'
  confine { Facter::Core::Execution.which('nomad') }
  setcode do
    Facter::Core::Execution.execute('nomad --version 2> /dev/null').lines.first.split[1].tr('v', '')
  end
end
