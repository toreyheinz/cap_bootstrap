# apt-get -y install mysql-server mysql-client libmysqlclient-dev
# mysql -u root -p
# create database blog_production;
# grant all on blog_production.* to blog@localhost identified by 'secret';
# exit

Capistrano::Configuration.instance(:must_exist).load do

  set_default(:mysql_host, "localhost")
  set_default(:mysql_root_password) { Capistrano::CLI.password_prompt "ROOT MySQL Password: " }
  set_default(:mysql_user) { application }
  set_default(:mysql_password) { Capistrano::CLI.password_prompt "MySQL Password: " }
  set_default(:mysql_database) { "#{application}_production" }

  namespace :mysql do
    desc "Install the latest stable release of MySQL."
    task :install, roles: :db, only: {primary: true} do
      get_packages
      set_root_password
    end

    desc "download and install MySQL packages"
    task :get_packages, roles: :db, only: {primary: true} do
      run "#{sudo} DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server mysql-client libmysqlclient-dev"
    end

    desc "Set MySQL root password"
    task :set_root_password, roles: :db, only: {primary: true} do
      run %Q{mysql --user=root --execute="UPDATE mysql.user SET Password = PASSWORD('#{mysql_root_password}') WHERE User = 'root'; FLUSH PRIVILEGES;"}
    end


    desc "Peformm application specific setup."
    task :setup, roles: :db, only: {primary: true} do
      create_database_and_user
      generate_database_yml
    end

    desc "Create a database and userfor this application."
    task :create_database_and_user, roles: :db, only: {primary: true} do
      run %Q{mysql --user=root --password=#{mysql_root_password} --execute="drop database if exists #{mysql_database}"}
      run %Q{mysql --user=root --password=#{mysql_root_password} --execute="create database #{mysql_database}"}
      run %Q{mysql --user=root --password=#{mysql_root_password} --execute="grant all on #{mysql_database}.* to '#{mysql_user}'@'localhost' identified by '#{mysql_password}'"}
    end

    desc "Generate the database.yml configuration file."
    task :generate_database_yml, roles: :app do
      run "mkdir -p #{shared_path}/config"
      template "mysql.yml.erb", "#{shared_path}/config/database.yml"
    end

    desc "Symlink the database.yml file into latest release"
    task :symlink, roles: :app do
      run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    end
  end

end
