require 'spec_helper'
describe 'apt::ppa' do
  let :pre_condition do
    'class { "apt": }'
  end

  describe 'defaults' do
    let :facts do
      {
        :lsbdistrelease  => '11.04',
        :lsbdistcodename => 'natty',
        :operatingsystem => 'Ubuntu',
        :osfamily        => 'Debian',
        :lsbdistid       => 'Ubuntu',
        :puppetversion   => '3.5.0',
      }
    end

    let(:title) { 'ppa:needs/such.substitution/wow' }
    it { is_expected.to_not contain_package('python-software-properties') }
    it { is_expected.to contain_exec('add-apt-repository-ppa:needs/such.substitution/wow').that_notifies('Exec[apt_update]').with({
      :environment => [],
      :command     => '/usr/bin/add-apt-repository -y ppa:needs/such.substitution/wow',
      :unless      => '/usr/bin/test -s /etc/apt/sources.list.d/needs-such_substitution-wow-natty.list',
      :user        => 'root',
      :logoutput   => 'on_failure',
    })
    }
  end

  describe 'ppa depending on ppa, MODULES-1156' do
    let :pre_condition do
      'class { "apt": }'
    end
  end

  describe 'package_name => software-properties-common' do
    let :pre_condition do
      'class { "apt": }'
    end
    let :params do
      {
        :package_name   => 'software-properties-common',
        :package_manage => true,
      }
    end
    let :facts do
      {
        :lsbdistrelease  => '11.04',
        :lsbdistcodename => 'natty',
        :operatingsystem => 'Ubuntu',
        :osfamily        => 'Debian',
        :lsbdistid       => 'Ubuntu',
        :puppetversion   => '3.5.0',
      }
    end

    let(:title) { 'ppa:needs/such.substitution/wow' }
    it { is_expected.to contain_package('software-properties-common') }
    it { is_expected.to contain_exec('add-apt-repository-ppa:needs/such.substitution/wow').that_notifies('Exec[apt_update]').with({
      'environment' => [],
      'command'     => '/usr/bin/add-apt-repository -y ppa:needs/such.substitution/wow',
      'unless'      => '/usr/bin/test -s /etc/apt/sources.list.d/needs-such_substitution-wow-natty.list',
      'user'        => 'root',
      'logoutput'   => 'on_failure',
    })
    }

    it { is_expected.to contain_file('/etc/apt/sources.list.d/needs-such_substitution-wow-natty.list').that_requires('Exec[add-apt-repository-ppa:needs/such.substitution/wow]').with({
      'ensure' => 'file',
    })
    }
  end

  describe 'package_manage => false' do
    let :pre_condition do
      'class { "apt": }'
    end
    let :facts do
      {
        :lsbdistrelease  => '11.04',
        :lsbdistcodename => 'natty',
        :operatingsystem => 'Ubuntu',
        :osfamily        => 'Debian',
        :lsbdistid       => 'Ubuntu',
        :puppetversion   => '3.5.0',
      }
    end
    let :params do
      {
        :package_manage => false,
      }
    end

    let(:title) { 'ppa:needs/such.substitution/wow' }
    it { is_expected.to_not contain_package('python-software-properties') }
    it { is_expected.to contain_exec('add-apt-repository-ppa:needs/such.substitution/wow').that_notifies('Exec[apt_update]').with({
      'environment' => [],
      'command'     => '/usr/bin/add-apt-repository -y ppa:needs/such.substitution/wow',
      'unless'      => '/usr/bin/test -s /etc/apt/sources.list.d/needs-such_substitution-wow-natty.list',
      'user'        => 'root',
      'logoutput'   => 'on_failure',
    })
    }

    it { is_expected.to contain_file('/etc/apt/sources.list.d/needs-such_substitution-wow-natty.list').that_requires('Exec[add-apt-repository-ppa:needs/such.substitution/wow]').with({
      'ensure' => 'file',
    })
    }
  end

  describe 'apt included, no proxy' do
    let :pre_condition do
      'class { "apt": }
      apt::ppa { "ppa:foo2": }
      '
    end
    let :facts do
      {
        :lsbdistrelease  => '14.04',
        :lsbdistcodename => 'trusty',
        :operatingsystem => 'Ubuntu',
        :lsbdistid       => 'Ubuntu',
        :osfamily        => 'Debian',
        :puppetversion   => '3.5.0',
      }
    end
    let :params do
      {
        :options        => '',
        :package_manage => true,
        :require        => 'Apt::Ppa[ppa:foo2]',
      }
    end
    let(:title) { 'ppa:foo' }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_package('software-properties-common') }
    it { is_expected.to contain_exec('add-apt-repository-ppa:foo').that_notifies('Exec[apt_update]').with({
      :environment => [],
      :command     => '/usr/bin/add-apt-repository  ppa:foo',
      :unless      => '/usr/bin/test -s /etc/apt/sources.list.d/foo-trusty.list',
      :user        => 'root',
      :logoutput   => 'on_failure',
    })
    }
  end

  describe 'apt included, proxy host' do
    let :pre_condition do
      'class { "apt":
        proxy => { "host" => "localhost" },
      }'
    end
    let :facts do
      {
        :lsbdistrelease  => '14.04',
        :lsbdistcodename => 'trusty',
        :operatingsystem => 'Ubuntu',
        :lsbdistid       => 'Ubuntu',
        :osfamily        => 'Debian',
        :puppetversion   => '3.5.0',
      }
    end
    let :params do
      {
        'options' => '',
        'package_manage' => true,
      }
    end
    let(:title) { 'ppa:foo' }
    it { is_expected.to contain_package('software-properties-common') }
    it { is_expected.to contain_exec('add-apt-repository-ppa:foo').that_notifies('Exec[apt_update]').with({
      :environment => ['http_proxy=http://localhost:8080'],
      :command     => '/usr/bin/add-apt-repository  ppa:foo',
      :unless      => '/usr/bin/test -s /etc/apt/sources.list.d/foo-trusty.list',
      :user        => 'root',
      :logoutput   => 'on_failure',
    })
    }
  end

  describe 'apt included, proxy host and port' do
    let :pre_condition do
      'class { "apt":
        proxy => { "host" => "localhost", "port" => 8180 },
      }'
    end
    let :facts do
      {
        :lsbdistrelease  => '14.04',
        :lsbdistcodename => 'trusty',
        :operatingsystem => 'Ubuntu',
        :lsbdistid       => 'Ubuntu',
        :osfamily        => 'Debian',
        :puppetversion   => '3.5.0',
      }
    end
    let :params do
      {
        :options => '',
        :package_manage => true,
      }
    end
    let(:title) { 'ppa:foo' }
    it { is_expected.to contain_package('software-properties-common') }
    it { is_expected.to contain_exec('add-apt-repository-ppa:foo').that_notifies('Exec[apt_update]').with({
      :environment => ['http_proxy=http://localhost:8180'],
      :command     => '/usr/bin/add-apt-repository  ppa:foo',
      :unless      => '/usr/bin/test -s /etc/apt/sources.list.d/foo-trusty.list',
      :user        => 'root',
      :logoutput   => 'on_failure',
    })
    }
  end

  describe 'apt included, proxy host and port and https' do
    let :pre_condition do
      'class { "apt":
        proxy => { "host" => "localhost", "port" => 8180, "https" => true },
      }'
    end
    let :facts do
      {
        :lsbdistrelease  => '14.04',
        :lsbdistcodename => 'trusty',
        :operatingsystem => 'Ubuntu',
        :lsbdistid       => 'Ubuntu',
        :osfamily        => 'Debian',
        :puppetversion   => '3.5.0',
      }
    end
    let :params do
      {
        :options => '',
        :package_manage => true,
      }
    end
    let(:title) { 'ppa:foo' }
    it { is_expected.to contain_package('software-properties-common') }
    it { is_expected.to contain_exec('add-apt-repository-ppa:foo').that_notifies('Exec[apt_update]').with({
      :environment => ['http_proxy=http://localhost:8180', 'https_proxy=https://localhost:8180'],
      :command     => '/usr/bin/add-apt-repository  ppa:foo',
      :unless      => '/usr/bin/test -s /etc/apt/sources.list.d/foo-trusty.list',
      :user        => 'root',
      :logoutput   => 'on_failure',
    })
    }
  end

  describe 'ensure absent' do
    let :pre_condition do
      'class { "apt": }'
    end
    let :facts do
      {
        :lsbdistrelease  => '14.04',
        :lsbdistcodename => 'trusty',
        :operatingsystem => 'Ubuntu',
        :lsbdistid       => 'Ubuntu',
        :osfamily        => 'Debian',
        :puppetversion   => '3.5.0',
      }
    end
    let(:title) { 'ppa:foo' }
    let :params do
      {
        :ensure => 'absent'
      }
    end
    it { is_expected.to contain_file('/etc/apt/sources.list.d/foo-trusty.list').that_notifies('Exec[apt_update]').with({
      :ensure => 'absent',
    })
    }
  end

  context 'validation' do
    describe 'no release' do
      let :facts do
        {
          :lsbdistrelease  => '14.04',
          :operatingsystem => 'Ubuntu',
          :lsbdistid       => 'Ubuntu',
          :osfamily        => 'Debian',
          :lsbdistcodeanme => nil,
          :puppetversion   => '3.5.0',
        }
      end
      let(:title) { 'ppa:foo' }
      it do
        expect {
          subject.call
        }.to raise_error(Puppet::Error, /lsbdistcodename fact not available: release parameter required/)
      end
    end

    describe 'not ubuntu' do
      let :facts do
        {
          :lsbdistrelease  => '6.0.7',
          :lsbdistcodename => 'wheezy',
          :operatingsystem => 'Debian',
          :lsbdistid       => 'debian',
          :osfamily        => 'Debian',
          :puppetversion   => '3.5.0',
        }
      end
      let(:title) { 'ppa:foo' }
      it do
        expect {
          subject.call
        }.to raise_error(Puppet::Error, /not currently supported on Debian/)
      end
    end
  end
end
