# frozen_string_literal: true

json.message 'Category updated'
json.data do
  json.extract! @current_category, :id, :name, :created_at, :updated_at
end
