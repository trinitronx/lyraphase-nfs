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

describe 'lyraphase-nfs::exports' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'includes nfs::server4 recipe' do
      expect(chef_run).to include_recipe 'nfs::server4'
    end

    it 'creates /export directory' do
      expect(chef_run).to create_directory('/export').with_user('root')
    end

    it 'converges successfully' do
      expect{chef_run}.to_not raise_error
    end
  end

  context "when list of exports given" do
    nfs_exports = [
        {'path' => '/export', 'network' => '192.168.1.100/24', 'writeable' => true, 'sync' => true, 'options' => ['fsid=0','insecure','no_subtree_check'] },
        {'path' => '/export/src-test-nfsv4', 'src_path' => '/home/trinitronx/src', 'network' => '192.168.1.100/24', 'writeable' => true, 'sync' => true, 'options' => ['nohide','insecure','no_subtree_check'] }
    ]

    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new

      runner.node.set['lyraphase-nfs']['nfs_exports'] = nfs_exports
      runner.converge(described_recipe)
    end

    it 'includes nfs::server4 recipe' do
      expect(chef_run).to include_recipe 'nfs::server4'
    end

    it 'creates /export directory' do
      expect(chef_run).to create_directory('/export').with_user('root')
    end

    nfs_exports.each do |export|
      if export.has_key? 'src_path'
        it "bind mounts path #{export['src_path']} into #{export['path']}" do
          expect(chef_run).to mount_mount(export['path']).with(device: export['src_path'], pass: 0, dump: 0, fstype: 'none', options: 'bind' )
          expect(chef_run).to enable_mount(export['path']).with(device: export['src_path'], pass: 0, dump: 0, fstype: 'none', options: 'bind' )
        end
      end

      it "installs export #{export['path']}" do
        expect(chef_run).to create_nfs_export(export['path'])
      end
    end
  
  end
end
