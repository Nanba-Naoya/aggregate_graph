module Api::V1
  class CategoriesController < ApplicationController
    before_action :check_cookie, only: :create
    before_action :create_first_category, only: :show

    def show
      @categories = Category.search_category(cookies[:user_id])
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
      return render json: { message: 'クッキーが消去されました', status: 500 } if cookies[:user_id].nil?
    end

    def create_first_category
      if Category.search_category(cookies[:user_id]).blank?
        category = Category.new(title: '会議', created_at: Time.current, updated_at: Time.current, user_id: cookies[:user_id])
        category.save!
      end
    end

    def category_params
      params.require(:category).permit(:title, :created_at, :updated_at, :user_id)
    end

  end
end
