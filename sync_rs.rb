#!/usr/bin/ruby

# rsync's current directory to your VM
#
# You must set CLOUD_KEY in you environment to point to your
# private SSH key file.
#
# Your VM must have the corresponding public SSH key in the
# ~/.ssh/authorized_keys file.
#
# RightScale can place your public key on the VM at boot if you
# set up your public key in the Dashboard with the 
# "Use the credentials stored on my computer" option under
# Settings > User Settings > SSH.
#

host = ARGV[0] 
path = ARGV[1]
raise "Usage: sync_to <host_ip> <dst_path>" unless host && path

SSH_KEY_PATH = ENV["CLOUD_KEY"]

puts "Syncing to #{host}..."

opts = "-avz --exclude=.git -e 'ssh -i #{SSH_KEY_PATH}'"
cmd = "rsync #{opts} . root@#{host}:#{path}"
puts "Command: #{cmd}"
puts `#{cmd}`
