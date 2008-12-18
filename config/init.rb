# Go to http://wiki.merbivore.com/pages/init-rb
 
require 'config/dependencies.rb'
 
use_orm :datamapper
use_test :rspec
use_template_engine :haml
 
Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper
  
  # cookie session store configuration
  c[:session_secret_key]  = '7b3a7e4bf46f8d6db7f80e729899dab9a25f7d33'
  c[:session_id_key] = '_timecert_session_id' # cookie session id key, defaults to "_session_id"
end
 
Merb::BootLoader.before_app_loads do
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.
end
 
Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
end

Merb.add_mime_type(:csv, :to_csv, %w[text/csv], :charset => "utf-8")
Merb.add_mime_type(:time, :to_text, %w[text/plain], :charset => "utf-8")
Merb.add_mime_type(:ini, :to_ini, %w[text/plain], :charset => "utf-8")
Merb.add_mime_type(:iframe, :to_html, %w[text/iframe], :charset => "utf-8") 
Merb.add_mime_type(:yml, :to_yaml, %w[application/x-yaml text/yaml], :charset => "utf-8")

