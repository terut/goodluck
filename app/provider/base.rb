module Goodluck
  module Provider
    class Base
      attr_accessor :payload

      def initialize(payload)
        @payload = payload
      end

      def notifier
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def deploy
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end
    end
  end
end
