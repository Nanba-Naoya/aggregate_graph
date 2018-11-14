module Api::V1
  class WorkTimesController < ApplicationController

    def index
      @work_times = WorkTime.all
      render json: @work_times
    end

    def show
      @work_times = WorkTime.all
      render json: @work_times
    end

  end
end