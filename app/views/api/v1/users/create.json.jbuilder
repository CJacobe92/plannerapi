# frozen_string_literal: true

if @user&.errors&.any?
  json.error @user.errors.full_messages.join(' ')
elsif @user.save
  json.message 'User created'
  json.data do
    json.extract! @user, :id, :firstname, :lastname, :email, :created_at, :updated_at
  end
end
