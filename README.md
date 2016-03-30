# puppet-nomad

### What This Module Affects

* Installs the nomad daemon (via url or package)
  * If installing from zip, you *must* ensure the unzip utility is available.
* Optionally installs a user to run it under
* Installs a configuration file (/etc/nomad/config.json)
* Manages the nomad service via upstart, sysv, or systemd

## Usage

To set up a single nomad server, with several agents attached:
On the server:
```puppet
class { '::nomad':
	config_hash = {
    'region'     => 'us-west',
    'datacenter' => 'ptk',
    'log_level'  => 'INFO',
    'bind_addr'  => '0.0.0.0',
    'data_dir'   => '/opt/nomad',
    'server'     => {
      'enabled'          => true,
      'bootstrap_expect' => 3,
    }
  }
}
```
On the agent(s):
```puppet
class { 'nomad':
  config_hash   => {
    'region'     => 'us-west',
    'datacenter' => 'ptk',
    'log_level'  => 'INFO',
    'bind_addr'  => '0.0.0.0',
    'data_dir'   => '/opt/nomad',
    'client'     => {
      'enabled'    => true,
      'servers'    => [
        "nomad01.your-org.pvt:4647",
        "nomad02.your-org.pvt:4647",
        "nomad03.your-org.pvt:4647"
      ]
    }
  },
}

```
Disable install and service components:
```puppet
class { '::nomad':
  install_method => 'none',
  init_style     => false,
  manage_service => false,
  config_hash   => {
    'region'     => 'us-west',
    'datacenter' => 'ptk',
    'log_level'  => 'INFO',
    'bind_addr'  => '0.0.0.0',
    'data_dir'   => '/opt/nomad',
    'client'     => {
      'enabled'    => true,
      'servers'    => [
        "nomad01.your-org.pvt:4647",
        "nomad02.your-org.pvt:4647",
        "nomad03.your-org.pvt:4647"
      ]
    }
  },
}
```

## Limitations

Depends on the JSON gem, or a modern ruby. (Ruby 1.8.7 is not officially supported)

## Development
Open an [issue](https://github.com/dudemcbacon/puppet-nomad/issues) or
[fork](https://github.com/dudemcbacon/puppet-nomad/fork) and open a
[Pull Request](https://github.com/dudemcbacon/puppet-nomad/pulls)

## Acknowledgement

Must of this module was refactored from Kyle Anderson's great [consul](https://github.com/solarkennedy/puppet-consul) module available on the puppet forge. Go give him stars and likes and what not -- he deserves them!
