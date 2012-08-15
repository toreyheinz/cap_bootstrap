Capistrano::Configuration.instance(:must_exist).load do
  namespace :nodejs do
    desc "Install the latest relase of Node.js"
    task :install, roles: :app do
      # run "#{sudo} add-apt-repository ppa:chris-lea/node.js"
      run "#{sudo} add-apt-repository ppa:chris-lea/node.js",:pty => true do |ch, stream, data|
        ch.send_data("\n") if data =~ /Press.\[ENTER\].to.continue/
      end
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install nodejs"
    end
  end
end
