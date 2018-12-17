module Api::V1
  class CategoriesController < ApplicationController

    def index
      @categories = Category.all
      render json: @categories
    end

    def create
      category = Category.new(category_params)
      category.created_at = Time.current
      category.updated_at = Time.current
      category.user_id = 1111
      category.save!
      render json: {message: 'ok', status: 200}
    rescue ActiveRecord::RecordInvalid => e
      render json: {message: 'バリデーションエラー', status: 500}
    end

    private

    def category_params
      params.require(:category).permit(:title, :created_at, :updated_at, :user_id)
    end

  end
end