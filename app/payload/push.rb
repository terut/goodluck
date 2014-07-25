require 'configuration'
require 'payload/base'
module Goodluck
  module Payload
    class Push < Base
      attr_accessor :ref, :repo_with_owner, :deleted
      def initialize(delivery_id, payload)
        super

        ref = payload['ref'].dup
        ref.slice!('refs/heads/') if ref.start_with?('refs/heads/')
        @ref = ref

        owner = payload['repository']['owner']['name']
        repo = payload['repository']['name']
        @repo_with_owner = "#{owner}/#{repo}"

        @deleted = payload['deleted']
      end

      def app_url
        config['url']
      end

      def provider
        config['provider']
      end

      def environment
        extension['environment']
      end

      def extension
        config['extension_payload']
      end

      private
      def auto_deploy
        config['auto_deploy'] && !deleted
      end

      def config
        @config ||= Configuration.instance.deployment[repo_with_owner][ref] || {}
      end
    end
  end
end
