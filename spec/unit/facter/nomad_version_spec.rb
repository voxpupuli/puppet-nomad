require "spec_helper"

describe Facter::Util::Fact do
  before {
    Facter.clear
  }

  describe "nomad_version" do

    context 'Returns nomad version on Linux'
    it do
      nomad_version_output = <<-EOS
Nomad v0.6.0
      EOS
      allow(Facter.fact(:kernel)).to receive(:value).and_return("Linux")
      allow(Facter::Util::Resolution).to receive(:exec).with('nomad --version 2> /dev/null').
        and_return(nomad_version_output)
      expect(Facter.fact(:nomad_version).value).to match('0.6.0')
    end

  end

end
