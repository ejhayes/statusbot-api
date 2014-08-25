module Statusbot
  module Api
    class Base
      attr_reader :user

      def initialize(user_email)
        begin
          @user = User.find_by_email!(user_email)
        rescue ActiveRecord::RecordNotFound
          raise UserNotRegisteredError
        end
      end

      def add_update(description=nil)
        raise InvalidUpdateError if description.nil? or description.strip.empty?
        done
        update = Update.new(
          :user => user, 
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
          user.updates
        rescue => e
          raise DatabaseConnectionError.new(e)
        end
      end

      def add_goal(description=nil)
        raise InvalidUpdateError if description.nil? or description.strip.empty?
        goal = Goal.new(
          :user => user, 
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
          user.goals
        rescue => e
          raise DatabaseConnectionError.new(e)
        end
      end

      def add_wait(description=nil)
        raise InvalidUpdateError if description.nil? or description.strip.empty?
        wait = Wait.new(
          :user => user, 
          :description => description
        )
        user.waits << wait
        begin
          user.save!
        rescue => e
          raise DatabaseConnectionError.new(e)
        end
      end

      def get_waits
        begin
          user.waits
        rescue => e
          raise DatabaseConnectionError.new(e)
        end
      end

      def remind(wait_id=nil, description=nil)
        raise InvalidUpdateError unless wait_id.is_a? Integer
        begin
          wait = Wait.find(wait_id)
        rescue => e
          raise InvalidUpdateError.new(e)
        end
        wait.pings << Ping.new(:description => description)
        
        begin
          wait.save!
        rescue => e
          raise DatabaseConnectionError.new(e)
        end
      end

      def done
        begin
          ActiveRecord::Base.transaction do
            user.updates.where(:stop_time => nil).each do |update|
              update.stop_time = DateTime.now
              update.save!
            end
          end
        rescue => e
          raise DatabaseConnectionError.new(e)
        end
        user.reload
      end
    end
  end
end
