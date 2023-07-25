# frozen_string_literal: true

json.message 'User fetched'
json.data do
  json.extract! @current_user, :id, :email, :created_at, :updated_at
  json.categories @current_user.categories do |category|
    json.extract! category, :id, :name, :created_at, :updated_at
    json.tasks category.tasks do |task|
      json.extract! task, :id, :name, :urgent, :completed, :category_id, :user_id, :created_at, :updated_at
    end
  end
end
