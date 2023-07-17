# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :name, presence: true
  validates :urgent, inclusion: { in: [true, false] }
  validates :completed, inclusion: { in: [true, false] }
end
