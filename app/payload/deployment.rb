require 'payload/base'
module Goodluck
  module Payload
    class Deployment < Base
      attr_accessor :ref, :repo_with_owner, :provider, :app_url, :environment, :extension
      def initialize(delivery_id, payload)
        super
        @ref = payload['ref']
        @repo_with_owner = payload['name']
        @environment = payload['environment']
        @app_url = payload['payload']['url']
        @provider = payload['payload']['provider']
        @extension = payload['payload']['extension_payload']
      end

      private
      def auto_deploy
        true
      end
    end
  end
end
