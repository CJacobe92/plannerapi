# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:categories).dependent(:destroy) }
    it { is_expected.to have_many(:tasks).through(:categories) }
  end

  describe 'presence validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:password_confirmation) }
  end

  describe 'uniqueness validations' do
    let!(:existing_user) { FactoryBot.create(:user, email: 'existinguser@email.com') }

    it 'validates uniqueness of email' do
      new_user = described_class.new(email: existing_user.email)
      expect(new_user).not_to be_valid
      expect(new_user.errors[:email]).to include('has already been taken')
    end
  end

  describe 'email format validation' do
    it 'validates a valid email address' do
      valid_email = 'john.doe@email.com'
      expect(valid_email).to match(URI::MailTo::EMAIL_REGEXP)
    end

    it 'does not validate an invalid email address' do
      valid_email = 'invalid_email'
      expect(valid_email).not_to match(URI::MailTo::EMAIL_REGEXP)
    end
  end

  describe 'password authentication' do
    let!(:user) do
      described_class.new(email: 'john.doe@email.com', password: 'password',
                          password_confirmation: 'password')
    end

    it 'returns true when the password is correct' do
      expect(user.authenticate('password')).to be_truthy
    end

    it 'returns false when the password is incorrect' do
      expect(user.authenticate('wrong_password')).to be_falsey
    end
  end
end
