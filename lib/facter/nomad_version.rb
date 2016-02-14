# nomad_version.rb

Facter.add(:nomad_version) do
  confine :kernel => 'Linux'
  setcode do
    begin
      Facter::Util::Resolution.exec('nomad --version 2> /dev/null').lines.first.split[1].tr('v','')
    rescue
      nil
    end
  end
end
