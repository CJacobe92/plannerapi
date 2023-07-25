# frozen_string_literal: true
json.message 'Users fetched'
json.data do
  json.array! @users do |user|
    json.extract! user, :id, :email, :created_at, :updated_at
    json.categories user.categories do |category|
      json.extract! category, :id, :name, :user_id, :created_at, :updated_at
      json.tasks category.tasks, :id, :name, :urgent, :completed, :category_id, :user_id, :created_at, :updated_at
    end
  end
end
