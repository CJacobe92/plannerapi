# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Tasks', type: :request do
  include AuthHelper

  # User that  is accessing the resource
  let!(:user) do
    User.create(
      email: 'john.wick@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end
  let!(:category) { FactoryBot.create(:category, user: user) }

  describe 'GET /index' do
    context 'with correct authorization' do
      before do
        generate_tasks(category, user)
        get "/api/v1/users/#{user.id}/categories/#{category.id}/tasks", headers: { 'Authorization' => header(user) }
      end

      it 'returns correct json message' do
        expect(json['message']).to eq('Tasks fetched')
      end

      it 'returns http status 200' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the index view template' do
        expect(response).to render_template('api/v1/tasks/index')
      end

      it 'returns all categories' do
        expect(json['data'].size).to eq(10)
      end

      it 'returns the task with all the expected keys' do
        json['data'].each do |task|
          expect(task.size).to eq(8)
        end
      end
    end
  end

  describe 'POST /create' do
    context 'creates resource with valid parameters' do
      let(:category) { FactoryBot.create(:category, user: user) }
      let(:task_params) { FactoryBot.attributes_for(:task) }

      before do
        post "/api/v1/users/#{user.id}/categories/#{category.id}/tasks", params: { task: task_params }
      end

      it 'returns correct json message' do
        expect(json['message']).to eq('Task created')
      end

      it 'returns https status 201' do
        expect(response).to have_http_status(:created)
      end

      it 'renders the create view template' do
        expect(response).to render_template('api/v1/tasks/create')
      end

      it 'returns task with the expected keys' do
        expect(json['data'].size).to eq(6)
      end
    end

    context 'does not create resource with invalid parameters' do
      let(:category) { FactoryBot.create(:category, user:user) }
      let(:invalid_task_params) { FactoryBot.attributes_for(:incorrect_task) }

      before do
        post "/api/v1/users/#{user.id}/categories/#{category.id}/tasks", params: { task: invalid_task_params }
      end

      it 'returns https status 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET /show' do
    context 'shows the resource' do
      let(:category) { FactoryBot.create(:category, user: user) }
      let(:task) { FactoryBot.create(:task, user: user, category:) }

      before do
        get "/api/v1/users/#{user.id}/categories/#{category.id}/tasks/#{task.id}", headers: { 'Authorization' => header(user) }
      end

      it 'return the correct json message' do
        expect(json['message']).to eq('Task fetched')
      end

      it 'returns http status of 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the show view template' do
        expect(response).to render_template('api/v1/tasks/show')
      end

      it 'returns task with the expected keys' do
        expect(json['data'].size).to eq(8)
      end
    end
  end

  describe 'PATCH /update' do
    context 'updates the resource' do
      let(:category) { FactoryBot.create(:category, user: user) }
      let(:task) { FactoryBot.create(:task, category: category, user: user) }
      let(:updated_task) { FactoryBot.attributes_for(:task) }

      before do
        patch "/api/v1/users/#{user.id}/categories/#{category.id}/tasks/#{task.id}", params: { task: updated_task }, headers: { 'Authorization' => header(user) }
      end

      it 'return the correct json message' do
        expect(json['message']).to eq('Task updated')
      end

      it 'returns http status of 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the update view template' do
        expect(response).to render_template('api/v1/tasks/update')
      end

      it 'returns task with the expected keys' do
        expect(json['data'].size).to eq(8)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'deletes the resource' do
      let(:category) { FactoryBot.create(:category, user: user) }
      let(:task) { FactoryBot.create(:task, category: category, user: user) }

      before do
        delete "/api/v1/users/#{user.id}/categories/#{category.id}/tasks/#{task.id}", headers: { 'Authorization' => header(user) }
      end

      it 'return the correct json message' do
        expect(json['message']).to eq('Task deleted')
      end

      it 'returns http status of 200' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'set_tasks' do
    context 'with incorrect tasks' do

      let(:category) { FactoryBot.create(:category, user: user) }
      let(:task) { FactoryBot.create(:task, category: category, user: user) }
      let(:incorrect_task_id) { task.id + 1 }


      before do
        patch "http://localhost:3000/api/v1/users/#{user.id}/categories/#{category.id}/tasks/#{incorrect_task_id}", headers: { 'Authorization' => header(user) }
        get "http://localhost:3000/api/v1/users/#{user.id}/categories/#{category.id}/tasks/#{incorrect_task_id}",  headers: { 'Authorization' => header(user) }
        delete "http://localhost:3000/api/v1/users/#{user.id}/categories/#{category.id}/tasks/#{incorrect_task_id}", headers: { 'Authorization' => header(user) }
      end

      it 'returns correct json error message' do
        expect(json['error']).to eq('Task not found')
      end

      it 'returns http status of 404' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  def generate_tasks(category, user)
    FactoryBot.create_list(:task, 10, category: category, user: user)
  end
end
