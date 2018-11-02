class Customer < ActiveRecord::Base

  # User has Customers, which have Treatments

  attr_accessible :name, :phone, :email
  before_validation :phone_clean

  self.per_page = 20

  has_many :treatments, :dependent => :restrict
  has_one :user, :through => :treatments  

  default_scope order('name ASC')

  def to_s
    name
  end

  validates :name, presence: true, length: { :maximum => 50 }
  validate :phone_format

private

  #Get rid of dashes
  def phone_clean
    phone.gsub!('-','') if phone
  end

  #Check phone number format
  def phone_format
    unless phone.nil?
      unless phone.length == 7 || phone.length == 10 || phone.length == 0
        errors.add(:phone, "phone number length must be 7 or 10 digits")
      end
    end
  end

  # Checked before attempting to delete a customer. Can't leave orphaned treatments
  def has_treatments
    unless treatments.nil?     
      self.errors[:base] << "Cannot delete customer because there are still treatments associated with this customer."
      return false   
    end 
  end

end
