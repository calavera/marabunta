Marabunta
---------

Large scale cloud nodes distribution and deployment using Bittorrent, Capistrano and Libvirt.

How it works
------------

Marabunta relies on Murder, http://github.com/lg/murder, to distribute
the virtual disks to the cloud nodes and uses the Libvirt api to deploy
and start the images once they are distributed.

Currently Marabunta just supports deployments on Kvm but it can support as many hypervisors
as Libvirt supports.

Configuration
-------------

The most simple way to use Marabunta is setting the deployment strategy
to `:marabunta`. It also requires to set the name of the `:hypervisor`.

There are some deployment configuration templates into the directory `examples`.

Marabunta can also be used without the deployment strategy. Follow the
steps that Murder requires for the manual usage and then run the
marabunta deploy task:

  $ cap marabunta:deploy tag="MURDER_TAG_NAME"

Copyright
---------

Copyright (c) 2010 David Calavera<calavera@apache.org>. See LICENSE for details.
