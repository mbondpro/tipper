class ServicesController < ApplicationController

  before_filter :authenticate_user!

  def index
    @services = current_user.services.by_co.order(:name)  # Returned per company

    respond_to do |format|
      format.html
    end
  end

  def show
    @service = current_user.services.find(params[:id])

    respond_to do |format|
      format.html
      format.mobile { render json: @service.to_json }
      format.json { render json: @service.to_json }
    end
  end

  def new
    @service = Service.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @service = current_user.services.find(params[:id])
  end

  def create
    @service = current_user.services.build(params[:service])

    respond_to do |format|
      if @service.save
        format.html { redirect_to @service, notice: 'Service was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @service = current_user.services.find(params[:id])

    respond_to do |format|
      if @service.update_attributes(params[:service])
        format.html { redirect_to @service, notice: 'Service was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @service = current_user.services.find(params[:id])
    @service.destroy

    respond_to do |format|
      format.html { redirect_to services_url }
    end
  end

end

