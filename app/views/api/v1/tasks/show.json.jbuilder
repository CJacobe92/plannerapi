# frozen_string_literal: true

json.message 'Task fetched'
json.data do
  json.extract! @current_task, :id, :name, :urgent, :completed, :category_id, :user_id, :created_at, :updated_at
end
