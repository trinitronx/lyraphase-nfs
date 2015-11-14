lyraphase-nfs cookbook
======================
[![Build Status](http://img.shields.io/travis/trinitronx/lyraphase-nfs.svg)](https://travis-ci.org/trinitronx/lyraphase-nfs)
[![Gittip](http://img.shields.io/gittip/trinitronx.svg)](https://www.gittip.com/trinitronx)

A cookbook for managing NFSv4 bind mounts and exports.

# Requirements

 - [nfs][1] cookbook

# Usage

Create a role for your `nfs_server` host that includes a list of NFS exports file entries.
Note: for NFSv4, you must have a "root" `/export` path with `fsid=0` first, then bind mount other dirs under here for export.

From the [Ubuntu NFSv4 Howto][3]:

NFSv4 exports exist in a single pseudo filesystem, where the real directories are mounted with the `--bind` option.

```ruby
name "nfs_server"
description "Role applied to the system that should be an NFS server."
override_attributes(
  "lyraphase-nfs" => {
    "nfs_exports" => [
        {'path' => '/export', 'network' => '192.168.1.1/24', 'writeable' => true, 'sync' => true, 'options' => ['fsid=0','insecure','no_subtree_check'] },
        {'path' => '/export/src-test-nfsv4', 'src_path' => '/home/trinitronx/src', 'network' => '192.168.1.1/24', 'writeable' => true, 'sync' => true, 'options' => ['nohide','insecure','no_subtree_check'] }
    ]
  }
)
run_list [ "lyraphase-nfs::exports" ]
```

# Attributes

  - `node['lyraphase-nfs']['nfs_exports']`: An Array of hashes containing NFS exports file entries.  See Usage above for expected format.

# Recipes

## lyraphase-nfs::default

Includes the `nfs::client4` recipe to install the `idmap` service for an effective protocol level of NFSv4

## lyraphase-nfs::exports

Includes the `nfs::server4` recipe to install the NFS server platform-specific services for an effective protocol level of NFSv4.

Creates a top-level NFS root dir: `/export`, then creates bind mounts for any `src_path` entries found in the `nfs_exports` Array of Hashes.
Finally, `nfs_exports` entries are added to `/etc/exports`.

# Author

Author:: James Cuzella (@trinitronx)

[1]: https://supermarket.chef.io/cookbooks/nfs
[2]: https://supermarket.chef.io/cookbooks/nfs#readme
[3]: https://help.ubuntu.com/community/NFSv4Howto
