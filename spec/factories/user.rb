# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :user do
    email { "#{Faker::Name.first_name}.#{Faker::Name.last_name}@email.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :incorrect_user, class: 'User' do
    email { '' }
    password { 'not_a_valid_password' }
    password_confirmation { 'not_a_valid_password_confirmation' }
  end
end
