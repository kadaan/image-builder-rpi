require 'spec_helper'

describe package('docker-engine') do
  it { should_not be_installed }
end

describe package('docker-ce') do
  it { should be_installed }
end

describe package('docker-ce-cli') do
  it { should be_installed }
end

describe command('dpkg -l docker-ce') do
  its(:stdout) { should match /ii  docker-ce/ }
  its(:stdout) { should match /19.03.0~1.2.beta3-0~raspbian-stretch/ }
  its(:stdout) { should match /armhf/ }
  its(:exit_status) { should eq 0 }
end

describe file('/usr/bin/docker') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end


describe package('containerd.io') do
  it { should be_installed }
end

describe file('/usr/bin/containerd') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file('/usr/bin/ctr') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file('/usr/sbin/runc') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file('/lib/systemd/system/docker.socket') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
end

describe file('/var/run/docker.sock') do
  it { should be_socket }
  it { should be_mode 660 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'docker' }
end

describe file('/etc/default/docker') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
end

describe file('/var/lib/docker') do
  it { should be_directory }
  it { should be_mode 711 }
  it { should be_owned_by 'root' }
end

describe file('/var/lib/docker/overlay2') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'root' }
end

describe file('/etc/bash_completion.d/docker') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_file }
end

describe command('docker -v') do
  its(:stdout) { should match /Docker version 19.03.0-beta3, build/ }
  its(:exit_status) { should eq 0 }
end

describe command('docker version') do
  its(:stdout) { should match /Client:. Version:           19.03.0-beta3. API version:       1.40/m }
  its(:stdout) { should match /Server:. Engine:.  Version:          19.03.0-beta3.  API version:      1.40/m }
  its(:exit_status) { should eq 0 }
end

describe command('docker info') do
  its(:stdout) { should match /Storage Driver: overlay2/ }
  its(:exit_status) { should eq 0 }
end

describe interface('lo') do
  it { should exist }
end

describe interface('docker0') do
  it { should exist }
end

describe service('docker') do
  # it { should be_enabled }
  it { should be_running }
end

describe command('grep docker /var/log/syslog') do
  its(:stdout) { should match /Daemon has completed initialization/ }
  its(:exit_status) { should eq 0 }
end
