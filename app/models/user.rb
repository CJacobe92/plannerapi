# frozen_string_literal: true

class User < ApplicationRecord
  # associations
  has_secure_password
  has_many :categories, dependent: :destroy
  has_many :tasks, through: :categories

  # validations

  validates :firstname, presence: true, on: :create
  validates :lastname, presence: true, on: :create
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, on: :create
  validates :password, presence: true, on: :create
  validates :password_confirmation, presence: true, on: :create
end
