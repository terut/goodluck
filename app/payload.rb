require 'json'
require 'payload/push'
require 'payload/deployment'
module Goodluck
  module Payload
    class << self
      def build(event, delivery_id, payload)
        payload = JSON.parse(payload)
        case event
        when 'push'
          Push.new(delivery_id, payload)
        when 'deployment'
          Deployment.new(delivery_id, payload)
        else
          raise NotSupportedPayload, "Payload of #{event} event is not supported."
        end
      end
    end

    class NotSupportedPayload < StandardError; end
  end
end
