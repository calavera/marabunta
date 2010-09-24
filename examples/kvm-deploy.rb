require 'marabunta'

set :user, 'marabunta'

set :scm, :none
set :repository, '/tmp/disks'

#
# MURDER CONFIGURATION
#
set :remote_murder_path, '/var/lib/murder'
after 'deploy:setup', 'murder:distribute_files'

before 'murder:start_seeding', 'murder:start_tracker'
after 'murder:stop_seeding', 'murder:stop_tracker'

role :peers, 'localhost', '10.60.1.76'
role :seeder, 'localhost'
role :tracker, 'localhost'

set :default_destination_path, '/var/lib/virt'
set :default_seeder_files_path, '/tmp/disks'

#
# MARABUNTA CONFIGURATION
#
set :deploy_via, :marabunta
set :hypervisor, 'Kvm'
