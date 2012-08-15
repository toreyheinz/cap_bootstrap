Capistrano::Configuration.instance(:must_exist).load do
  namespace :nginx do
    desc "Install latest stable release of nginx"
    task :install, roles: :web do
      #run "#{sudo} add-apt-repository ppa:nginx/stable"
      run "#{sudo} add-apt-repository ppa:nginx/stable",:pty => true do |ch, stream, data|
        ch.send_data("\n") if data =~ /Press.\[ENTER\].to.continue/
      end
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install nginx"
    end

    desc "Setup nginx configuration for this application"
    task :setup, roles: :web do
      template "nginx_unicorn.erb", "/tmp/nginx_conf"
      run "#{sudo} mv /tmp/nginx_conf /etc/nginx/sites-enabled/#{application}"
      run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
      restart
    end
  
    %w[start stop restart].each do |command|
      desc "#{command} nginx"
      task command, roles: :web do
        run "#{sudo} service nginx #{command}"
      end
    end
  end
end
