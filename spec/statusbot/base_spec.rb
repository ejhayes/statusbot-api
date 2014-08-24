require 'spec_helper'

describe Statusbot::Api::Base do

  before :each do
    @valid_user_email = SecureRandom.uuid

    user = User.new( 
      :email => @valid_user_email, 
      :first_name => 'Bob', 
      :last_name => 'Smith'
    )
    user.save

    @test_time = DateTime.now
    DateTime.stub(:now).and_return(@test_time)
  end

  let(:base) { Statusbot::Api::Base.new(@valid_user_email) }

  describe :new do
    describe :happy do
      describe 'when a user exists' do
        it 'works for a valid user' do
          base
        end
      end
    end

    describe :sad do
      describe 'when a user does not exist' do
        it 'raises a UserNotRegisteredError' do
          User.stub(:find_by_email!).with('I DO NOT EXIST') do
            raise ActiveRecord::RecordNotFound
          end

          expect { 
            Statusbot::Api::Base.new('I DO NOT EXIST')
          }.to raise_error Statusbot::Api::UserNotRegisteredError
        end
      end
    end
  end

  describe :add_update do
    describe :happy do
      describe 'when a user submits a valid update' do
        it 'creates an update record for the user' do
          base.add_update('random-ass update')

          user = User.find_by_email!(@valid_user_email)
          result = user.updates
          result.size.should == 1
          result.first.description.should == 'random-ass update'
          result.first.start_time.to_i.should == @test_time.to_i
          result.first.stop_time.should be_nil
        end

        it 'sets the stop_time of the previous task to the current time'
      end
    end

    describe :sad do
      describe 'when update description is not valid' do
        it 'raises a InvalidUpdateError when update is nil' do
          expect {
            base.add_update
          }.to raise_error Statusbot::Api::InvalidUpdateError
        end

        it 'raises an InvalidUpdateError when update is an empty string' do
          expect {
            base.add_update('')
          }.to raise_error Statusbot::Api::InvalidUpdateError
        end

        it 'raises an InvalidUpdateError when update is only spaces' do
          expect {
            base.add_update('   ')
          }.to raise_error Statusbot::Api::InvalidUpdateError
        end
      end

      describe 'when the database connection is broken' do
        it 'raises a DatabaseConnectionError' do
          Update.should_receive(:new) do
            update = double('update').as_null_object
            update.should_receive(:save!) do
              raise 'random-ass error'
            end
            update
          end

          expect {
            base.add_update('hello world')
          }.to raise_error Statusbot::Api::DatabaseConnectionError
        end
      end
    end
  end

  describe :get_updates do
    describe :happy do
      describe 'when a user retrieves updates' do
        it 'returns updates if they exist' do
          base.add_update('this is a test')
          result = base.get_updates

          result.size.should == 1
          result.first.user.email.should == @valid_user_email
          result.first.description.should == 'this is a test'
        end

        it 'does not return any updates if none exist' do
          result = base.get_updates
          
          result.size.should == 0
        end
      end
    end

    describe :sad do
      describe 'when the database connection is broken' do
        it 'raises a DatabaseConnectionError' do
          User.any_instance.should_receive(:updates) do
            raise 'random-ass error'
          end

          expect {
            base.get_updates
          }.to raise_error Statusbot::Api::DatabaseConnectionError
        end
      end
    end
  end

  describe :add_goal do
    describe :happy do
      describe 'when a user submits a valid goal' do
        it 'creates a goal record for the user' do
          base.add_goal('random-ass goal')

          user = User.find_by_email!(@valid_user_email)
          result = user.goals
          result.size.should == 1
          result.first.description.should == 'random-ass goal'
          result.first.created_at.to_i.should == @test_time.to_i
        end
      end
    end

    describe :sad do
      describe 'when a user submits an invalid goal' do
        it 'raises an InvalidUpdateError when update is nil' do
          expect {
            base.add_goal
          }.to raise_error Statusbot::Api::InvalidUpdateError
        end
        it 'raises an InvalidUpdateError when update is an empty string' do
          expect {
            base.add_goal('')
          }.to raise_error Statusbot::Api::InvalidUpdateError
        end
        it 'raises an InvalidUpdateError when update is only spaces' do
          expect {
            base.add_goal('   ')
          }.to raise_error Statusbot::Api::InvalidUpdateError
        end
      end
    end
  end

  describe :get_goals do
    describe :happy do
      describe 'when a user retrieves goals' do
        it 'returns goals if they exist' do
          base.add_goal('this is a test goal')
          result = base.get_goals

          result.size.should == 1
          result.first.user.email.should == @valid_user_email
          result.first.description.should == 'this is a test goal'
        end
        it 'does not return any goals if none exist' do
          result = base.get_goals
          
          result.size.should == 0
        end
      end
    end

    describe :sad do
      describe 'when the database conection is broken' do
        it 'raises a DatabaseConnectionError' do
          User.any_instance.should_receive(:goals) do
            raise 'random-ass error'
          end

          expect {
            base.get_goals
          }.to raise_error Statusbot::Api::DatabaseConnectionError
        end
      end
    end
  end

  describe :add_wait do
    describe :happy do
      describe 'when a user submits a valid wait' do
        it 'creates a wait record for the user' do
          base.add_wait('random-ass wait')

          user = User.find_by_email!(@valid_user_email)
          result = user.waits
          result.size.should == 1
          result.first.description.should == 'random-ass wait'
          result.first.created_at.to_i.should == @test_time.to_i
        end
      end
    end

    describe :sad do
      describe 'when a user submits an invalid wait' do
        it 'raises an InvalidUpdateError when update is nil' do
          expect {
            base.add_wait
          }.to raise_error Statusbot::Api::InvalidUpdateError
        end
        it 'raises an InvalidUpdateError when update is an empty string' do
          expect {
            base.add_wait('')
          }.to raise_error Statusbot::Api::InvalidUpdateError
        end
        it 'raises an InvalidUpdateError when update is only spaces' do
          expect {
            base.add_wait('   ')
          }.to raise_error Statusbot::Api::InvalidUpdateError
        end
      end
    end
  end

  describe :get_waits do
    describe :happy do
      describe 'when a user retrieves waits' do
        it 'returns waits if they exist' do
          base.add_wait('this is a test wait')
          result = base.get_waits

          result.size.should == 1
          result.first.user.email.should == @valid_user_email
          result.first.description.should == 'this is a test wait'
        end
        it 'does not return waits if none exist' do
          result = base.get_waits
          
          result.size.should == 0
        end
      end
    end

    describe :sad do
      describe 'when the database connection is broken' do
        it 'raises a DatabaseConnectionError' do
          User.any_instance.should_receive(:waits) do
            raise 'random-ass error'
          end

          expect {
            base.get_waits
          }.to raise_error Statusbot::Api::DatabaseConnectionError
        end
      end
    end
  end

  describe :remind do
    describe :happy do
      describe 'when a user submits a valid reminder' do
        it 'creates a ping record for the wait item'
      end
    end

    describe :sad do
      describe 'when a user submits an invalid reminder' do
        it 'raises an InvalidUpdateError if the id is nil'
        it 'raises an InvalidUpdateError if the id is a blank string'
        it 'raises an InvalidUpdateError if the id is only spaces'
        it 'raises an InvalidUpdateError if the id does not exist'
      end
    end
  end

  describe :done do
    describe :happy do
      describe 'when a user is done' do
        it 'sets the stop_time for any open tasks for the user'
        it 'does nothing if a task has not been started'
      end
    end

    describe :sad do
      describe 'when the database connection is broken' do
        it 'raises a DatabaseConnectionError'
      end
    end
  end
end
