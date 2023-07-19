# frozen_string_literal: true

# Controller responsible for handling API endpoints related to tasks.

module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_task, except: [:create, :index]

      def index
        @tasks = Task.all
        render 'index', status: :ok
      end

      def create
        @task = Task.new(task_params)

        if @task.save
          render 'create', status: :created
        else
          render 'create', status: :unprocessable_entity
        end
      end

      def show
        render 'show', status: :ok
      end

      def update
        @current_task.update(task_params)
        render 'update', status: :ok
      end

      def destroy
        @current_task.destroy
        render 'destroy', status: :ok
      end

      private

      def task_params
        params.require(:task).permit(:name, :urgent, :completed).merge(user_id: params[:user_id], category_id: params[:category_id])
      end

      def set_task
        @current_category = @current_user.categories.find(params[:category_id])
        @current_task = @current_category.tasks.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Task not found' }, status: :not_found
      end
    end
  end
end
