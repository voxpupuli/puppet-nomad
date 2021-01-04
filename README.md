# puppet-nomad

### What This Module Affects

* Installs the nomad daemon (via url or package)
  * If installing from zip, you *must* ensure the unzip utility is available.
* Optionally installs a user to run it under
* Installs a configuration file (/etc/nomad/config.json)
* Manages the nomad service via launchd or systemd

## Reference

See [REFERENCE](REFERENCE.md).

## Limitations

Depends on the JSON gem, or a modern ruby. (Ruby 1.8.7 is not officially supported)

## Development
Open an [issue](https://github.com/dudemcbacon/puppet-nomad/issues) or
[fork](https://github.com/dudemcbacon/puppet-nomad/fork) and open a
[Pull Request](https://github.com/dudemcbacon/puppet-nomad/pulls)

## Acknowledgement

Must of this module was refactored from Kyle Anderson's great [consul](https://github.com/solarkennedy/puppet-consul) module available on the puppet forge. Go give him stars and likes and what not -- he deserves them!
