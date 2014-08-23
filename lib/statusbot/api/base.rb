module Statusbot
  module Api
    class Base
      def initialize(user_email)
        begin
          @user = User.find_by_email!(user_email)
        rescue ActiveRecord::RecordNotFound
          raise UserNotRegisteredError
        end
      end
    end
  end
end
