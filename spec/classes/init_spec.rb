# frozen_string_literal: true

require 'spec_helper'

describe 'nomad' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts.merge(service_provider: 'systemd', nomad_node_id: 'a1b2c3d4-1234-5678-9012-3456789abcde') }

      # Installation Stuff
      context 'On an unsupported arch' do
        let(:facts) { override_facts(super(), os: { architecture: 'bogus' }) }

        it { is_expected.to compile.and_raise_error(%r{Class\[Nomad\]: expects a value for parameter 'arch' }) }
      end

      context 'When not specifying whether to purge config' do
        it { is_expected.to contain_file('/etc/nomad.d').with(purge: true, recurse: true) }
      end

      context 'with all defaults' do
        it { is_expected.to compile.with_all_deps }
      end

      context 'When disable config purging' do
        let(:params) do
          {
            purge_config_dir: false
          }
        end

        it { is_expected.to contain_file('/etc/nomad.d').with(purge: false, recurse: false) }
      end

      context 'nomad::config should notify nomad::run_service' do
        let(:params) do
          {
            install_method: 'url',
            manage_service_file: true,
            version: '1.9.4'
          }
        end

        it { is_expected.to contain_class('nomad::config').that_notifies(['Class[nomad::run_service]']) }
        it { is_expected.to contain_systemd__unit_file('nomad.service').that_notifies(['Class[nomad::run_service]']) }
        it { is_expected.to contain_file('/usr/bin/nomad').that_notifies(['Class[nomad::run_service]']) }
      end

      context 'nomad::config should not notify nomad::run_service on config change' do
        let(:params) do
          {
            restart_on_change: false
          }
        end

        it { is_expected.not_to contain_class('nomad::config').that_notifies(['Class[nomad::run_service]']) }
      end

      context 'When joining nomad to a wan cluster by a known URL' do
        let(:params) do
          {
            join_wan: 'wan_host.test.com'
          }
        end

        it { is_expected.to contain_exec('join nomad wan').with(command: 'nomad join -wan wan_host.test.com') }
      end

      context 'By default, should not attempt to join a wan cluster' do
        it { is_expected.not_to contain_exec('join nomad wan') }
      end

      context 'When asked not to manage the repo' do
        let(:params) do
          {
            manage_repo: false
          }
        end

        it { is_expected.to compile.with_all_deps }

        case os_facts[:os]['family']
        when 'Debian'
          it { is_expected.not_to contain_apt__source('HashiCorp') }
        when 'RedHat'
          it { is_expected.not_to contain_yumrepo('HashiCorp') }
        end
      end

      context 'When asked to manage the repo but not to install using package' do
        let(:params) do
          {
            install_method: 'url',
            manage_service_file: true,
            version: '1.9.4',
            manage_repo: true
          }
        end

        it { is_expected.to compile.with_all_deps }

        case os_facts[:os]['family']
        when 'Debian'
          it { is_expected.not_to contain_apt__source('HashiCorp') }
        when 'RedHat'
          it { is_expected.not_to contain_yumrepo('HashiCorp') }
        end
      end

      context 'When asked to manage the repo and to install as package' do
        let(:params) do
          {
            install_method: 'package',
            manage_repo: true
          }
        end

        it { is_expected.to compile.with_all_deps }

        case os_facts[:os]['family']
        when 'Debian'
          it { is_expected.to contain_apt__source('HashiCorp') }
        when 'RedHat'
          it { is_expected.to contain_yumrepo('HashiCorp') }
        end
      end

      context 'When requesting to install via a package with defaults' do
        let(:params) do
          {
            install_method: 'package'
          }
        end

        it { is_expected.to contain_package('nomad').with(ensure: 'installed') }
      end

      context 'When requesting to install via a custom package and version' do
        let(:params) do
          {
            install_method: 'package',
            package_name: 'custom_nomad_package',
            version: 'specific_release'
          }
        end

        it { is_expected.to contain_package('custom_nomad_package').with(ensure: 'specific_release') }
      end

      context 'When installing via URL by default' do
        let(:params) do
          {
            install_method: 'url',
            version: '1.9.4'
          }
        end

        it { is_expected.to contain_archive('/opt/puppet-archive/nomad-1.9.4.zip').with(source: 'https://releases.hashicorp.com/nomad/1.9.4/nomad_1.9.4_linux_amd64.zip') }
        it { is_expected.to contain_file('/opt/puppet-archive').with(ensure: 'directory') }
        it { is_expected.to contain_file('/opt/puppet-archive/nomad-1.9.4').with(ensure: 'directory') }
        it { is_expected.to contain_file('/usr/bin/nomad').that_notifies(['Class[nomad::run_service]']) }
      end

      context 'When installing via URL by with a special version' do
        let(:params) do
          {
            install_method: 'url',
            version: '42',
          }
        end

        it { is_expected.to contain_archive('/opt/puppet-archive/nomad-42.zip').with(source: 'https://releases.hashicorp.com/nomad/42/nomad_42_linux_amd64.zip') }
        it { is_expected.to contain_file('/usr/bin/nomad').that_notifies(['Class[nomad::run_service]']) }
      end

      context 'When installing via URL by with a custom url' do
        let(:params) do
          {
            install_method: 'url',
            download_url: 'http://myurl',
            version: '1.9.4',
          }
        end

        it { is_expected.to contain_archive('/opt/puppet-archive/nomad-1.9.4.zip').with(source: 'http://myurl') }
        it { is_expected.to contain_file('/usr/bin/nomad').that_notifies(['Class[nomad::run_service]']) }
      end

      context 'When requesting to not to install' do
        let(:params) do
          {
            install_method: 'none'
          }
        end

        it { is_expected.not_to contain_package('nomad') }
        it { is_expected.not_to contain_archive('/opt/puppet-archive/nomad-1.9.4.zip') }
      end

      context 'When data_dir is provided' do
        let(:params) do
          {
            config_hash: {
              'data_dir' => '/dir1',
            },
          }
        end

        it { is_expected.to contain_file('/dir1').with(ensure: :directory, mode: '0755') }

        context 'When data_dir_mode is provided' do
          let(:params) do
            {
              config_hash: {
                'data_dir' => '/dir1',
              },
              data_dir_mode: '0750'
            }
          end

          it { is_expected.to contain_file('/dir1').with(mode: '0750') }
        end
      end

      context 'When data_dir not provided' do
        it { is_expected.not_to contain_file('/dir1').with(ensure: :directory) }
      end

      context 'When plugin_dir is provided' do
        let(:params) do
          {
            config_hash: {
              'plugin_dir' => '/plugin_dir',
            },
          }
        end

        it { is_expected.to contain_file('/plugin_dir').with(ensure: :directory, mode: '0755') }

        context 'When plugin_dir_mode is provided' do
          let(:params) do
            {
              config_hash: {
                'plugin_dir' => '/plugin_dir',
              },
              plugin_dir_mode: '0750'
            }
          end

          it { is_expected.to contain_file('/plugin_dir').with(mode: '0750') }
        end
      end

      context 'When plugin_dir is not provided' do
        it { is_expected.not_to contain_file('/plugin_dir').with(ensure: :directory) }
      end

      context 'The bootstrap_expect in config_hash is an int' do
        let(:params) do
          {
            config_hash: { 'bootstrap_expect' => 5 }
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
              'bootstrap_expect' => 5,
            }
          }
        end

        it { is_expected.to contain_file('nomad config.json').with_content(%r{"bootstrap_expect":5}) }
        it { is_expected.to contain_file('nomad config.json').with_content(%r{"data_dir":"/dir1"}) }
      end

      context 'Config_defaults is used to provide additional config and is overridden' do
        let(:params) do
          {
            config_defaults: {
              'data_dir' => '/dir1',
              'server' => false,
              'ports' => {
                'http' => 1,
                'rpc' => 8300,
              },
            },
            config_hash: {
              'bootstrap_expect' => 5,
              'server' => true,
              'ports' => {
                'http' => -1,
                'https' => 8500,
              },
            }
          }
        end

        it { is_expected.to contain_file('nomad config.json').with_content(%r{"bootstrap_expect":5}) }
        it { is_expected.to contain_file('nomad config.json').with_content(%r{"data_dir":"/dir1"}) }
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
              'bootstrap_expect' => 5,
              'server' => true,
              'ports' => {
                'http' => -1,
                'https' => 8500,
              },
            }
          }
        end

        it { is_expected.to contain_file('nomad config.json').with_content(%r{"bootstrap_expect": 5,}) }
        it { is_expected.to contain_file('nomad config.json').with_content(%r{"server": true}) }
        it { is_expected.to contain_file('nomad config.json').with_content(%r{"http": -1,}) }
        it { is_expected.to contain_file('nomad config.json').with_content(%r{"https": 8500}) }
      end

      context 'When asked not to manage the service' do
        let(:params) { { manage_service: false } }

        it { is_expected.not_to contain_service('nomad') }
      end

      context 'When a reload_service is triggered with service_ensure stopped' do
        let :params do
          {
            service_ensure: 'stopped',
          }
        end

        it { is_expected.not_to contain_exec('reload nomad service') }
      end

      context 'When a reload_service is triggered with manage_service false' do
        let :params do
          {
            manage_service: false,
          }
        end

        it { is_expected.not_to contain_exec('reload nomad service') }
      end

      context 'Config with custom file mode' do
        let :params do
          {
            config_mode: '0600',
          }
        end

        it {
          expect(subject).to contain_file('nomad config.json').with(
            mode: '0600'
          )
        }
      end

      context 'When nomad is reloaded' do
        it {
          expect(subject).to contain_exec('reload nomad service').
            with_command('systemctl reload nomad')
        }
      end

      context 'When nomad is reloaded on a custom port' do
        let :params do
          {
            config_hash: {
              'ports' => {
                'rpc' => '9999'
              },
              'addresses' => {
                'rpc' => 'nomad.example.com'
              }
            }
          }
        end

        it {
          expect(subject).to contain_exec('reload nomad service').
            with_command('systemctl reload nomad')
        }
      end

      context 'When nomad is reloaded with a default client_addr' do
        let :params do
          {
            config_hash: {
              'client_addr' => '192.168.34.56',
            }
          }
        end

        it {
          expect(subject).to contain_exec('reload nomad service').
            with_command('systemctl reload nomad')
        }
      end

      # Config Stuff
      context 'With extra_options' do
        let(:params) do
          {
            manage_service_file: true,
            extra_options: '-some-extra-argument'
          }
        end

        it { is_expected.to contain_file('/etc/systemd/system/nomad.service').with_content(%r{^ExecStart=.*-some-extra-argument$}) }
      end

      context 'without env_vars' do
        it { is_expected.to contain_file('/etc/nomad.d/nomad.env').with_content("\n") }
      end

      context 'with env_vars' do
        let :params do
          {
            env_vars: {
              'TEST' => 'foobar',
              'BLA' => 'blub',
            }
          }
        end

        it { is_expected.to contain_file('/etc/nomad.d/nomad.env').with_content(%r{TEST=foobar}) }
        it { is_expected.to contain_file('/etc/nomad.d/nomad.env').with_content(%r{BLA=blub}) }
      end

      context 'With non-default user and group' do
        context 'with defaults' do
          let :params do
            {
              user: 'nomad',
              group: 'nomad',
            }
          end

          it { is_expected.to contain_file('/etc/nomad.d').with(owner: 'nomad', group: 'nomad') }
          it { is_expected.to contain_file('nomad config.json').with(owner: 'nomad', group: 'nomad') }
        end

        context 'with provided data_dir' do
          let :params do
            {
              config_hash: {
                'data_dir' => '/dir1',
              },
              user: 'nomad',
              group: 'nomad',
            }
          end

          it { is_expected.to contain_file('/dir1').with(ensure: 'directory', owner: 'nomad', group: 'nomad') }
        end

        context 'with provided plugin_dir' do
          let :params do
            {
              config_hash: {
                'plugin_dir' => '/dir1',
              },
              user: 'nomad',
              group: 'nomad',
            }
          end

          it { is_expected.to contain_file('/dir1').with(ensure: 'directory', owner: 'nomad', group: 'nomad') }
        end

        context 'with env_vars' do
          let :params do
            {
              env_vars: {
                'TEST' => 'foobar',
                'BLA' => 'blub',
              },
              user: 'nomad',
              group: 'nomad',
            }
          end

          it { is_expected.to contain_file('/etc/nomad.d/nomad.env').with(content: %r{TEST=foobar}, owner: 'nomad', group: 'nomad') }
          it { is_expected.to contain_file('/etc/nomad.d/nomad.env').with(content: %r{BLA=blub}, owner: 'nomad', group: 'nomad') }
        end

        context 'with manage_service_file = true' do
          let :params do
            {
              user: 'nomad',
              group: 'nomad',
              manage_service_file: true,
            }
          end

          it { is_expected.to contain_file('/etc/systemd/system/nomad.service').with_content(%r{^User=nomad$}) }
          it { is_expected.to contain_file('/etc/systemd/system/nomad.service').with_content(%r{^Group=nomad$}) }
        end
      end

      context 'with server recovery enabled' do
        let(:params) do
          {
            server_recovery: true,
            recovery_nomad_server_hash: {
              '192.168.1.10' => 'a1b2c3d4-1234-5678-9012-3456789abcde',
              '192.168.1.11' => 'b2c3d4a1-5678-9012-1234-56789abcde12',
            },
          }
        end

        it {
          is_expected.to compile.with_all_deps
          is_expected.to contain_class('nomad::server_recovery')
          is_expected.to contain_file('/usr/local/bin/nomad-server-outage-recovery.sh').with(owner: 'root', group: 'root', mode: '0750')
          is_expected.to contain_file('/tmp/peers.json').with(owner: 'root', group: 'root', mode: '0640', content: '[
  {
    "id": "a1b2c3d4-1234-5678-9012-3456789abcde",
    "address": "192.168.1.10:4647",
    "non_voter": false
  },
  {
    "id": "b2c3d4a1-5678-9012-1234-56789abcde12",
    "address": "192.168.1.11:4647",
    "non_voter": false
  }
]
')
        }
      end

      context 'When host_volume is supplied' do
        let(:params) do
          {
            config_hash: {
              'client' => {
                'enabled' => true,
                'host_volume' => [
                  {
                    'test_application' => {
                      'path' => '/data/dir1',
                    },
                  }
                ],
              },
            }
          }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_file('nomad config.json').with_content(%r{"path":"/data/dir1"}) }
        it { is_expected.to contain_file('/usr/local/bin/config_validate.rb').with(owner: 'root', group: 'root', mode: '0755', source: 'puppet:///modules/nomad/config_validate.rb', before: 'File[nomad config.json]') }
      end
    end
  end
end
