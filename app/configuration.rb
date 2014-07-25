require 'singleton'
require 'yaml'
module Goodluck
  class Configuration
    include Singleton

    def deployment
      @deployment ||= YAML.load_file("#{config_path}/deployment.yml")
    end

    private
    def config_path
      File.join(File.dirname(__FILE__), '../config')
    end
  end
end
