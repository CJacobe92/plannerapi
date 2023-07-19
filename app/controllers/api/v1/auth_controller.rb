require 'token_helper'

class Api::V1::AuthController < ApplicationController
  include TokenHelper

  def create
    @user = User.find_by(email: params[:auth][:email])

    if @user && @user.authenticate(params[:auth][:password])
      token = encode_token(id: @user.id, firstname: @user.firstname, lastname: @user.lastname, email: @user.email, valid: true)
      @user.update!(token: token)

      generate_request_id
      set_auth_response_headers(token)

      render json: { message: "Login successful" }, status: :ok
    else
      render json: { error: "Invalid login credentials" }, status: :unauthorized
    end
  end

  private

  def auth_params
    params.require(:auth).permit(:email, :password)
  end

  def generate_request_id
    request_id = SecureRandom.uuid
    response.headers['X-Request-ID'] = request_id
  end

  def set_auth_response_headers(token)
    response.headers['Authorization'] = "Bearer #{token}"
    response.headers['Client'] = 'plannerapi'
  end
end
