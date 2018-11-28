module Api::V1
  class ShowGraphController < ApplicationController
    before_action :calc_work_time, only: [:show]

    def show

    end

    private

    def calc_work_time
      categories = Category.all
      work_times = WorkTime.all
      params.select[:name] 
    end

  end
end