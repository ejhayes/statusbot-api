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

      def add_update(description=nil)
        raise InvalidUpdateError if description.nil? or description.strip.empty?
        update = Update.new(
          :user => @user, 
          :description => description, 
          :start_time => DateTime.now
        )
        begin
          update.save!
        rescue => e
          raise DatabaseConnectionError.new(e)
        end
      end

      def get_updates
        begin
          @user.updates
        rescue => e
          raise DatabaseConnectionError.new(e)
        end
      end

      def add_goal(description=nil)
        raise InvalidUpdateError if description.nil? or description.strip.empty?
        goal = Goal.new(
          :user => @user, 
          :description => description
        )
        begin
          goal.save!
        rescue => e
          raise DatabaseConnectionError.new(e)
        end
      end

      def get_goals
        begin
          @user.goals
        rescue => e
          raise DatabaseConnectionError.new(e)
        end
      end

      def add_wait(description=nil)
        raise InvalidUpdateError if description.nil? or description.strip.empty?
        wait = Wait.new(
          :user => @user, 
          :description => description
        )
        begin
          wait.save!
        rescue => e
          raise DatabaseConnectionError.new(e)
        end
      end
    end
  end
end
