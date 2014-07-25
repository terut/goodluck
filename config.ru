$:.unshift File.dirname(__FILE__)
$:.unshift File.join(File.dirname(__FILE__),'app')

require 'bundler'
Bundler.require(:default)
#require File.expand_path('../server.rb', __FILE__)
require 'server.rb'

run Goodluck::Server
