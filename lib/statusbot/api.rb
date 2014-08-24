require "statusbot/models"
require "statusbot/api/version"
require "statusbot/api/error"
require "statusbot/api/base"
require 'date'

module Statusbot
  module Api
    @@connected = false

    def self.api_for(user)
      connect
      Base.new(user)
    end

    def self.connect
      unless @@connected
        begin
          Statusbot::Models.connect
          @@connected = true
        rescue => e
          raise DatabaseConnectionError.new(e)
        end
      end
    end

    def self.disconnect
      @@connected = false
    end
  end
end
