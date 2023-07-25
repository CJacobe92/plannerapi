# frozen_string_literal: true

if @category&.errors&.any?
  json.error @category.errors.full_messages.join(' ')
elsif @category.save
  json.message 'Category created'
  json.data do
    json.extract! @category, :id, :name, :user_id, :created_at, :updated_at
  end
end
