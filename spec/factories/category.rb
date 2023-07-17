# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    name { 'MyString' }
    association :user
  end

  factory :incorrect_category, class: 'Category' do
    name { '' }
  end
end
