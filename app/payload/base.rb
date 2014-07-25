require 'configuration'
module Goodluck
  module Payload
    class Base
      attr_accessor :delivery_id, :raw

      def initialize(delivery_id, payload)
        @delivery_id = delivery_id
        @raw = payload
      end

      def type
        self.class.name
      end

      def auto_deploy?
        !!auto_deploy
      end

      def ref
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def repo_with_owner
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def app_url
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def provider
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def environment
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def extension
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      private
      def auto_deploy
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end
    end

    class NullPayload < Base
      attr_accessor :ref, :repo_with_owner, :app_url, :provider, :environment, :extension
      private
      def auto_deploy
        false
      end
    end
  end
end
