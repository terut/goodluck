require 'payload'
require 'provider'
module Goodluck
  class Receiver
    attr_accessor :payload

    def initialize(event, delivery_id, payload)
      @payload = Payload.build(event, delivery_id, payload)
    end

    def run
      # TODO check
      return unless payload.auto_deploy?

      provider = Provider.build(payload)
      provider.deploy
    end
  end
end
