require 'securerandom'

Capistrano::Configuration.instance(:must_exist).load do
  namespace :security do
    namespace :install do
    desc "Install and configure a firewall with UFW"
      task :firewall, roles: :web do
        run "#{sudo} apt-get -y install ufw"
        run "#{sudo} ufw default deny"
        run "#{sudo} ufw allow 22/tcp"
        run "#{sudo} ufw allow 80/tcp"
        run "#{sudo} ufw allow 443/tcp"
        run "#{sudo} ufw --force enable"
      end
    end

    namespace :setup do
      desc "Create a secret_token file if one doesn't exist"
      task :secret_token, roles: :web do
        secret_token_path = "#{shared_path}/config/secret_token.rb"
        unless remote_file_exists?(secret_token_path)
          template "secret_token.erb", secret_token_path
        end
      end

      desc "Symlink the secret token into the new release"
      task :symlink, roles: :web do
        run "ln -nfs #{shared_path}/config/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
      end
    end
  end
end