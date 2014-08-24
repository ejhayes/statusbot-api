require 'spec_helper'

describe Statusbot::Api::Base do

  before :all do
    Statusbot::Api.connect
    @user_email = SecureRandom.uuid
    user = User.new(
      :email => @user_email, 
      :first_name => 'Bob', 
      :last_name => 'Smith'
    )
    user.save
  end

  let(:base) { Statusbot::Api::Base.new(@user_email) }

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
          # TODO: verify record created for user
          base.add_update('hey')
        end
      end
    end

    describe :sad do
      describe 'when update description is not valid' do
        it 'raises a InvalidUpdateError when update is nil'

        it 'raises an InvalidUpdateError when update is an empty string'

        it 'raises an InvalidUpdateError when update is only spaces'
      end

      describe 'when the database connection is broken' do
        it 'raises a DatabaseConnectionError'
      end
    end
  end

end
