# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Categories', type: :request do
  describe 'GET /index' do
    context 'with correct authorization' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        generate_user(user)
        get "/api/v1/users/#{user.id}/categories"
      end

      it 'returns correct json message' do
        expect(json['message']).to eq('Categories fetched')
      end

      it 'returns http status 200' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the index view template' do
        expect(response).to render_template('api/v1/categories/index')
      end

      it 'returns all categories' do
        expect(json['data'].size).to eq(10)
      end

      it 'returns the category with all the expected keys' do
        json['data'].each do |category|
          assert_category_keys(category)
        end
      end

      it 'returns the task with all the expected keys' do
        json['data'].each do |category|
          assert_task_keys(category)
        end
      end
    end
  end

  describe 'POST /create' do
    context 'with valid category params' do
      let(:user) { FactoryBot.create(:user) }
      let(:category) { FactoryBot.attributes_for(:category) }

      before do
        post "/api/v1/users/#{user.id}/categories", params: { category: }
      end

      it 'returns correct json message' do
        expect(json['message']).to eq('Category created')
      end

      it 'returns http status of 201' do
        expect(response).to have_http_status(:created)
      end

      it 'renders the create view template' do
        expect(response).to render_template('api/v1/categories/create')
      end

      it 'returns the category with the expected keys' do
        expect(json['data'].size).to eq(4)
      end
    end

    context 'with invalid category params' do
      let(:user) { FactoryBot.create(:user) }
      let(:invalid_category_params) { FactoryBot.attributes_for(:incorrect_category) }

      before do
        post "/api/v1/users/#{user.id}/categories", params: { category: invalid_category_params }
      end

      it 'returns https status of 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET /show' do
    context 'with correct category id ' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:category) do
        FactoryBot.create(:category, user:)
      end

      before do
        get "http://localhost:3000/api/v1/users/#{user.id}/categories/#{category.id}"
      end

      it 'returns correct json message' do
        expect(json['message']).to eq('Category fetched')
      end

      it 'returns http status of 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the show view template' do
        expect(response).to render_template('api/v1/categories/show')
      end

      it 'returns the category with the expected keys' do
        expect(json['data'].size).to eq(4)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with correct category id ' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:category) do
        FactoryBot.create(:category, user:)
      end

      let!(:updated_category) do
        FactoryBot.attributes_for(:category)
      end

      before do
        patch "http://localhost:3000/api/v1/users/#{user.id}/categories/#{category.id}", params: { category: updated_category }
      end

      it 'returns correct json message' do
        expect(json['message']).to eq('Category updated')
      end

      it 'returns http status of 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the update view template' do
        expect(response).to render_template('api/v1/categories/update')
      end

      it 'returns the category with the expected keys' do
        expect(json['data'].size).to eq(4)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'with correct category id ' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:category) do
        FactoryBot.create(:category, user:)
      end

      before do
        delete "http://localhost:3000/api/v1/users/#{user.id}/categories/#{category.id}"
      end

      it 'returns correct json message' do
        expect(json['message']).to eq('Category deleted')
      end

      it 'returns http status of 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the destroy view template' do
        expect(response).to render_template('api/v1/categories/destroy')
      end
    end
  end

  describe 'set_category' do
    context 'with incorrect category' do
      let!(:category) { FactoryBot.create(:category) }
      let!(:user_id) { category.user_id }
      let!(:incorrect_category_id) { category.id + 1 }

      before do
        patch "http://localhost:3000/api/v1/users/#{user_id}/categories/#{incorrect_category_id}"
        get "http://localhost:3000/api/v1/users/#{user_id}/categories/#{incorrect_category_id}"
        delete "http://localhost:3000/api/v1/users/#{user_id}/categories/#{incorrect_category_id}"
      end

      it 'returns correct json error message' do
        expect(json['error']).to eq('Category not found')
      end

      it 'returns http status of 404' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  def generate_user(user)
    FactoryBot.create_list(:category, 10, user:) do |category|
      FactoryBot.create(:task, category:, user:)
    end
  end

  def assert_category_keys(data)
    expect(data.size).to eq(5)
  end

  def assert_task_keys(data)
    data['tasks'].each do |task|
      expect(task.size).to eq(6)
    end
  end
end
