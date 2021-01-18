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
        it { should contain_file('/etc/nomad').with(:purge => true,:recurse => true) }
      end

      context 'When disable config purging' do
        let(:params) {{
          :purge_config_dir => false
        }}

        it { should contain_file('/etc/nomad').with(:purge => false,:recurse => false) }
      end

      context 'nomad::config should notify nomad::run_service' do
        it { should contain_class('nomad::config').that_notifies(['Class[nomad::run_service]']) }
        it { should contain_file('/usr/local/bin/nomad').that_notifies(['Class[nomad::run_service]']) }
        it { should contain_systemd__unit_file('nomad.service').that_notifies(['Class[nomad::run_service]']) }
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
          :install_method => 'url',
          :manage_repo => true
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
          :package_ensure => 'specific_release',
          :package_name   => 'custom_nomad_package'
        }}
        it { should contain_package('custom_nomad_package').with(:ensure => 'specific_release') }
      end

      context "When installing via URL by default" do
        it { should contain_archive('/opt/puppet-archive/nomad-1.0.2.zip').with(:source => 'https://releases.hashicorp.com/nomad/1.0.2/nomad_1.0.2_linux_amd64.zip') }
        it { should contain_file('/opt/puppet-archive').with(:ensure => 'directory') }
        it { should contain_file('/opt/puppet-archive/nomad-1.0.2').with(:ensure => 'directory') }
        it { should contain_file('/usr/local/bin/nomad').that_notifies('Class[nomad::run_service]') }
      end

      context "When installing via URL by with a special version" do
        let(:params) {{
          :version   => '42',
        }}
        it { should contain_archive('/opt/puppet-archive/nomad-42.zip').with(:source => 'https://releases.hashicorp.com/nomad/42/nomad_42_linux_amd64.zip') }
        it { should contain_file('/usr/local/bin/nomad').that_notifies('Class[nomad::run_service]') }
      end

      context "When installing via URL by with a custom url" do
        let(:params) {{
          :download_url   => 'http://myurl',
        }}
        it { should contain_archive('/opt/puppet-archive/nomad-1.0.2.zip').with(:source => 'http://myurl') }
        it { should contain_file('/usr/local/bin/nomad').that_notifies('Class[nomad::run_service]') }
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
        it { should_not contain_archive('/opt/puppet-archive/nomad-1.0.2.zip') }
      end



      context "By default, a user and group should be installed" do
        it { should contain_user('nomad').with(:ensure => :present) }
        it { should contain_group('nomad').with(:ensure => :present) }
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
            { 'bootstrap_expect' => '5' }
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
              'bootstrap_expect' => '5',
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
                'rpc'  => '8300',
              },
          },
          :config_hash => {
              'bootstrap_expect' => '5',
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
              'bootstrap_expect' => '5',
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
        it { should contain_file('nomad config.json').with_content(/"ports": \{/) }
      end

      context "When asked not to manage the user" do
        let(:params) {{ :manage_user => false }}
        it { should_not contain_user('nomad') }
      end

      context "When asked not to manage the group" do
        let(:params) {{ :manage_group => false }}
        it { should_not contain_group('nomad') }
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

      context "With a custom username" do
        let(:params) {{
          :user => 'custom_nomad_user',
          :group => 'custom_nomad_group',
        }}
        it { should contain_user('custom_nomad_user').with(:ensure => :present) }
        it { should contain_group('custom_nomad_group').with(:ensure => :present) }
      end

      context "Config with custom file mode" do
        let(:params) {{
          :user  => 'custom_nomad_user',
          :group => 'custom_nomad_group',
          :config_mode  => '0600',
        }}
        it { should contain_file('nomad config.json').with(
          :owner => 'custom_nomad_user',
          :group => 'custom_nomad_group',
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

      context "When asked not to manage the init_style" do
        let(:params) {{ :init_style => false }}
        it { should contain_class('nomad').with_init_style(false) }
        it { should_not contain_file("/etc/systemd/system/nomad.service") }
      end

      # Config Stuff
      context "With extra_options" do
        let(:params) {{
          :extra_options => '-some-extra-argument'
        }}
        it { should contain_file("/etc/systemd/system/nomad.service").with_content(/^ExecStart=.*-some-extra-argument$/) }
      end

      # Service Stuff
      it { should contain_class('nomad').with_init_style('systemd') }
      it { should contain_file('/etc/systemd/system/nomad.service').with_content(/nomad agent/) }
    end
  end
end
