Marabunta
---------

Large scale cloud nodes distribution and deployment using Bittorrent, Capistrano and Libvirt.

![The naked jungle](http://dl.dropbox.com/u/6838328/51tHMdGsdAL._SS400_.jpg)

How it works
------------

Marabunta relies on Murder, http://github.com/lg/murder, to distribute
the virtual disks to the cloud nodes and uses the Libvirt api via Virtuoso to deploy
and start the images once they are in the target machines.

Currently Marabunta supports deployments on Kvm and Virtualbox but it can support as many hypervisors
as Libvirt supports.

Configuration
-------------

There are some deployment configuration templates into the directory `examples`.

Installation
------------

<pre>
  $ gem install marabunta
</pre>

Usage
-----

Run it from the command line with the operation to execute. By default it
takes the configuration file `Leiningen` if it exists into the directory:

<pre>
  $ marabunta setup
  $ marabunta deploy
</pre>

Another configuration file can also be specified as a command argument:

<pre>
  $ marabunta setup config_file
  $ marabunta deploy config_file
</pre>

Copyright
---------

Copyright (c) 2011 David Calavera<calavera@apache.org>. See LICENSE for details.
