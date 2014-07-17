require 'pp'
class EventsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:create]

  def create
    pp params
    head :ok
  end
end
