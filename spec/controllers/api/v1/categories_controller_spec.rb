require 'rails_helper'

RSpec.describe Api::V1::CategoriesController, type: :controller do
  
  let!(:categories) do 
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
      expect(JSON.parse(response.body).map{|item| item['title']}).to eq(['会議', '資料作成'])
    end
  end

  describe "POST #create" do
    context '保存できた場合' do 
      before do
        post :create, params: {category: {title: 'テスト'}}
      end
      it 'responseが正しいか' do
        expect(JSON.parse(response.body)['message']).to eq('ok')
        expect(JSON.parse(response.body)['status']).to eq(200)
        expect(Category.last.title).to eq 'テスト'
      end
    end

    context '保存できなかった場合' do
      before do 
        post :create, params: {category: {title: ''}}
      end
      it 'エラーが返ってきている' do
        expect(JSON.parse(response.body)['message']).to eq('バリデーションエラー')
        expect(JSON.parse(response.body)['status']).to eq(500)
      end
    end
  end

end
