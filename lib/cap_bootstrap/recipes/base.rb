Capistrano::Configuration.instance(:must_exist).load do
  def template(from, to)
    template_path = File.expand_path("../templates/#{from}", __FILE__)
    custom_path   = File.expand_path("config/deploy/templates/#{from}") 
    template_path = custom_path if File.exist?(custom_path)
    erb = File.read(template_path)
    put ERB.new(erb).result(binding), to
  end

  def set_default(name, *args, &block)
    set(name, *args, &block) unless exists?(name)
  end

  def remote_file_exists?(full_path)
    'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
  end
  
  namespace :deploy do
    namespace :base do

      desc "Initial preparation for installation"
      task :install do
        run "#{sudo} bash -c 'echo UTC > /etc/timezone'"
        run "#{sudo} cp /usr/share/zoneinfo/UTC /etc/localtime"
        run "#{sudo} dpkg-reconfigure -f noninteractive tzdata"
        run "#{sudo} apt-get -y update"
        run "#{sudo} apt-get -y install curl git-core python-software-properties"
      end

      desc "Initial preparation for configuring software"
      task :configure do
        run "mkdir -p #{shared_path}/config"
      end
    end
  end
end
