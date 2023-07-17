# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :user do
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    email { "#{firstname}.#{lastname}@email.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :incorrect_user, class: 'User' do
    firstname { '' }
    lastname { '' }
    email { '' }
    password { 'not_a_valid_password' }
    password_confirmation { 'not_a_valid_password_confirmation' }
  end
end
