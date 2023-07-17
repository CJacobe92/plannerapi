# frozen_string_literal: true

json.message 'Task updated'
json.data do
  json.extract! @current_task, :id, :name, :urgent, :completed, :created_at, :updated_at
end
