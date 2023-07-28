# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

@user = User.create(email: 'test.user@email.com', password: 'password', password_confirmation: 'password')

if @user.save

  @category = @user.categories.create(name: 'Personal')
  @category2 = @user.categories.create(name: 'Business')
  @category3 = @user.categories.create(name: 'Freelance')

  if @category.save && @category2.save
    @category.tasks.create(name: 'Get coffee', urgent: false, completed: false, user_id: @user.id, category_id: @category.id)
    @category.tasks.create(name: 'Do Laundry', urgent: true, completed: false, user_id: @user.id, category_id: @category.id)
    @category.tasks.create(name: 'Walk the dog', urgent: false, completed: true, user_id: @user.id, category_id: @category.id)

    @category2.tasks.create(name: 'See the client', urgent: false, completed: false, user_id: @user.id, category_id: @category2.id)
    @category2.tasks.create(name: 'Present business proposal', urgent: true, completed: false, user_id: @user.id, category_id: @category2.id)
    @category2.tasks.create(name: 'Meeting with the CEO', urgent: false, completed: true, user_id: @user.id, category_id: @category2.id)

  end
else
  puts "Failed to create the user: #{@user.errors.full_messages}"
end

