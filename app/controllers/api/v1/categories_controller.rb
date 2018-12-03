module Api::V1
  class CategoriesController < ApplicationController

    def index
      @categories = Category.all
      render json: @categories
    end

    def show
      @categories = Category.all
      render json: @categories
    end

    def create
      categories = Category.new(category_params)
      categories.created_at = Time.current
      categories.updated_at = Time.current
      categories.user_id = 1111
      categories.save!
    end

    private

    def category_params
      params.require(:category).permit(:title, :created_at, :updated_at, :user_id)
    end

  end
end