require 'rails_helper'

RSpec.describe Api::V1::CategoriesController, type: :controller do
  
  let!(:category1) do 
    [
      FactoryGirl.create(:category, title: '会議'),
      FactoryGirl.create(:category, title: '資料作成')
    ]
  end

  describe "GET #index" do
    before do
      get :index
    end
    it '必要な値がセットされている' do
      expect(controller.instance_variable_get('@categories')).to eq category1[0..1]
    end
  end

  describe "POST #create" do
    before do
      get :create, params: {category: {title: category1[0].title}}
    end
    it 'responseが正しいか' do
      expect(JSON.parse(response.body)['message']).to eq('ok')
      expect(JSON.parse(response.body)['status']).to eq(200)
    end
  end

end