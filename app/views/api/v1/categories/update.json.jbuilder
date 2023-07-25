# frozen_string_literal: true

json.message 'Category updated'
json.data do
  json.extract! @current_category, :id, :name, :user_id, :created_at, :updated_at
end
