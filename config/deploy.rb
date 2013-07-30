# Rbenv tasks
require "capistrano-rbenv"
set :rbenv_ruby_version, "1.9.3-p392"

# Bundler tasks
require 'bundler/capistrano'



set :application, "sincapun"
set :repository,  "git@github.com:jingta/sincapun.git"
set :scm, :git

# do not use sudo
#set :use_sudo, false
#set(:run_method) { use_sudo ? :sudo : :run }
# This is needed to correctly handle sudo password prompt
#default_run_options[:pty] = true

set :user, "ubuntu"
set :group, user
set :runner, user

set :host, "#{user}@stegos"

role :web, host
role :app, host
#role :db,  host, :primary => true


set :rails_env, :production

# Where will it be located on a server?
set :deploy_to, "/apps/#{application}"
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

# Unicorn control tasks
namespace :deploy do
  task :restart do
    run "if [ -f #{unicorn_pid} ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D; fi"
  end
  task :start do
    run "cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D"
  end
  task :stop do
    run "if [ -f #{unicorn_pid} ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end
end

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"
