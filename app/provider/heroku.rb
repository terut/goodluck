require 'base64'
require 'json'
require 'celluloid'
require 'provider/base'
require 'github'
require 'notifier'

module Goodluck
  module Provider
    class Heroku < Base
      include Celluloid

      attr_accessor :notifier, :app_name
      
      def initialize(payload)
        super  
        @notifier = HipChatNotifier.new(payload.repo_with_owner,
                                     payload.app_url,
                                     payload.environment)
        @app_name = payload.extension['app_name']
      end

      def deploy
        github = Github.new
        url = github.archive_link(payload.ref, payload.repo_with_owner)
        async.build(url)
      end

      private
      def build(archive_link, sha = nil)
        response = http.post do |req|
          req.url build_url
          body = {
            :source_blob => {
              :url     => archive_link,
              :version => sha
            }
          }
          req.body = JSON.dump(body)
        end    

        if response.success?
          body   = JSON.parse(response.body)
          notifier.pending
          build_status_observer(body['id'])

          return true
        else
          notifier.failure
        end

        false 
      end

      # status: failed, succeeded, pending
      def build_status_observer(id)
        completed = false

        until completed do
          sleep 10
          response = http.get do |req|
            req.url build_status_url(id)
          end  

          body = JSON.parse(response.body)
          if body["status"] == "succeeded"
            completed = true
            notifier.success
          elsif body["status"] == "failed"
            completed = true
            notifier.failure
          end
        end
      end

      def build_url
        "/apps/#{app_name}/builds"
      end

      def build_status_url(id)
        "/apps/#{app_name}/builds/#{id}"
      end

      def http_options
        {
          :url     => "https://api.heroku.com",
          :headers => {
            "Accept"        => "application/vnd.heroku+json; version=3",
            "Content-Type"  => "application/json",
            "Authorization" => Base64.encode64(":#{ENV['HEROKU_API_KEY']}")
          }
        }
      end

      def http
        @http ||= Faraday.new(http_options) do |faraday|
          faraday.request  :url_encoded
          faraday.response :logger
          faraday.adapter  Faraday.default_adapter
        end
      end
    end
  end
end
