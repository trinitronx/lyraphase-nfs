name 'lyraphase-nfs'
maintainer 'James Cuzella'
maintainer_email 'james.cuzella@lyraphase.com'
license 'gplv3'
description 'Installs/Configures NFS and /etc/exports'
long_description 'Installs/Configures NFS and /etc/exports for lyraphase NFS server'
version '0.1.0'

depends 'nfs'

recipe 'lyraphase-nfs::default', 'Installs NFS via nfs cookbook'
recipe 'lyraphase-nfs::exports', 'Installs/Configures /etc/exports'
