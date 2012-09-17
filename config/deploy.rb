require 'bundler/capistrano'
require 'rvm/capistrano'

set :rvm_ruby_string, 'ruby-1.9.3-p194'
default_run_options[:pty] = true

set :user, 'deploy'
set :domain, 'the-treasury.net'
set :application, "wtfswp"
set :deploy_to, "/var/www/apps/wtfswp"
set :deploy_via, "export"
set :use_sudo, false

set :scm, :git
set :repository,  "ssh://git@github.com/gjacobrobertson/wtfswp.git"
set :git_enable_submodules, 1 # if you have vendored rails
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true

role :web, domain                         # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
