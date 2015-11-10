#
# Cookbook Name:: lyraphase-nfs
# Spec:: default
#
# Copyright (C) 2015  James Cuzella
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


require 'spec_helper'

describe 'lyraphase-nfs::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end

  [
    {platform: 'ubuntu', version: '14.04',   packages: ['nfs-common', 'rpcbind'], services: ['portmap', 'statd']},
    {platform: 'ubuntu', version: '12.04',   packages: ['nfs-common', 'rpcbind'], services: ['rpcbind-boot', 'statd']},
    {platform: 'ubuntu', version: '10.04',   packages: ['nfs-common', 'rpcbind'], services: ['rpcbind', 'statd']},
    {platform: 'debian', version: '6.0.5',   packages: ['nfs-common', 'portmap'], services: ['nfs-common', 'portmap']},
    {platform: 'debian', version: '7.2',     packages: ['nfs-common', 'rpcbind'], services: ['nfs-common', 'rpcbind']},
    {platform: 'amazon', version: '2014.09', packages: ['nfs-utils',  'rpcbind'], services: ['portmap', 'nfslock']},
    {platform: 'centos', version: '6.5',     packages: ['nfs-utils',  'rpcbind'], services: ['portmap', 'nfslock']},
    {platform: 'centos', version: '5.9',     packages: ['nfs-utils',  'portmap'], services: ['portmap', 'nfslock']}
  ].each |os| do
    context "on #{os.platform.capitalize} #{os.version}" do
      let(:chef_run) do
        ChefSpec::ServerRunner.new(os).converge(described_recipe)
      end
  
      os.packages.each do |pkg|
        it "installs package #{pkg}" do
          expect(chef_run).to install_package(pkg)
        end
      end
  
      os.services.each do |svc|
        it "starts the #{svc} service" do
          expect(chef_run).to start_service(svc)
        end
  
        it "enables the #{svc} service" do
          expect(chef_run).to enable_service(svc)
        end
      end
    end
  end

end
