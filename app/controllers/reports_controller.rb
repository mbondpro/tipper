class ReportsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @rpt = Report.new(current_user)

    respond_to do |format|
      format.html
    end
  end

end
