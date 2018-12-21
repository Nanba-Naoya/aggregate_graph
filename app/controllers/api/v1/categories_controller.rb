module Api::V1
  class CategoriesController < ApplicationController
    before_action :check_cookie, only: :create
    
    def show
      @categories = Category.where(user_id: params[:id])
      render json: @categories
    end

    def create
      category = Category.new(category_params)
      unless Category.search_title(category.title, cookies[:user_id]).blank?
        render json: { message: '同じカテゴリが存在します', status: 400 }
        return
      end
      category.created_at = Time.current
      category.updated_at = Time.current
      category.user_id = cookies[:user_id]
      category.save!
      render json: { message: 'ok', status: 200 }
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.record.errors.full_messages, status: 400 }
    end

    private

    def check_cookie
      if cookies[:user_id].nil?
        render json: { message: 'クッキーが消去されました', status: 500 }
        return
      end
    end

    def category_params
      params.require(:category).permit(:title, :created_at, :updated_at, :user_id)
    end

  end
end
