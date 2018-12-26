require 'rails_helper'

RSpec.describe Api::V1::CategoriesController, type: :controller do
  
  let!(:categories) do 
    [
      FactoryBot.create(:category, title: '会議'),
      FactoryBot.create(:category, title: '資料作成')
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
    context 'リクエストが正しい場合' do 
      before do
        post :create, params: {category: {title: 'テスト'}}
      end
      it 'responseが正しいか' do
        expect(JSON.parse(response.body)['message']).to eq('ok')
        expect(JSON.parse(response.body)['status']).to eq(200)
        expect(Category.last.title).to eq 'テスト'
      end
    end

    context 'titleが空白の場合' do
      before do 
        post :create, params: {category: {title: ''}}
      end
      it 'エラーが返ってきている' do
        expect(JSON.parse(response.body)['message']).to eq(["Title can't be blank"])
        expect(JSON.parse(response.body)['status']).to eq(400)
      end
    end
  end

end
