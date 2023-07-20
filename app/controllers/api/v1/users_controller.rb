# frozen_string_literal: true

# Controller responsible for handling API endpoints related to users.
require 'headers_helper'

module Api
  module V1
    class UsersController < ApplicationController
    include HeadersHelper
      def index
        @users = User.includes(categories: :tasks)
        render 'index', status: :ok
      end

      def create
        @user = User.new(user_params)

        if @user.save
          token = encode_token(id: @user.id, firstname: @user.firstname, lastname: @user.lastname, email: @user.email, valid: true)
          @user.update!(token: token)
          response_headers(token)
          render 'create', status: :created
        else
          render 'create', status: :unprocessable_entity
        end
      end

      def show
        @current_user
        render 'show', status: :ok
      end

      def update
        return unless @current_user.update(user_params)

        render 'update', status: :ok
      end

      def destroy
        return unless @current_user.destroy

        render 'destroy', status: :ok
      end

      private

      def user_params
        params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation)
      end
    end
  end
end
