# frozen_string_literal: true

if @task&.errors&.any?
  json.error @task.errors.full_messages.join(' ')
elsif @task.save
  json.message 'Task created'
  json.data do
    json.extract! @task, :id, :name, :urgent, :completed, :created_at, :updated_at
  end
end
