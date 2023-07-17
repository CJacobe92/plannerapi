# frozen_string_literal: true

json.message 'Categories fetched'
json.data do
  json.array! @categories do |category|
    json.extract! category, :id, :name, :created_at, :updated_at
    json.tasks category.tasks do |task|
      json.extract! task, :id, :name, :urgent, :completed, :created_at, :updated_at
    end
  end
end
