# frozen_string_literal: true

json.message 'User updated'
json.data do
  json.extract! @current_user, :id, :firstname, :lastname, :email, :created_at, :updated_at
end
