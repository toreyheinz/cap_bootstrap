require "bundler/capistrano"
require "cap_bootstrap/capistrano"

server "<%= ip %>", :web, :app, :db, primary: true

set :user, "deployer"
set :application, "<%= application %>"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false
set :scm, "git"
set :repository, "<%= git_url %>"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do

  desc "Install and setup everything"
  task :all do
    install
    setup
  end

  desc "Install everything onto the server"
  task :install do
    base
    nginx::install
    postgresql::install
    # mysql::install
    nodejs::install
    rbenv::install
    security::setup_firewall
  end

  desc "complete setup of all packages"
  task :setup do
    nginx::setup
    postgresql::create_database
    postgresql::setup
    # mysql::setup
    unicorn::setup
  end
end

after "deploy:finalize_update", "postgresql:symlink"
# after "deploy:finalize_update", "mysql:symlink"
