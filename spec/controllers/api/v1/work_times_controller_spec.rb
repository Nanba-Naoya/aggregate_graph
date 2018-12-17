require 'rails_helper'
require 'google/api_client'

RSpec.describe Api::V1::WorkTimesController, type: :controller do
  
  let!(:work_times) do 
    [
      FactoryGirl.create(:work_time, time: '1.5', category_id: 1),
      FactoryGirl.create(:work_time, time: '2.0', category_id: 1),
      FactoryGirl.create(:work_time, time: '2.0', category_id: 1, created_at: '2018-12-13 12:00:00'),
      FactoryGirl.create(:work_time, time: '3.0', category_id: 2),
      FactoryGirl.create(:work_time, time: '1.0', category_id: 2),
      FactoryGirl.create(:work_time, time: '1.0', category_id: 2, created_at: '2018-12-13 12:00:00'),
      FactoryGirl.create(:work_time, time: '2.5', category_id: 3)
    ]
  end

  let!(:categories) do
    [
      FactoryGirl.create(:category, id: 1, title: '会議'),
      FactoryGirl.create(:category, id: 2, title: '資料作成'),
      FactoryGirl.create(:category, id: 3, title: '開発')
    ]
  end

  describe "GET #index" do
    describe '日別の集計' do
      context '集計できた場合' do
        it 'responseが正しいか' do
          get :index, params: {type_flag: 'false', month: 12, day: 12}
          expect((JSON.parse(response.body))['会議']).to eq('3.5')
          expect((JSON.parse(response.body))['資料作成']).to eq('4.0')
          expect((JSON.parse(response.body))['開発']).to eq('2.5')
        end
      end

      context '集計した結果何もデータがない場合' do
        it 'エラーが返ってくる' do
          get :index, params: {type_flag: 'false', month: 13, day: 32}
          expect(JSON.parse(response.body)['message']).to eq('データが見つかりません')
          expect(JSON.parse(response.body)['status']).to eq(404)
        end
      end
    end

    describe '月別の集計' do
      context '集計できた場合' do
        it 'responseが正しいか' do
          get :index, params: {type_flag: 'false', month: 12}
          expect((JSON.parse(response.body))['会議']).to eq('5.5')
          expect((JSON.parse(response.body))['資料作成']).to eq('5.0')
          expect((JSON.parse(response.body))['開発']).to eq('2.5')
        end
      end

      context '集計した結果何もデータがない場合' do
        it 'エラーが返ってくる' do
          get :index, params: {type_flag: 'false', month: 13}
          expect(JSON.parse(response.body)['message']).to eq('データが見つかりません')
          expect(JSON.parse(response.body)['status']).to eq(404)
        end
      end
    end

    describe 'カテゴリごと日別の集計' do
      context '集計できた場合' do
        it 'responseが正しいか' do
          get :index, params: {type_flag: 'true', month: 12, day: 12, category_id: 1}
          expect((JSON.parse(response.body))['会議']).to eq('3.5')
        end
      end

      context '集計した結果何もデータがない場合' do
        it 'エラーが返ってくる' do
          get :index, params: {type_flag: 'true', month: 13, day: 31}
          expect(JSON.parse(response.body)['message']).to eq('データが見つかりません')
          expect(JSON.parse(response.body)['status']).to eq(404)
        end
      end
    end

    describe 'カテゴリごと月別の集計' do
      context '集計できた場合' do
        it 'responseが正しいか' do
          get :index, params: {type_flag: 'true', month: 12, category_id: 2}
          expect((JSON.parse(response.body))['資料作成']).to eq('5.0')
        end
      end

      context '集計した結果何もデータがない場合' do
        it 'エラーが返ってくる' do
          get :index, params: {type_flag: 'true', month: 13, day: 31}
          expect(JSON.parse(response.body)['message']).to eq('データが見つかりません')
          expect(JSON.parse(response.body)['status']).to eq(404)
        end
      end
    end
  end

  describe "POST #create" do
    context 'リクエストが正しい場合' do
      before do
        post :create, params: {work_time: {hour: '10', minute: '40', work_time: '10'}}
      end
      it 'responseが正しいか' do
        expect(JSON.parse(response.body)['message']).to eq('ok')
        expect(JSON.parse(response.body)['status']).to eq(200)
      end
    end

    context 'リクエストが正しくない場合' do
      before do 
        post :create, params: {work_time: {hour: 0, minute: 0, work_time: '11'}}
      end
      it 'エラーが返ってきている' do
        expect(JSON.parse(response.body)['message']).to eq(["Time can't be blank"])
        expect(JSON.parse(response.body)['status']).to eq(400)
      end
    end
  end

  describe "POST #inport_work_times" do
    before do
      allow_any_instance_of(Google::CalendarsService).to receive(:google_calendar_api)
      .and_return [summary: "テスト", description: "テスト", start: {dateTime: DateTime.parse("2018-12-17 12:00:00")}, end: {dateTime: DateTime.parse('2018-12-17 13:00:00')}]
      post :import_work_times
    end
    it 'responseが正しいか' do
      expect(JSON.parse(response.body)['message']).to eq('ok')
      expect(JSON.parse(response.body)['status']).to eq(200)
    end
  end

end
