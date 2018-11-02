class User < ActiveRecord::Base

  # User is central node in the data model. Has services, customers, copanies, etc.
  # Use Devise for auth

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  # commission_rate is default commission for cost of services, 
  # and high_commission is alternate after meeting weekly goals. Goal is the weekly goal.
  attr_accessible :commission_rate, :email, :name, :username, :goal, :high_commission

  has_many :treatments
  has_many :acts, :through => :treatments
  has_many :customers, :through => :treatments, :uniq => true
  has_many :companies
  has_many :services, :through => :companies

  validates :commission_rate, presence: true, 
    numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1}
  validates :high_commission, presence: true, 
    numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1}

  # Need a default company, in case User has more than 1
  def main_co
    companies.main.first    
  end

  # Shorthand for the company's list of Services
  def main_services
    main_co.services
  end

  def to_s
    name
  end

end
