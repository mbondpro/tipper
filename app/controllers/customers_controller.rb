class CustomersController < ApplicationController

  # User has customers

  before_filter :authenticate_user!

  def index
    @cust = current_user.customers  
    @customers = @cust.paginate(:page => params[:page])
    @customers.total_entries = @cust.length #Currently have issues counting no. due to Distinct clause

    respond_to do |format|
      format.html
    end
  end

  def show
    # Search by name, else gracefully try other things
    name = params[:cust_name].try(:strip)
    if name.nil?
      @customer = current_user.customers.find(params[:id])
    else
      @customer = current_user.customers.where("name = ?", name).first
    end

    if @customer.nil?  # still not found, check for partial matches
      @customers = current_user.customers.where("name like ?", "%#{name}%") 
    else  # exact match, show treatments
      @treatments = @customer.treatments.page(params[:page]).order('date DESC') unless @customer.nil?
    end

    respond_to do |format|
      if @customer.nil?  # did not find exact match
        format.html { render 'customers/search' }
      else
        format.html
      end
    end
  end

  def new
    @customer = Customer.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @customer = current_user.customers.find(params[:id])
  end

  def create
    @customer = current_user.customers.build(params[:customer])

    respond_to do |format|
      if @customer.save
        format.html { redirect_to customers_url, notice: 'Customer was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @customer = current_user.customers.find(params[:id])

    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        format.html { redirect_to customers_url, notice: 'Customer was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @customer = current_user.customers.find(params[:id])

	  begin
	    @customer.destroy
	  rescue ActiveRecord::DeleteRestrictionError => e  # Model prevents deletions if customer has treatments.
	    @customer.errors.add(:base, e)
	  end

    respond_to do |format|
	    if @customer.errors.any?
          format.html { redirect_to customer_url, alert: "You cannot delete a customer who has had treatments." }
	    else
		  format.html { redirect_to customer_url }
	    end
    end
  end

  # Custom method for search box
  def search
    name = params[:term]
    customers = current_user.customers.where("name like ?", "%#{name}%")
    @names = customers.map {|c| c['name']}

    respond_to do |format|
      format.json { render json: @names.to_json }
    end
  end

end
