# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  include ApiHelpers
  include AuthHelper
  # User that  is accessing the resource
  let!(:user) do
    User.create(
      email: 'john.wick@example.com',
      password: "password",
      password_confirmation: 'password'
    )
  end

  describe 'GET /index' do
    context 'with correct authorization' do
      let!(:users) { FactoryBot.create_list(:user, 9) }

      before do
        generate_users(users)
        get '/api/v1/users', headers: { 'Authorization' => header(user) }
      end


      it 'returns all users' do
        expect(json['data'].size).to eq(10)
      end

      it 'return a user with all the expected keys ' do
        json['data'].each do |user|
          assert_user_keys(user)
        end
      end

      it 'returns the category with all the expected keys' do
        json['data'].each do |user|
          assert_category_keys(user)
        end
      end

      it 'returns the task with all the expected keys' do
        json['data'].each do |user|
          assert_task_keys(user)
        end
      end

      it 'returns correct json message' do
        expect(json['message']).to eq('Users fetched')
      end

      it 'returns http status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the index view template' do
        expect(response).to render_template('api/v1/users/index')
      end
    end
  end

  describe 'POST /create' do
    context 'with valid user params' do
      before do
        post '/api/v1/users', params: { user: FactoryBot.attributes_for(:user) }
      end

      it 'returns correct json message ' do
        expect(json['message']).to eq('User created')
      end

      it 'returns http status of 201' do
        expect(response).to have_http_status(:created)
      end

      it 'renders the create view template' do
        expect(response).to render_template('api/v1/users/create')
      end

      it 'returns the user with the expected keys' do
        expect(json['data'].size).to eq(4)
      end
    end

    context 'with invalid user params' do
      before do
        post '/api/v1/users', params: { user: FactoryBot.attributes_for(:incorrect_user) }
      end

      it 'returns http status of 422 - Unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET /show' do
    context 'with correct user id' do

      before do
        get "/api/v1/users/#{user.id}", headers: { 'Authorization' => header(user) }
      end

      it 'returns correct json message' do
        expect(json['message']).to eq('User fetched')
      end

      it 'returns http status of 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the show view template' do
        expect(response).to render_template('api/v1/users/show')
      end

      it 'returns the user with the expected keys' do
        assert_user_keys(json['data'])
      end

      it 'returns the category with the expected keys' do
        assert_category_keys(json['data'])
      end

      it 'returns the category task with the expected keys' do
        assert_task_keys(json['data'])
      end
    end
  end

  describe 'PATCH /update' do
    context 'with correct user id and user params' do
      updated_params = {
        email: 'john.weak@example.com',
        password: 'password',
        password_confirmation: 'password'

      }

      before do
        patch "/api/v1/users/#{user.id}", params: { user:  updated_params}, headers: { "Authorization" => header(user) }
      end

      it 'returns correct json message' do
        expect(json['message']).to eq('User updated')
      end

      it 'return http status of 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the update view template' do
        expect(response).to render_template('api/v1/users/update')
      end

      it 'returns the user with the expected keys' do
        expect(json['data'].size).to eq(4)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'with correct user_id' do
      before do
        delete "/api/v1/users/#{user.id}", headers: { "Authorization" => header(user) }
      end

      it 'returns correct json message' do
        expect(json['message']).to eq('User deleted')
      end

      it 'returns http status of 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the delete view template' do
        expect(response).to render_template('api/v1/users/destroy')
      end
    end
  end

  def generate_users(users)
    users.each do |user|
      FactoryBot.create(:category, user:) do |category|
        FactoryBot.create(:task, category: category, user:)
      end
    end
  end

  def generate_user(user)
    FactoryBot.create(:category, user: user) do |category|
      FactoryBot.create(:task, category:, user: user)
    end
  end

  def assert_user_keys(user)
    expect(user.size).to eq(5)
  end

  def assert_category_keys(data)
    data['categories'].each do |category|
      expect(category.size).to eq(6)
    end
  end

  def assert_task_keys(data)
    data['categories'].each do |category|
      category['tasks'].each do |task|
        expect(task.size).to eq(8)
      end
    end
  end
end
