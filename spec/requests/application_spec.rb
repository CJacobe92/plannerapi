require 'rails_helper'

RSpec.describe "ApplicationController", type: :request do
  # User accessing the resource
  include TokenHelper

  let!(:user) do
    User.create(
      email: 'john.wick@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end
  let(:category) { FactoryBot.create(:category, user: user)}
  let(:task) { FactoryBot.create(:task, user: user, category:)}



  describe "correct authentication header" do
    context "user controller requests" do

      let(:user_params){FactoryBot.attributes_for(:user)}

      before do
        # index
        get "/api/v1/users", headers: { "Authorization" => header(user)}
        # show
        get "/api/v1/users/#{user.id}", headers: { "Authorization" => header(user)}
        # update
        patch "/api/v1/users/#{user.id}", params: {user: user_params}, headers: { "Authorization" => header(user)}
        # delete
        delete "/api/v1/users/#{user.id}", headers: { "Authorization" => header(user)}
      end

      it "returns a http status of success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "categories controller requests" do
      let(:category_params){FactoryBot.attributes_for(:category, user: user)}

      before do
        # index
        get "/api/v1/users/#{user.id}/categories", headers: { "Authorization" => header(user)}
        # show
        get "/api/v1/users/#{user.id}/categories/#{category.id}", headers: { "Authorization" => header(user)}
        # update
        patch "/api/v1/users/#{user.id}/categories/#{category.id}", params: {category: category_params}, headers: { "Authorization" => header(user)}
        # delete
        delete "/api/v1/users/#{user.id}/categories/#{category.id}", headers: { "Authorization" => header(user)}
      end

      it "returns a http status of success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "tasks controllers header" do
      let(:task_params){FactoryBot.attributes_for(:task, user: user, category: category)}

      before do
        # index
        get "/api/v1/users/#{user.id}/categories/#{category.id}/tasks", headers: { "Authorization" => header(user)}
        # show
        get "/api/v1/users/#{user.id}/categories/#{category.id}/tasks/#{task.id}", headers: { "Authorization" => header(user)}
        # update
        patch "/api/v1/users/#{user.id}/categories/#{category.id}/tasks/#{task.id}", params: {task: task_params}, headers: { "Authorization" => header(user)}
        # delete
        delete "/api/v1/users/#{user.id}/categories/#{category.id}/tasks/#{task.id}", headers: { "Authorization" => header(user)}
      end

      it "returns a http status of success" do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "incorrect authentication header" do
    context "user controller requests" do

      let(:user_params){FactoryBot.attributes_for(:user)}

      before do
        # index
        get "/api/v1/users", headers: { "Authorization" => "#{header(user)}invalid"}
        # show
        get "/api/v1/users/#{user.id}", headers: { "Authorization" => "#{header(user)}invalid"}
        # update
        patch "/api/v1/users/#{user.id}", params: {user: user_params}, headers: { "Authorization" => "#{header(user)}invalid"}
        # delete
        delete "/api/v1/users/#{user.id}", headers: { "Authorization" => "#{header(user)}invalid"}
      end

      it "returns a http status of success" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "categories controller requests" do
      let(:category_params){FactoryBot.attributes_for(:category, user: user)}

      before do
        # index
        get "/api/v1/users/#{user.id}/categories", headers: { "Authorization" => "#{header(user)}invalid"}
        # show
        get "/api/v1/users/#{user.id}/categories/#{category.id}", headers: { "Authorization" => "#{header(user)}invalid"}
        # update
        patch "/api/v1/users/#{user.id}/categories/#{category.id}", params: {category: category_params}, headers: { "Authorization" => "#{header(user)}invalid"}
        # delete
        delete "/api/v1/users/#{user.id}/categories/#{category.id}", headers: { "Authorization" => "#{header(user)}invalid"}
      end

      it "returns a http status of success" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "tasks controllers header" do
      let(:task_params){FactoryBot.attributes_for(:task, user: user, category: category)}

      before do
        # index
        get "/api/v1/users/#{user.id}/categories/#{category.id}/tasks", headers: { "Authorization" => "#{header(user)}invalid"}
        # show
        get "/api/v1/users/#{user.id}/categories/#{category.id}/tasks/#{task.id}", headers: { "Authorization" => "#{header(user)}invalid"}
        # update
        patch "/api/v1/users/#{user.id}/categories/#{category.id}/tasks/#{task.id}", params: {task: task_params}, headers: { "Authorization" => "#{header(user)}invalid"}
        # delete
        delete "/api/v1/users/#{user.id}/categories/#{category.id}/tasks/#{task.id}", headers: { "Authorization" => "#{header(user)}invalid"}
      end

      it "returns a http status of success" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "blank header" do
    before do
      get "/api/v1/users", headers: { "Authorization" => ""}
    end
    it "returns http status of unauthorized" do
      headers.blank?
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http status of unauthorized" do
      headers.blank?
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns the correct error message' do
      expect(json['error']).to include("Auth header missing")
    end
  end
end
