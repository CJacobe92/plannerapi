# frozen_string_literal: true

class User < ApplicationRecord
  # associations
  has_secure_password
  has_many :categories, dependent: :destroy
  has_many :tasks, through: :categories

  # validations

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true
  validates :password_confirmation, presence: true
end
