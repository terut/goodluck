require 'payload/base'
module Goodluck
  module Payload
    class Deployment < Base
      attr_accessor :ref, :repo_with_owner, :provider, :app_url, :environment, :extension
      def initialize(delivery_id, payload)
        super
        @ref = payload['deployment']['ref']
        @repo_with_owner = payload['repository']['full_name']
        @environment = payload['deployment']['environment']
        @app_url = payload['deployment']['payload']['url']
        @provider = payload['deployment']['payload']['provider']
        @extension = payload['deployment']['payload']['extension_payload']
      end

      private
      def auto_deploy
        true
      end
    end
  end
end
