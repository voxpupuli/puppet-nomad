require 'spec_helper'

describe 'nomad' do
  RSpec.configure do |c|
    c.default_facts = {
      architecture: 'x86_64',
      operatingsystem: 'Ubuntu',
      osfamily: 'Debian',
      operatingsystemrelease: '10.04',
      kernel: 'Linux',
    }
  end
  # Installation Stuff
  context 'On an unsupported arch' do
    let(:facts) { { architecture: 'bogus' } }
    let(:params) do
      {
        install_method: 'package',
      }
    end

    it { expect { is_expected.to compile }.to raise_error(%r{Unsupported kernel architecture:}) }
  end

  context 'When not specifying whether to purge config' do
    it { is_expected.to contain_file('/etc/nomad').with(purge: true, recurse: true) }
  end

  context 'When passing a non-bool as purge_config_dir' do
    let(:params) do
      {
        purge_config_dir: 'hello',
      }
    end

    it { expect { is_expected.to compile }.to raise_error(%r{is not a boolean}) }
  end

  context 'When passing a non-bool as manage_service' do
    let(:params) do
      {
        manage_service: 'hello',
      }
    end

    it { expect { is_expected.to compile }.to raise_error(%r{is not a boolean}) }
  end

  context 'When disable config purging' do
    let(:params) do
      {
        purge_config_dir: false,
      }
    end

    it { is_expected.to contain_class('nomad::config').with(purge: false) }
  end

  context 'nomad::config should notify nomad::run_service' do
    it { is_expected.to contain_class('nomad::config').that_notifies(['Class[nomad::run_service]']) }
  end

  context 'nomad::config should not notify nomad::run_service on config change' do
    let(:params) do
      {
        restart_on_change: false,
      }
    end

    it { is_expected.not_to contain_class('nomad::config').that_notifies(['Class[nomad::run_service]']) }
  end

  context 'When joining nomad to a wan cluster by a known URL' do
    let(:params) do
      {
        join_wan: 'wan_host.test.com',
      }
    end

    it { is_expected.to contain_exec('join nomad wan').with(command: 'nomad join -wan wan_host.test.com') }
  end

  context 'By default, should not attempt to join a wan cluster' do
    it { is_expected.not_to contain_exec('join nomad wan') }
  end

  context 'When requesting to install via a package with defaults' do
    let(:params) do
      {
        install_method: 'package',
      }
    end

    it { is_expected.to contain_package('nomad').with(ensure: 'latest') }
  end

  context 'When requesting to install via a custom package and version' do
    let(:params) do
      {
        install_method: 'package',
        package_ensure: 'specific_release',
        package_name: 'custom_nomad_package',
      }
    end

    it { is_expected.to contain_package('custom_nomad_package').with(ensure: 'specific_release') }
  end

  context 'When installing via URL by default' do
    it { is_expected.to contain_archive('/opt/puppet-archive/nomad-0.5.2.zip').with(source: 'https://releases.hashicorp.com/nomad/0.5.2/nomad_0.5.2_linux_amd64.zip') }
    it { is_expected.to contain_file('/opt/puppet-archive').with(ensure: 'directory') }
    it { is_expected.to contain_file('/opt/puppet-archive/nomad-0.5.2').with(ensure: 'directory') }
    it { is_expected.to contain_file('/usr/local/bin/nomad').that_notifies('Class[nomad::run_service]') }
  end

  context 'When installing via URL by with a special version' do
    let(:params) do
      {
        version: '42',
      }
    end

    it { is_expected.to contain_archive('nomad-42.zip').with(source: 'https://releases.hashicorp.com/nomad/42/nomad_42_linux_amd64.zip') }
    it { is_expected.to contain_file('/usr/local/bin/nomad').that_notifies('Class[nomad::run_service]') }
  end

  context 'When installing via URL by with a custom url' do
    let(:params) do
      {
        download_url: 'http://myurl',
      }
    end

    it { is_expected.to contain_archive('nomad-0.2.3.zip').with(source: 'http://myurl') }
    it { is_expected.to contain_file('/usr/local/bin/nomad').that_notifies('Class[nomad::run_service]') }
  end

  context 'When requesting to install via a package with defaults' do
    let(:params) do
      {
        install_method: 'package',
      }
    end

    it { is_expected.to contain_package('nomad').with(ensure: 'latest') }
  end

  context 'When requesting to not to install' do
    let(:params) do
      {
        install_method: 'none',
      }
    end

    it { is_expected.not_to contain_package('nomad') }
    it { is_expected.not_to contain_archive('/opt/puppet-archive/nomad-0.5.2.zip') }
  end

  context 'By default, a user and group should be installed' do
    it { is_expected.to contain_user('nomad').with(ensure: :present) }
    it { is_expected.to contain_group('nomad').with(ensure: :present) }
  end

  context 'When data_dir is provided' do
    let(:params) do
      {
        config_hash: {
          'data_dir' => '/dir1',
        },
      }
    end

    it { is_expected.to contain_file('/dir1').with(ensure: :directory) }
  end

  context 'When data_dir not provided' do
    it { is_expected.not_to contain_file('/dir1').with(ensure: :directory) }
  end

  context 'The bootstrap_expect in config_hash is an int' do
    let(:params) do
      {
        config_hash:         { 'bootstrap_expect' => '5' },
      }
    end

    it { is_expected.to contain_file('nomad config.json').with_content(%r{"bootstrap_expect":5}) }
    it { is_expected.not_to contain_file('nomad config.json').with_content(%r{"bootstrap_expect":"5"}) }
  end

  context 'Config_defaults is used to provide additional config' do
    let(:params) do
      {
        config_defaults: {
          'data_dir' => '/dir1',
        },
        config_hash: {
          'bootstrap_expect' => '5',
        },
      }
    end

    it { is_expected.to contain_file('nomad config.json').with_content(%r{"bootstrap_expect":5}) }
    it { is_expected.to contain_file('nomad config.json').with_content(/"data_dir":"\/dir1"/) }
  end

  context 'Config_defaults is used to provide additional config and is overridden' do
    let(:params) do
      {
        config_defaults: {
          'data_dir' => '/dir1',
          'server' => false,
          'ports' => {
            'http' => 1,
            'rpc' => '8300',
          },
        },
        config_hash: {
          'bootstrap_expect' => '5',
          'server' => true,
          'ports' => {
            'http'  => -1,
            'https' => 8500,
          },
        },
      }
    end

    it { is_expected.to contain_file('nomad config.json').with_content(%r{"bootstrap_expect":5}) }
    it { is_expected.to contain_file('nomad config.json').with_content(/"data_dir":"\/dir1"/) }
    it { is_expected.to contain_file('nomad config.json').with_content(%r{"server":true}) }
    it { is_expected.to contain_file('nomad config.json').with_content(%r{"http":-1}) }
    it { is_expected.to contain_file('nomad config.json').with_content(%r{"https":8500}) }
    it { is_expected.to contain_file('nomad config.json').with_content(%r{"rpc":8300}) }
  end

  context 'When pretty config is true' do
    let(:params) do
      {
        pretty_config: true,
        config_hash: {
          'bootstrap_expect' => '5',
          'server' => true,
          'ports' => {
            'http'  => -1,
            'https' => 8500,
          },
        },
      }
    end

    it { is_expected.to contain_file('nomad config.json').with_content(%r{"bootstrap_expect": 5,}) }
    it { is_expected.to contain_file('nomad config.json').with_content(%r{"server": true}) }
    it { is_expected.to contain_file('nomad config.json').with_content(%r{"http": -1,}) }
    it { is_expected.to contain_file('nomad config.json').with_content(%r{"https": 8500}) }
    it { is_expected.to contain_file('nomad config.json').with_content(%r{"ports": \{}) }
  end

  context 'When asked not to manage the user' do
    let(:params) { { manage_user: false } }

    it { is_expected.not_to contain_user('nomad') }
  end

  context 'When asked not to manage the group' do
    let(:params) { { manage_group: false } }

    it { is_expected.not_to contain_group('nomad') }
  end

  context 'When asked not to manage the service' do
    let(:params) { { manage_service: false } }

    it { is_expected.not_to contain_service('nomad') }
  end

  context 'When a reload_service is triggered with service_ensure stopped' do
    let (:params) do
      {
        service_ensure: 'stopped',
      }
    end

    it { is_expected.not_to contain_exec('reload nomad service') }
  end

  context 'When a reload_service is triggered with manage_service false' do
    let (:params) do
      {
        manage_service: false,
      }
    end

    it { is_expected.not_to contain_exec('reload nomad service') }
  end

  context 'With a custom username' do
    let(:params) do
      {
        user: 'custom_nomad_user',
        group: 'custom_nomad_group',
      }
    end

    it { is_expected.to contain_user('custom_nomad_user').with(ensure: :present) }
    it { is_expected.to contain_group('custom_nomad_group').with(ensure: :present) }
    it { is_expected.to contain_file('/etc/init/nomad.conf').with_content(%r{env USER=custom_nomad_user}) }
    it { is_expected.to contain_file('/etc/init/nomad.conf').with_content(%r{env GROUP=custom_nomad_group}) }
  end

  context 'Config with custom file mode' do
    let(:params) do
      {
        user: 'custom_nomad_user',
        group: 'custom_nomad_group',
        config_mode: '0600',
      }
    end

    it {
      is_expected.to contain_file('nomad config.json').with(
        owner: 'custom_nomad_user',
        group: 'custom_nomad_group',
        mode: '0600',
      )
    }
  end

  context 'When nomad is reloaded' do
    let (:facts) do
      {
        ipaddress_lo: '127.0.0.1',
      }
    end

    it {
      is_expected.to contain_exec('reload nomad service')
        .with_command('nomad reload -rpc-addr=127.0.0.1:8400')
    }
  end

  context 'When nomad is reloaded on a custom port' do
    let (:params) do
      {
        config_hash: {
          'ports' => {
            'rpc' => '9999',
          },
          'addresses' => {
            'rpc' => 'nomad.example.com',
          },
        },
      }
    end

    it {
      is_expected.to contain_exec('reload nomad service')
        .with_command('nomad reload -rpc-addr=nomad.example.com:9999')
    }
  end

  context 'When nomad is reloaded with a default client_addr' do
    let (:params) do
      {
        config_hash: {
          'client_addr' => '192.168.34.56',
        },
      }
    end

    it {
      is_expected.to contain_exec('reload nomad service')
        .with_command('nomad reload -rpc-addr=192.168.34.56:8400')
    }
  end

  context 'When using sysv' do
    let (:params) do
      {
        init_style: 'sysv',
      }
    end
    let (:facts) do
      {
        ipaddress_lo: '127.0.0.1',
      }
    end

    it { is_expected.to contain_class('nomad').with_init_style('sysv') }
    it {
      is_expected.to contain_file('/etc/init.d/nomad')
        .with_content(%r{-rpc-addr=127.0.0.1:8400})
    }
  end

  context 'When overriding default rpc port on sysv' do
    let (:params) do
      {
        init_style: 'sysv',
        config_hash: {
          'ports' => {
            'rpc' => '9999',
          },
          'addresses' => {
            'rpc' => 'nomad.example.com',
          },
        },
      }
    end

    it { is_expected.to contain_class('nomad').with_init_style('sysv') }
    it {
      is_expected.to contain_file('/etc/init.d/nomad')
        .with_content(%r{-rpc-addr=nomad.example.com:9999})
    }
  end

  context 'When rpc_addr defaults to client_addr on sysv' do
    let (:params) do
      {
        init_style: 'sysv',
        config_hash: {
          'client_addr' => '192.168.34.56',
        },
      }
    end

    it { is_expected.to contain_class('nomad').with_init_style('sysv') }
    it {
      is_expected.to contain_file('/etc/init.d/nomad')
        .with_content(%r{-rpc-addr=192.168.34.56:8400})
    }
  end

  context 'When using debian' do
    let (:params) do
      {
        init_style: 'debian',
      }
    end
    let (:facts) do
      {
        ipaddress_lo: '127.0.0.1',
      }
    end

    it { is_expected.to contain_class('nomad').with_init_style('debian') }
    it {
      is_expected.to contain_file('/etc/init.d/nomad')
        .with_content(%r{-rpc-addr=127.0.0.1:8400})
    }
  end

  context 'When overriding default rpc port on debian' do
    let (:params) do
      {
        init_style: 'debian',
        config_hash: {
          'ports' => {
            'rpc' => '9999',
          },
          'addresses' => {
            'rpc' => 'nomad.example.com',
          },
        },
      }
    end

    it { is_expected.to contain_class('nomad').with_init_style('debian') }
    it {
      is_expected.to contain_file('/etc/init.d/nomad')
        .with_content(%r{-rpc-addr=nomad.example.com:9999})
    }
  end

  context 'When using upstart' do
    let (:params) do
      {
        init_style: 'upstart',
      }
    end
    let (:facts) do
      {
        ipaddress_lo: '127.0.0.1',
      }
    end

    it { is_expected.to contain_class('nomad').with_init_style('upstart') }
    it {
      is_expected.to contain_file('/etc/init/nomad.conf')
        .with_content(%r{-rpc-addr=127.0.0.1:8400})
    }
  end

  context 'When overriding default rpc port on upstart' do
    let (:params) do
      {
        init_style: 'upstart',
        config_hash: {
          'ports' => {
            'rpc' => '9999',
          },
          'addresses' => {
            'rpc' => 'nomad.example.com',
          },
        },
      }
    end

    it { is_expected.to contain_class('nomad').with_init_style('upstart') }
    it {
      is_expected.to contain_file('/etc/init/nomad.conf')
        .with_content(%r{-rpc-addr=nomad.example.com:9999})
    }
  end

  context 'On a redhat 6 based OS' do
    let(:facts) do
      {
        operatingsystem: 'CentOS',
        operatingsystemrelease: '6.5',
      }
    end

    it { is_expected.to contain_class('nomad').with_init_style('sysv') }
    it { is_expected.to contain_file('/etc/init.d/nomad').with_content(%r{daemon --user=nomad}) }
  end

  context 'On an Archlinux based OS' do
    let(:facts) do
      {
        operatingsystem: 'Archlinux',
      }
    end

    it { is_expected.to contain_class('nomad').with_init_style('systemd') }
    it { is_expected.to contain_file('/lib/systemd/system/nomad.service').with_content(%r{nomad agent}) }
  end

  context 'On an Amazon based OS' do
    let(:facts) do
      {
        operatingsystem: 'Amazon',
        operatingsystemrelease: '3.10.34-37.137.amzn1.x86_64',
      }
    end

    it { is_expected.to contain_class('nomad').with_init_style('sysv') }
    it { is_expected.to contain_file('/etc/init.d/nomad').with_content(%r{daemon --user=nomad}) }
  end

  context 'On a redhat 7 based OS' do
    let(:facts) do
      {
        operatingsystem: 'CentOS',
        operatingsystemrelease: '7.0',
      }
    end

    it { is_expected.to contain_class('nomad').with_init_style('systemd') }
    it { is_expected.to contain_file('/lib/systemd/system/nomad.service').with_content(%r{nomad agent}) }
  end

  context 'On a fedora 20 based OS' do
    let(:facts) do
      {
        operatingsystem: 'Fedora',
        operatingsystemrelease: '20',
      }
    end

    it { is_expected.to contain_class('nomad').with_init_style('systemd') }
    it { is_expected.to contain_file('/lib/systemd/system/nomad.service').with_content(%r{nomad agent}) }
  end

  context 'On hardy' do
    let(:facts) do
      {
        operatingsystem: 'Ubuntu',
        operatingsystemrelease: '8.04',
      }
    end

    it { is_expected.to contain_class('nomad').with_init_style('debian') }
    it {
      is_expected.to contain_file('/etc/init.d/nomad') \
        .with_content(%r{start-stop-daemon .* \$DAEMON}) \
        .with_content(%r{DAEMON_ARGS="agent}) \
        .with_content(%r{--user \$USER})
    }
  end

  context 'On a Ubuntu Vivid 15.04 based OS' do
    let(:facts) do
      {
        operatingsystem: 'Ubuntu',
        operatingsystemrelease: '15.04',
      }
    end

    it { is_expected.to contain_class('nomad').with_init_style('systemd') }
    it { is_expected.to contain_file('/lib/systemd/system/nomad.service').with_content(%r{nomad agent}) }
  end

  context 'When asked not to manage the init_style' do
    let(:params) { { init_style: false } }

    it { is_expected.to contain_class('nomad').with_init_style(false) }
    it { is_expected.not_to contain_file('/etc/init.d/nomad') }
    it { is_expected.not_to contain_file('/lib/systemd/system/nomad.service') }
  end

  context 'On squeeze' do
    let(:facts) do
      {
        operatingsystem: 'Debian',
        operatingsystemrelease: '7.1',
      }
    end

    it { is_expected.to contain_class('nomad').with_init_style('debian') }
  end

  context 'On opensuse' do
    let(:facts) do
      {
        operatingsystem: 'OpenSuSE',
        operatingsystemrelease: '13.1',
      }
    end

    it { is_expected.to contain_class('nomad').with_init_style('systemd') }
  end

  context 'On SLED' do
    let(:facts) do
      {
        operatingsystem: 'SLED',
        operatingsystemrelease: '11.4',
      }
    end

    it { is_expected.to contain_class('nomad').with_init_style('sles') }
  end

  context 'On SLES' do
    let(:facts) do
      {
        operatingsystem: 'SLES',
        operatingsystemrelease: '12.0',
      }
    end

    it { is_expected.to contain_class('nomad').with_init_style('systemd') }
  end

  # Config Stuff
  context 'With extra_options' do
    let(:params) do
      {
        extra_options: '-some-extra-argument',
      }
    end

    it { is_expected.to contain_file('/etc/init/nomad.conf').with_content(%r{\$NOMAD -S -- agent .*-some-extra-argument$}) }
  end
  # Service Stuff
end
