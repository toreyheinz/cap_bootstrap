# Cap Bootstrap

Capistrano tasks for deploying Rails applications using Ubuntu 10.04, rbenv, nginx, Unicorn and PostgreSQL. Based on the excellent Railscasts by Ryan Bates, with permission of course. If you are new to Capistrano or setting up a VPS, I highly recommend subscribing to his pro screencasts and watching the following:

* [Deploying to a VPS](http://railscasts.com/episodes/335-deploying-to-a-vps) (Pro)
* [Capistrano Tasks](http://railscasts.com/episodes/133-capistrano-tasks-revised) (Free)
* [Capistrano Recipes](http://railscasts.com/episodes/337-capistrano-recipes) (Pro)

I am not affiliated with Railscasts, I'm just a fan.

## Requirements

* Capistrano
* Fresh Ubuntu 10.04 or 11.10 install

### Ubuntu Setup
#### Building a clean VPS
Before you run any of the scripts below, you need to ensure that your VPS is property prepared.  On Linode this means rebuilding the VPS (from their web based management console) and setting a root password.

#### Creating a deployer user
The scripts in cap_bootstrap connect to your VPS as 'deployer' and then sudo when needed.  Since a 'deployer' user does not exist by default, we need to create one.

    ssh root@xxx.xxx.xxx.xxx
    adduser deployer --ingroup admin

set a password and just press ENTER to use default values for other inputs.

#### Setting up SSH keys
You can avoid a lot of (annoying) typing of the deployer users password by setting up SSH keys.  Assuming you already have them setup (for github, etc), you can copy them over by:

    ssh deployer@178.xxx.xxx.xxx
    mkdir ~/.ssh
    chmod 700 ~/.ssh
    cat ~/.ssh/id_rsa.pub | ssh deployer@178.xxx.xxx.xxx 'cat >> ~/.ssh/authorized_keys'
    chmod 600 ~/.ssh/authorized_keys

To test that this worked, disconnect and then try

    ssh deployer@178.xxx.xxx.xxx

you should connect without being asked for a password.

## Installation

Add these lines to your application's Gemfile:

    gem 'capistrano'
    gem 'cap_bootstrap'

And then execute:

    $ bundle

## Usage

Setup a new Ubuntu 10.04 slice. Add a user called deployer with sudo privileges.

In your project, run the following:

    capify .

Then run this generator with an optional IP address to copy over a deploy.rb that is more suited to this gem.
The application name defaults to the same name as your rails app and the repository is pulled from your .git/config.

    rails g cap_bootstrap:install 99.99.99.99

Double check the settings in config/deploy.rb.  If there are certain recipes you don't want to run (for example, you'd prefer to configure the firewall yourself), then just comment out the calls invoking those recipes in deploy.rb.

To do a complete install and setup of packages, run

	cap deploy:all

This is generally what you will do for a new VPS that you are using for the first time.

To only do installation of software:

	cap deploy:install

To only do setup/configuration of software:

	cap deploy:setup

After installation and setup are complete

    cap deploy:cold

## Advanced Options

Shown below are the default advanced settings, but they can overridden.

### Setup

    set(:domain) { "#{application}.com" }

### PostgreSQL

    set :postgresql_host, "localhost"
    set(:postgresql_user) { application }
    set(:postgresql_database) { "#{application}_production" }

### MySQL
	set :mysql_host, "localhost"
	set(:mysql_user) { application }
	set(:mysql_database) { "#{application}_production" }

	set(:mysql_password) { Capistrano::CLI.password_prompt "MySQL Password: " }
	set(:mysql_root_password) { Capistrano::CLI.password_prompt "ROOT MySQL Password: " }

### Ruby

    set :ruby_version, "1.9.3-p125"
    set :rbenv_bootstrap, "bootstrap-ubuntu-10-04" # Or bootstrap-ubuntu-11-10

### Unicorn

    set(:unicorn_user) { user }
    set(:unicorn_pid) { "#{current_path}/tmp/pids/unicorn.pid" }
    set(:unicorn_config) { "#{shared_path}/config/unicorn.rb" }
    set(:unicorn_log) { "#{shared_path}/log/unicorn.log" }
    set :unicorn_workers, 2

## Future Plans

Version 0.1 uses Ryan's recipes pulled directly from Railscast episode #337 Capistrano Recipes. You will always be able to access this version
with tag v0.1.

Future versions will incorporate optional installs such as MySQL, Apache, Phusion Passenger and additional server config such as setting a hostname.
Also considering changes to allow deploying multiple apps onto a single server and provisioning Linode slices using their api.

## Alternatives

* [Chef](http://www.opscode.com/chef/)
* [Puppet](http://puppetlabs.com/)
* [deprec](http://deprec.org/)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

