Capistrano::Configuration.instance(:must_exist).load do
  namespace :mongodb do
    desc "Install the latest relase of MongoDB"
    task :install, roles: :app do
      run "#{sudo} sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10" do |ch, stream, data|
        ch.send_data("\n") if data =~ /Press.\[ENTER\].to.continue/
      end
      put "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen", "/tmp/mongodb_sources"
      run "#{sudo} mv /tmp/mongodb_sources /etc/apt/sources.list.d/10gen.list"
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install mongodb-10gen"
    end

    %w[start stop restart].each do |command|
      desc "#{command} nginx"
      task command, roles: :web do
        run "#{sudo} service nginx #{command}"
      end
    end
  end
end
