require 'token_helper'
require 'headers_helper'

class Api::V1::AuthController < ApplicationController
  include TokenHelper
  include HeadersHelper

  def create
    @user = User.find_by(email: params[:auth][:email])

    if @user && @user.authenticate(params[:auth][:password])
      token = encode_token(id: @user.id, valid: true)
      @user.update!(token: token)

      response_headers(@user, token)

      render json: { message: "Login successful" }, status: :ok
    else
      render json: { error: "Invalid login credentials" }, status: :unauthorized
    end
  end

  private

  def auth_params
    params.require(:auth).permit(:email, :password)
  end
end
