# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'GET /index' do
    context 'with correct authorization' do
      let!(:users) { FactoryBot.create_list(:user, 10) }

      before do
        generate_users(users)
        get '/api/v1/users'
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
        expect(json['data'].size).to eq(6)
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
      let(:user) { FactoryBot.create(:user) }

      before do
        generate_user(user)
        get "/api/v1/users/#{user.id}"
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
      let!(:user) { FactoryBot.create(:user) }

      let(:updated_user) { FactoryBot.attributes_for(:user) }

      before do
        patch "/api/v1/users/#{user.id}", params: { user: updated_user }
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
        expect(json['data'].size).to eq(6)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'with correct user_id' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        delete "/api/v1/users/#{user.id}"
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

  describe 'set_user' do
    context 'with incorrect user' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        patch "/api/v1/users/#{user.id + 1}"
        get "/api/v1/users/#{user.id + 1}"
        delete "/api/v1/users/#{user.id + 1}"
      end

      it 'returns correct json error' do
        expect(json['error']).to eq('Resource not found')
      end

      it 'returns http status of not found - 404' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  def generate_users(users)
    users.each do |user|
      FactoryBot.create(:category, user:) do |category|
        FactoryBot.create(:task, category:, user:)
      end
    end
  end

  def generate_user(user)
    FactoryBot.create(:category, user:) do |category|
      FactoryBot.create(:task, category:, user:)
    end
  end

  def assert_user_keys(user)
    expect(user.size).to eq(7)
  end

  def assert_category_keys(data)
    data['categories'].each do |category|
      expect(category.size).to eq(5)
    end
  end

  def assert_task_keys(data)
    data['categories'].each do |category|
      category['tasks'].each do |task|
        expect(task.size).to eq(6)
      end
    end
  end
end
