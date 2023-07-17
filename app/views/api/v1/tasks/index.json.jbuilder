# frozen_string_literal: true

json.message 'Tasks fetched'
json.data do
  json.array! @tasks do |task|
    json.extract! task, :id, :name, :urgent, :completed, :created_at, :updated_at
  end
end
