# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :password_digest
      t.string :token
      t.boolean :token_valid
      t.datetime :token_expiry

      t.timestamps
    end
  end
end
