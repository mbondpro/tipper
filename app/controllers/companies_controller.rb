class CompaniesController < ApplicationController

  # Users have 1+ companies, and everything belongs to the user's company

  before_filter :authenticate_user!

  def index
    @companies = current_user.companies.all

    respond_to do |format|
      format.html
    end
  end

  def show
    @company = current_user.companies.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def new
    @company = Company.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @company = current_user.companies.find(params[:id])
  end

  def create
    @company = current_user.companies.new(params[:company])

    respond_to do |format|
      if @company.save
        format.html { redirect_to companies_url, notice: 'Company was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @company = current_user.companies.find(params[:id])

    respond_to do |format|
      if @company.update_attributes(params[:company])
        format.html { redirect_to companies_url, notice: 'Company was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @company = current_user.companies.find(params[:id])

	begin
	  @company.destroy
	rescue ActiveRecord::DeleteRestrictionError => e
	  @company.errors.add(:base, e)
	end

    # Prevents cascading deletions of a company and its data
    respond_to do |format|
	  if @company.errors.any?
        format.html { redirect_to companies_url, alert: "You cannot delete a company that has services." }
	  else
    		format.html { redirect_to companies_url }
	  end

    end
  end
end
