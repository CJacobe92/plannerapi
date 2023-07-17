# frozen_string_literal: true

json.message 'Category fetched'
json.data do
  json.extract! @current_category, :id, :name, :created_at, :updated_at
end
