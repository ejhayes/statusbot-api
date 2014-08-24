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

      def add_update(description)
        update = Update.new(
          :user => @user, 
          :description => description, 
          :start_time => DateTime.now
        )
        update.save!
      end
    end
  end
end
