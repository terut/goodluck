require 'hipchat'
require 'faraday'

module Goodluck
  class Notifier
    attr_accessor :repo, :url, :environment

    def self.build(repo, url, environment)
      case ENV["NOTIFIER"]
      when "slack"
        SlackNotifier.new(repo, url, environment)
      when "hipchat"
        HipChatNotifier.new(repo, url, environment)
      else
        NullNotifier.new(repo, url, environment)
      end
    end

    def initialize(repo, url, environment)
      @repo = repo 
      @url = url
      @environment = environment     
    end

    def pending
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

    def success
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

    def failure
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

    private
    def pending_msg
      "[deploy] #{repo}: goodluck is shipping to #{environment}.\n#{url}"
    end

    def success_msg
      "[deploy] #{repo}: goodluck shipped successfully to #{environment}.\n#{url}"
    end

    def failure_msg 
      "[deploy] #{repo}: what's the hell. goodluck couldn't ship to #{environment}."
    end
  end

  class HipChatNotifier < Notifier
    attr_accessor :room, :token

    def initialize(repo, url, environment)
      super
      @room = ENV['HIPCHAT_ROOM'] 
      @token = ENV['HIPCHAT_API_TOKEN']       
    end

    def pending
      notify(pending_msg)
    end

    def success
      notify(success_msg, color: 'green')
    end

    def failure
      notify(failure_msg, color: 'red')
    end

    private
    def notify(message, options = {})
      default_options = { message_format: 'text' }
      client[room].send("goodluck", message, default_options.merge(options))
    end

    def client
      @client ||= HipChat::Client.new(token, api_version: 'v1')
    end
  end

  class SlackNotifier < Notifier
    attr_accessor :hook_url, :channel, :default_payload

    def initialize(repo, url, environment)
      super
      @hook_url = ENV['SLACK_HOOK_URL']
      @channel = ENV['SLACK_CHANNEL']
      @default_payload = {
        channel: channel,
        username: "goodluck",
        icon_emoji: ":angel:"
      }
    end

    def pending
      payload = {
        text: "Deployment process started.",
        attachments: [
          {
            color: "warning",
            title: "#{environment.capitalize}: Deploy #{repo}",
            text: "Shipping to #{environment}.",
          }
        ]
      }
      notify(default_payload.merge(payload))
    end

    def success
      payload = {
        text: "Deployment process finished.",
        attachments: [
          {
            color: "good",
            title: "#{environment.capitalize}: Deploy #{repo}",
            text: "Shipped successfully to #{environment}.",
            fields: [
              {
                title: "URL",
                value: url,
                short: true
              }
            ]
          }
        ]
      }
      notify(default_payload.merge(payload))
    end

    def failure
      payload = {
        text: "Deployment process stopped.",
        attachments: [
          {
            color: "danger",
            title: "#{environment.capitalize}: Deploy #{repo}",
            text: "What's the hell. Something has gone wrong with #{environment}.",
          }
        ]
      }
      notify(default_payload.merge(payload))
    end

    private

    def notify(payload)
      Faraday.post hook_url, { payload: payload.to_json }
    end
  end

  class NullNotifier < Notifier
    def pending
      puts pending_msg
    end
    
    def success
      puts success_msg
    end

    def failure
      puts failure_msg
    end
  end
end
