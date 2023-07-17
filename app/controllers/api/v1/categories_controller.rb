# frozen_string_literal: true

# Controller responsible for handling API endpoints related to categories.

module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :set_category, except: %i[create index]

      def index
        @categories = Category.all
        render 'index', status: :ok
      end

      def create
        @category = Category.new(category_params)

        if @category.save
          render status: :created
        else
          render status: :unprocessable_entity
        end
      end

      def show
        render status: :ok
      end

      def update
        return unless @current_category.update(category_params)

        render status: :ok
      end

      def destroy
        return unless @current_category.destroy

        render status: :ok
      end

      private

      def category_params
        params.require(:category).permit(:name).merge(user_id: params[:user_id])
      end

      def set_category
        @current_user = User.find(params[:user_id])
        @current_category = @current_user.categories.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Category not found' }, status: :not_found
      end
    end
  end
end
