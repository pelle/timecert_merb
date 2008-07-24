#!/usr/bin/env ruby
require 'rubygems'
gem 'merb-core'
require 'merb-core' 
 
Merb::Config.setup(:merb_root   => ".", 
                   :environment => ENV['MERB_ENV']||'production') 
Merb.environment = Merb::Config[:environment] 
Merb.root = Merb::Config[:merb_root] 
Merb::BootLoader.run 

Statistic.update_stats