class TreatmentsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @treatments = current_user.treatments.page(params[:page]).order('date DESC')

    respond_to do |format|
      format.html
    end
  end

  def show
    @treatment = current_user.treatments.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def new
    @treatment = current_user.treatments.build
    @met_goals = @treatment.met_goals?  # Weekly commission goal met?
    @treatment.commission = @treatment.correct_commission  # Then adjust commission

    respond_to do |format|
      format.html
    end
  end

  def edit
    @treatment = current_user.treatments.find(params[:id])
    @met_goals = @treatment.met_goals?
  end

  # Can only create customers via a new Treatment
  def create
    @treatment = current_user.treatments.build(params[:treatment])
    grab_new_customer  # Private method below

    respond_to do |format|
      if @treatment.save
        adjust_commissions(@treatment)  # Private method below
        format.html { redirect_to @treatment, notice: 'Treatment was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @treatment = current_user.treatments.find(params[:id])
    grab_new_customer

    respond_to do |format|
      if @treatment.update_attributes(params[:treatment])
        adjust_commissions(@treatment)
        format.html { redirect_to @treatment, notice: 'Treatment was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @treatment = current_user.treatments.find(params[:id])
    @treatment.destroy

    respond_to do |format|
      format.html { redirect_to treatments_url }
    end
  end

private

  # Build new customer by grabbing name & info from new Treatment form
  def grab_new_customer
    unless params[:customer][:name].blank?
      c = Customer.create(params[:customer]) 
      @treatment.customer_id = c.id
    end
  end

  # Check if weekly goal was met; if so, increase commission
  def adjust_commissions(treatment)
    if treatment.met_goals?
      treatments_for_week = treatment.user.treatments.during_week(treatment.week)
      treatments_for_week.each do |t| 
        t.commission = t.user.high_commission
        t.save!
      end
    end
  end

end
