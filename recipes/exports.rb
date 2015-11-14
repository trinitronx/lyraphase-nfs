#
# Cookbook Name:: lyraphase-nfs
# Recipe:: exports
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

include_recipe 'nfs::server4'

directory '/export' do
  owner 'root'
  group 'root'
  mode  '0755'
end

unless node['lyraphase-nfs']['nfs_exports'].nil? || node['lyraphase-nfs']['nfs_exports'].empty?
  node['lyraphase-nfs']['nfs_exports'].each do |export|
    if export.has_key? 'src_path'
      mount export['path'] do
        device export['src_path']
        fstype 'none'
        pass 0
        dump 0
        options 'bind'
        action [:mount, :enable]
      end
    end

    nfs_export export['path'] do
      network   export['network']   if export.has_key? 'network'
      writeable export['writeable'] if export.has_key? 'writeable'
      sync      export['sync']      if export.has_key? 'sync'
      anonuser  export['anonuser']  if export.has_key? 'anonuser'
      anongroup export['anongroup'] if export.has_key? 'anongroup'
      options   export['options']   if export.has_key? 'options'
      action :create
    end
  end
end
