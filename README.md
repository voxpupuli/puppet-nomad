# puppet-nomad

[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/nomad.svg)](https://forge.puppetlabs.com/puppet/nomad)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/nomad.svg)](https://forge.puppetlabs.com/puppet/nomad)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/nomad.svg)](https://forge.puppetlabs.com/puppet/nomad)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/nomad.svg)](https://forge.puppetlabs.com/puppet/nomad)
[![puppetmodule.info docs](http://www.puppetmodule.info/images/badge.png)](http://www.puppetmodule.info/m/puppet-nomad)
[![Apache-2.0 License](https://img.shields.io/github/license/voxpupuli/puppet-nomad.svg)](LICENSE)

### What This Module Affects

* Installs the nomad daemon (via url or package)
  * If installing from zip, you *must* ensure the unzip utility is available.
* Optionally installs a user to run it under
* Installs a configuration file (/etc/nomad/config.json)
* Manages the nomad service via systemd

## Reference

See [REFERENCE](REFERENCE.md).

## Limitations

Depends on the JSON gem, or a modern ruby. (Ruby 2.5 and newer are supported)

## Development
Open an [issue](https://github.com/voxpupuli/puppet-nomad/issues) or
[fork](https://github.com/voxpupuli/puppet-nomad/fork) and open a
[Pull Request](https://github.com/voxpupuli/puppet-nomad/pulls)

## Acknowledgement

Must of this module was refactored from Kyle Anderson's great [consul](https://github.com/solarkennedy/puppet-consul) module available on the puppet forge. Go give him stars and likes and what not -- he deserves them!
