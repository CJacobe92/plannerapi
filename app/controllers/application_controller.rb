# frozen_string_literal: true
require 'token_helper'

class ApplicationController < ActionController::API
  include TokenHelper
  before_action :authenticate, except: [:create]

  def authenticate
    header = request.headers['Authorization']

    if header.blank?
      render json: { error: 'Auth header missing' }, status: :unauthorized
      return
    end

    sanitized_header = header.split(" ").last

    begin
      data = decode_token(sanitized_header)
      expiry = data['expiry']
      id = data['id']

      if data && expiry <= Time.now
        render json: {error: 'Token expired'}, status: :unauthorized
      else
        verified_user = User.find_by(id: id)

        if verified_user && verified_user.token == sanitized_header
          @current_user = verified_user
        else
          render json: {error: 'Invalid token' }, status: :unauthorized
        end
      end
    rescue JWT::DecodeError => e
      render json: { error: e.message }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Resource not found' }, status: :not_found
    end
  end
end
