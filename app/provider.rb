require 'provider/heroku'
module Goodluck
  module Provider
    class << self 
      def build(payload)
        case payload.provider
        when "heroku"
          Heroku.new(payload)
        else
          raise NotSupportedProvider, "Provider #{payload.provider} is not supported."
        end
      end
    end

    class NotSupportedProvider < StandardError; end
  end
end
