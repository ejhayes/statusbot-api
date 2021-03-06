module Statusbot
  module Api
    class Error < StandardError
    end

    class UserNotRegisteredError < Error
    end

    class DatabaseConnectionError < Error
    end

    class InvalidUpdateError < Error
    end
  end
end
