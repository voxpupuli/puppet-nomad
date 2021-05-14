require 'spec_helper'

describe 'nomad' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts.merge(service_provider: 'systemd') }

      # Installation Stuff
      context 'On an unsupported arch' do
        let(:facts) { override_facts(super(), os: {architecture: 'bogus'}) }

        it { should compile.and_raise_error(/Class\[Nomad\]: expects a value for parameter \'arch\' /) }
      end

      context 'When not specifying whether to purge config' do
        it { should contain_file('/etc/nomad.d').with(:purge => true,:recurse => true) }
      end

      context 'with all defaults' do
        it { is_expected.to compile.with_all_deps }
      end

      context 'When disable config purging' do
        let(:params) {{
          :purge_config_dir => false
        }}

        it { should contain_file('/etc/nomad.d').with(:purge => false,:recurse => false) }
      end

      context 'nomad::config should notify nomad::run_service' do
        let(:params) {{
          :install_method      => 'url',
          :manage_service_file => true,
          :version             => '1.0.3'
        }}
        it { should contain_class('nomad::config').that_notifies(['Class[nomad::run_service]']) }
        it { should contain_systemd__unit_file('nomad.service').that_notifies(['Class[nomad::run_service]']) }
        it { should contain_file('/usr/bin/nomad').that_notifies(['Class[nomad::run_service]']) }
      end

      context 'nomad::config should not notify nomad::run_service on config change' do
        let(:params) {{
          :restart_on_change => false
        }}
        it { should_not contain_class('nomad::config').that_notifies(['Class[nomad::run_service]']) }
      end

      context 'When joining nomad to a wan cluster by a known URL' do
        let(:params) {{
            :join_wan => 'wan_host.test.com'
        }}
        it { should contain_exec('join nomad wan').with(:command => 'nomad join -wan wan_host.test.com') }
      end

      context 'By default, should not attempt to join a wan cluster' do
        it { should_not contain_exec('join nomad wan') }
      end

      context "When asked not to manage the repo" do
        let(:params) {{
          :manage_repo => false
        }}

        case os_facts[:os]['family']
        when 'Debian'
          it { should_not contain_apt__source('HashiCorp') }
        when 'RedHat'
          it { should_not contain_yumrepo('HashiCorp') }
        end
      end

      context "When asked to manage the repo but not to install using package" do
        let(:params) {{
          :install_method      => 'url',
          :manage_service_file => true,
          :version             => '1.0.3',
          :manage_repo         => true
        }}

        case os_facts[:os]['family']
        when 'Debian'
          it { should_not contain_apt__source('HashiCorp') }
        when 'RedHat'
          it { should_not contain_yumrepo('HashiCorp') }
        end
      end

      context "When asked to manage the repo and to install as package" do
        let(:params) {{
          :install_method => 'package',
          :manage_repo => true
        }}

        case os_facts[:os]['family']
        when 'Debian'
          it { should contain_apt__source('HashiCorp') }
        when 'RedHat'
          it { should contain_yumrepo('HashiCorp') }
        end
      end

      context 'When requesting to install via a package with defaults' do
        let(:params) {{
          :install_method => 'package'
        }}
        it { should contain_package('nomad').with(:ensure => 'installed') }
      end

      context 'When requesting to install via a custom package and version' do
        let(:params) {{
          :install_method => 'package',
          :package_name   => 'custom_nomad_package',
          :version        => 'specific_release'
        }}
        it { should contain_package('custom_nomad_package').with(:ensure => 'specific_release') }
      end

      context "When installing via URL by default" do
        let(:params) {{
          :install_method => 'url',
          :version        => '1.0.3'
        }}
        it { should contain_archive('/opt/puppet-archive/nomad-1.0.3.zip').with(:source => 'https://releases.hashicorp.com/nomad/1.0.3/nomad_1.0.3_linux_amd64.zip') }
        it { should contain_file('/opt/puppet-archive').with(:ensure => 'directory') }
        it { should contain_file('/opt/puppet-archive/nomad-1.0.3').with(:ensure => 'directory') }
        it { should contain_file('/usr/bin/nomad').that_notifies(['Class[nomad::run_service]']) }
      end

      context "When installing via URL by with a special version" do
        let(:params) {{
          :install_method => 'url',
          :version        => '42',
        }}
        it { should contain_archive('/opt/puppet-archive/nomad-42.zip').with(:source => 'https://releases.hashicorp.com/nomad/42/nomad_42_linux_amd64.zip') }
        it { should contain_file('/usr/bin/nomad').that_notifies(['Class[nomad::run_service]']) }
      end

      context "When installing via URL by with a custom url" do
        let(:params) {{
          :install_method => 'url',
          :download_url   => 'http://myurl',
          :version        => '1.0.3',
        }}
        it { should contain_archive('/opt/puppet-archive/nomad-1.0.3.zip').with(:source => 'http://myurl') }
        it { should contain_file('/usr/bin/nomad').that_notifies(['Class[nomad::run_service]']) }
      end


      context 'When requesting to install via a package with defaults' do
        let(:params) {{
          :install_method => 'package'
        }}
        it { should contain_package('nomad').with(:ensure => 'installed') }
      end

      context 'When requesting to not to install' do
        let(:params) {{
          :install_method => 'none'
        }}
        it { should_not contain_package('nomad') }
        it { should_not contain_archive('/opt/puppet-archive/nomad-1.0.3.zip') }
      end

      context "When data_dir is provided" do
        let(:params) {{
          :config_hash => {
            'data_dir' => '/dir1',
          },
        }}
        it { should contain_file('/dir1').with(:ensure => :directory) }
      end

      context "When data_dir not provided" do
        it { should_not contain_file('/dir1').with(:ensure => :directory) }
      end

      context 'The bootstrap_expect in config_hash is an int' do
        let(:params) {{
          :config_hash =>
            { 'bootstrap_expect' => 5 }
        }}
        it { should contain_file('nomad config.json').with_content(/"bootstrap_expect":5/) }
        it { should_not contain_file('nomad config.json').with_content(/"bootstrap_expect":"5"/) }
      end

      context 'Config_defaults is used to provide additional config' do
        let(:params) {{
          :config_defaults => {
              'data_dir' => '/dir1',
          },
          :config_hash => {
              'bootstrap_expect' => 5,
          }
        }}
        it { should contain_file('nomad config.json').with_content(/"bootstrap_expect":5/) }
        it { should contain_file('nomad config.json').with_content(/"data_dir":"\/dir1"/) }
      end

      context 'Config_defaults is used to provide additional config and is overridden' do
        let(:params) {{
          :config_defaults => {
              'data_dir' => '/dir1',
              'server' => false,
              'ports' => {
                'http' => 1,
                'rpc'  => 8300,
              },
          },
          :config_hash => {
              'bootstrap_expect' => 5,
              'server' => true,
              'ports' => {
                'http'  => -1,
                'https' => 8500,
              },
          }
        }}
        it { should contain_file('nomad config.json').with_content(/"bootstrap_expect":5/) }
        it { should contain_file('nomad config.json').with_content(/"data_dir":"\/dir1"/) }
        it { should contain_file('nomad config.json').with_content(/"server":true/) }
        it { should contain_file('nomad config.json').with_content(/"http":-1/) }
        it { should contain_file('nomad config.json').with_content(/"https":8500/) }
        it { should contain_file('nomad config.json').with_content(/"rpc":8300/) }
      end

      context 'When pretty config is true' do
        let(:params) {{
          :pretty_config => true,
          :config_hash => {
              'bootstrap_expect' => 5,
              'server' => true,
              'ports' => {
                'http'  => -1,
                'https' => 8500,
              },
          }
        }}
        it { should contain_file('nomad config.json').with_content(/"bootstrap_expect": 5,/) }
        it { should contain_file('nomad config.json').with_content(/"server": true/) }
        it { should contain_file('nomad config.json').with_content(/"http": -1,/) }
        it { should contain_file('nomad config.json').with_content(/"https": 8500/) }
      end

      context "When asked not to manage the service" do
        let(:params) {{ :manage_service => false }}

        it { should_not contain_service('nomad') }
      end

      context "When a reload_service is triggered with service_ensure stopped" do
        let (:params) {{
          :service_ensure => 'stopped',
        }}
        it { should_not contain_exec('reload nomad service')  }
      end

      context "When a reload_service is triggered with manage_service false" do
        let (:params) {{
          :manage_service => false,
        }}
        it { should_not contain_exec('reload nomad service')  }
      end

      context "Config with custom file mode" do
        let(:params) {{
          :config_mode  => '0600',
        }}
        it { should contain_file('nomad config.json').with(
          :mode  => '0600'
        )}
      end

      context "When nomad is reloaded" do
        it {
          should contain_exec('reload nomad service').
            with_command('nomad reload -rpc-addr=127.0.0.1:8400')
        }
      end

      context "When nomad is reloaded on a custom port" do
        let (:params) {{
          :config_hash => {
            'ports' => {
              'rpc' => '9999'
            },
            'addresses' => {
              'rpc' => 'nomad.example.com'
            }
          }
        }}
        it {
          should contain_exec('reload nomad service').
            with_command('nomad reload -rpc-addr=nomad.example.com:9999')
        }
      end

      context "When nomad is reloaded with a default client_addr" do
        let (:params) {{
          :config_hash => {
            'client_addr' => '192.168.34.56',
          }
        }}
        it {
          should contain_exec('reload nomad service').
            with_command('nomad reload -rpc-addr=192.168.34.56:8400')
        }
      end

      # Config Stuff
      context "With extra_options" do
        let(:params) {{
          :manage_service_file => true,
          :extra_options       => '-some-extra-argument'
        }}
        it { should contain_file("/etc/systemd/system/nomad.service").with_content(/^ExecStart=.*-some-extra-argument$/) }
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
    end
  end
end
