require 'pp'
require 'sinatra'
require 'receiver'

module Goodluck

  class Server < Sinatra::Base
    post '/events' do
      if valid_events.include?(event) && valid_request?
        request.body.rewind
        data = request.body.read

        receiver = Receiver.new(event, delivery_id, data)
        receiver.run
      end

      status 200
    end

    private
    def valid_request?
      return true
      ENV['GOODLUCK_TOKEN'] == params[:token]
    end

    # extened header
    # HTTP_X_GITHUB_DELIVERY
    # HTTP_X_GITHUB_EVENT
    # HTTP_X_HUB_SIGNATURE
    def event
      request.env["HTTP_X_GITHUB_EVENT"]
    end

    def delivery_id
      request.env["HTTP_X_GITHUB_DELIVERY"]
    end

    def valid_events
      %w(push deployment ping)
    end
  end
end
