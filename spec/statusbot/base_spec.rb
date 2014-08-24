require 'spec_helper'

describe Statusbot::Api::Base do

  before :each do
    @valid_user_email = SecureRandom.uuid

    @user_mock = mock_model(User, 
      :email => @valid_user_email, 
      :first_name => 'Bob', 
      :last_name => 'Smith'
    )
    
    User.stub(:find_by_email!).with(@valid_user_email) do
      @user_mock
    end

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
          example_update = 'random-ass update'

          Update.stub(:new).with(
            :user => @user_mock, 
            :description => example_update, 
            :start_time => @test_time
          ) do
            update = mock_model(Update)
            update.should_receive(:save!)
            update
          end

          base.add_update(example_update)
        end
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
          Update.stub(:new) do
            update = mock_model(Update)
            update.should_receive(:save!) do
              raise 'some error'
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

end
