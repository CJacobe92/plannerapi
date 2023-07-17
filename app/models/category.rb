# frozen_string_literal: true

class Category < ApplicationRecord
  # associations
  belongs_to :user
  has_many :tasks, dependent: :destroy

  # validations
  validates :name, presence: true
end
