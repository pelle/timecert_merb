# config/deploy.rb 

set :application, "timecert"
 
set :adapter, 'ebb' # or 'thin' 
set :start_port, 4000 
set :processes, 2
set :log_path, "#{shared_path}/log/production.log"  

default_run_options[:pty] = true
set :repository,  "git@github.com:pelle/timecert.git"
set :scm, "git"
#set :scm_passphrase, "p00p" #This is your custom users password
set :user, "deployer"
set :branch, "origin/master"

role :app, "timecert"
role :web, "timecert"
role :db, "timecert", :primary => true

namespace :deploy do 
 desc "Start Merb Instances"  
  task :start do 
    run "merb -a #{adapter} -e production -c #{processes} --port #{start_port} -m #{current_path} -L #{log_path}"  
  end 
 
  desc "Stop Merb Instances"  
  task :stop do 
    run "cd #{current_path} && merb -a #{adapter} -k all"  
  end 
 
  desc 'Custom restart task for Merb' 
  task :restart, :roles => :app do 
    deploy.stop 
    deploy.start 
  end 
end