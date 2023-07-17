# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { 'MyString' }
    completed { true }
    urgent { true }
    association :category
    association :user
  end

  factory :incorrect_task, class: 'Task' do
    name { 'MyString' }
    completed { '' }
    urgent { '' }
    association :category
    association :user
  end
end
