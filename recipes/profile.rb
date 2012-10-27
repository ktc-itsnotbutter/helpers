#
# Cookbook Name:: helpers
# Recipe:: default
#

include_recipe "chef_handler"

# Install `chef-handler-elapsed-time` gem during the compile phase
chef_gem "chef-handler-elapsed-time"

# load the gem here so it gets added to the $LOAD_PATH, otherwise chef_handler
# will fail.
require 'chef/handler/elapsed_time'

# Activate the handler immediately during compile phase
chef_handler "Chef::Handler::ElapsedTime" do
  source "chef/handler/elapsed_time"
  action :nothing
end.run_action(:enable)


