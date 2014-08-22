require "statusbot/api/version"
require "statusbot/models"

module Statusbot
  module Api
    Statusbot::Models.connect
  end
end
