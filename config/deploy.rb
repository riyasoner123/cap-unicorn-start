# config valid for current version and patch releases of Capistrano
lock "~> 3.18.1"

set :application, "cap-unicorn-start"
set :repo_url, "git@github.com:riyasoner123/cap-unicorn-start.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure



set :branch, `git rev-parse --abbrev-ref HEAD`.chomp


set :deploy_to, "/home/dev/PROJECT/demo"
set :keep_releases, 5
set :nvm_type, :user
set :nvm_node, 'v18.19.0'
set :nvm_map_bins, %w{node npm yarn}
set :rvm_type, :user
set :rvm_ruby_version, '3.0.0'
set :bundle_binstubs, true
set :local_user, -> { `git config user.name`.chomp }
set :unicorn_pid, "#{shared_path}/tmp/pids/unicorn.pid"

append :linked_files, "config/database.yml" , 'config/secrets.yml' ,'config/unicorn.rb'
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor/bundle", "storage"


after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
  task :restart do
    on roles(:app) do
      if test("[ ! -f #{fetch(:unicorn_pid)} ] || ! kill -0 $( cat #{fetch(:unicorn_pid)} )")
        # If Unicorn is not running or the pid file does not exist, start Unicorn
        invoke 'unicorn:start'
      else
        # If Unicorn is running, restart it
        invoke 'unicorn:restart'
      end
    end
  end
end
