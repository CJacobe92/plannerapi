# frozen_string_literal: true

# Controller responsible for handling API endpoints related to users.

module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, except: %i[create index]

      def index
        @users = User.includes(categories: :tasks)
        render 'index', status: :ok
      end

      def create
        @user = User.new(user_params)

        if @user.save
          render 'create', status: :created
        else
          render 'create', status: :unprocessable_entity
        end
      end

      def show
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

      def set_user
        @current_user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Resource not found' }, status: :not_found
      end
    end
  end
end
