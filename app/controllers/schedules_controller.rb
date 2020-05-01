class SchedulesController < ApplicationController
  def index
    @schedules = Schedule.last
    respond_to do |format|
      format.html
      format.js
    end
  end
end