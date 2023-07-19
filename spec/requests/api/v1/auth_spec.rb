require 'rails_helper'

RSpec.describe "Api::V1::Auth", type: :request do
  describe "POST /create" do
    context 'with correct credentials' do
        let(:user){FactoryBot.create(:user)}

        before do
          post '/api/v1/auth', params: {auth: {email: user.email, password: user.password}}
        end

        it "returns a successful login" do
          expect(json['message']).to eq('Login successful')
        end

        it "returns http status of 200" do
          expect(response).to have_http_status(:success)
        end

        it "returns authorization header" do
          expect(response.headers['Authorization']).to match(/^Bearer .+/)
        end

        it 'returns X-REQUEST-ID header' do
          expect(response.headers).to include('X-REQUEST-ID')
        end

        it 'returns plannerapi header' do
          expect(response.headers['client']).to include('plannerapi')
        end

        it 'returns a login successful message' do
          expect(json['message']).to include('Login successful')
        end
    end

    context 'with incorrect credentials' do
      let(:user){FactoryBot.create(:user)}

      before do
        post '/api/v1/auth', params: {auth: {email: user.email, password: "wrong_password"}}
      end

      it "returns correct error message" do
        expect(json['error']).to eq('Invalid login credentials')
      end

      it "returns http status of 401" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
