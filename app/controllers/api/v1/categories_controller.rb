module Api::V1
  class CategoriesController < ApplicationController

    def index
      @categories = Category.all
      render json: @categories
    end

    def show
      @categories = Category.find(params[:id])
      render json: @categories
    end

  end
end