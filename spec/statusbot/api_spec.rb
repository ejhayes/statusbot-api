require 'spec_helper'

describe Statusbot::Api do
  it 'has a version number' do
    expect(Statusbot::Api::VERSION).not_to be nil
  end

  describe :connect do
    before :each do
      Statusbot::Api.disconnect
    end
    
    describe :happy do
      describe 'connects to the database' do
        it 'connects to the models' do
          Statusbot::Models.should_receive(:connect)

          Statusbot::Api.connect
        end
      end
    end

    describe :sad do
      describe 'cannot connect to the database' do
        it 'raises a DatabaseConnectionError' do
          Statusbot::Models.should_receive(:connect) do
            raise 'some error'
          end

          expect { 
            Statusbot::Api.connect
            }.to raise_error Statusbot::Api::DatabaseConnectionError
        end
      end
    end
  end

  describe :api_for do
    before :all do
      Statusbot::Api.connect
      @user_email = 'bob@example.com'
      user = User.new(
        :email => @user_email, 
        :first_name => 'Bob', 
        :last_name => 'Smith'
      )
      user.save
    end
    describe :happy do
      describe 'when getting the api for a user that exists' do
        it 'connects to the database' do
          Statusbot::Api.should_receive(:connect)

          Statusbot::Api.api_for(@user_email)
        end

        it 'returns a instance of the api for the given user' do
          user_api = Statusbot::Api.api_for(@user_email)

          user_api.should be_a Statusbot::Api::Base
        end
      end
    end

    describe :sad do
      describe 'when a user does not exist' do
        it 'raises a UserNotRegisteredError' do
          expect { 
            Statusbot::Api.api_for('I DO NOT EXIST')
            }.to raise_error Statusbot::Api::UserNotRegisteredError
        end
      end
    end
  end
end
